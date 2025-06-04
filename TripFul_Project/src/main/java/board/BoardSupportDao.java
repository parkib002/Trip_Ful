package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import mysql.db.DbConnect; // 실제 사용하는 DB 연결 클래스 경로로 수정하세요.

public class BoardSupportDao {

    DbConnect db = new DbConnect();

    // 전체 원본글갯수 (relevel = 0 인 글)
    public int getTotalCount() {
        int n = 0;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "select count(*) from tripful_qna where relevel = 0";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                n = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return n;
    }

    // 새 regroup ID 생성을 위해 현재 qna_idx의 최대값을 가져옴
    // (실제로는 regroup 컬럼의 최대값을 가져오는 것이 더 정확할 수 있으나,
    // qna_idx의 MAX + 1을 regroup으로 사용하는 규칙을 따른다고 가정)
    public int getMaxNum() {
        int max = 0;
        String sql = "select ifnull(max(qna_idx),0) from tripful_qna";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                max = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return max;
    }

    // 답글 삽입 시 순서 조정을 위해 같은 그룹 내 특정 restep보다 큰 기존 답글들의 restep을 1씩 증가
    public void updateRestep(int regroup, int restep) {
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        String sql = "update tripful_qna set restep=restep+1 where regroup=? and restep>?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, regroup);
            pstmt.setInt(2, restep);
            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
    }

    /**
     * 새 게시글 또는 답변 글을 DB에 저장합니다.
     * - 원본 글: DTO에 regroup=0, restep=0, relevel=0 으로 설정하여 호출합니다.
     * - 답변 글: DTO에 부모 글의 regroup, restep, relevel을 설정하여 호출합니다.
     */
    public void insertReboard(BoardSupportDto dto) {
        int finalRegroup;
        int finalRestep;
        int finalRelevel;

        // 원본 글인지 답변 글인지 판단 (약속된 DTO 값 기준)
        if (dto.getRegroup() == 0 && dto.getRestep() == 0 && dto.getRelevel() == 0) {
            // 새 원본 글 처리
            finalRegroup = this.getMaxNum() + 1; // 새 그룹 ID
            finalRestep = 0;
            finalRelevel = 0;
        } else {
            // 답변 글 처리 (DTO에는 부모 글의 regroup, restep, relevel이 담겨 있어야 함)
            finalRegroup = dto.getRegroup();   // 부모의 regroup
            int parentRestep = dto.getRestep();     // 부모의 restep
            int parentRelevel = dto.getRelevel();   // 부모의 relevel

            // 1. 같은 그룹 내에서 부모의 restep보다 큰 기존 답글들의 순서를 조정
            this.updateRestep(finalRegroup, parentRestep);

            // 2. 새 답글의 restep과 relevel 계산
            finalRestep = parentRestep + 1;
            finalRelevel = parentRelevel + 1;
        }

        String sql = "insert into tripful_qna (qna_title, qna_content, qna_img, qna_writer, qna_private, qna_readcount, qna_writeday, qna_category, regroup, restep, relevel) " +
                     "values (?,?,?,?,?,0,now(),?,?,?,?)"; // qna_idx는 자동 증가

        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;

        try {
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, dto.getQna_title());
            pstmt.setString(2, dto.getQna_content());
            pstmt.setString(3, dto.getQna_img());       // 파일 없으면 null
            pstmt.setString(4, dto.getQna_writer());
            pstmt.setString(5, dto.getQna_private());   // "0" 또는 "1"
            // qna_readcount는 SQL에서 0으로 자동 설정
            // qna_writeday는 SQL에서 now()로 자동 설정
            pstmt.setString(6, dto.getQna_category());
            pstmt.setInt(7, finalRegroup);      // 계산된 regroup
            pstmt.setInt(8, finalRestep);       // 계산된 restep
            pstmt.setInt(9, finalRelevel);      // 계산된 relevel

            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
    }

    // 특정 qna_idx에 해당하는 게시글/답변 정보 가져오기
    public BoardSupportDto getData(String idx) {
        BoardSupportDto dto = null; // 데이터를 못 찾을 경우 null 반환하도록 초기화
        String sql = "select * from tripful_qna where qna_idx=?";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, idx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardSupportDto(); // 데이터가 있을 때만 객체 생성
                dto.setQna_idx(rs.getString("qna_idx"));
                dto.setQna_title(rs.getString("qna_title"));
                dto.setQna_content(rs.getString("qna_content"));
                dto.setQna_img(rs.getString("qna_img"));
                dto.setQna_writer(rs.getString("qna_writer"));
                dto.setQna_private(rs.getString("qna_private"));
                dto.setQna_readcount(rs.getInt("qna_readcount"));
                dto.setQna_writeday(rs.getTimestamp("qna_writeday"));
                dto.setQna_category(rs.getString("qna_category"));
                dto.setRegroup(rs.getInt("regroup"));
                dto.setRestep(rs.getInt("restep"));
                dto.setRelevel(rs.getInt("relevel"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return dto;
    }

    // 조회수 1 증가
    public void updateReadCount(String idx) {
        String sql = "update tripful_qna set qna_readcount=qna_readcount+1 where qna_idx=?";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, idx);
            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
    }

    // 페이징을 위한 원본 글 목록 가져오기
    public List<BoardSupportDto> getAllDatas(int startNum, int perPage) {
        List<BoardSupportDto> list = new Vector<BoardSupportDto>();
        String sql = "select * from tripful_qna where relevel = 0 order by regroup desc, restep asc limit ?, ?";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, startNum);
            pstmt.setInt(2, perPage);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BoardSupportDto dto = new BoardSupportDto();
                dto.setQna_idx(rs.getString("qna_idx"));
                dto.setQna_title(rs.getString("qna_title"));
                // dto.setQna_content(rs.getString("qna_content")); // 목록에서는 보통 내용 전체를 가져오지 않음
                dto.setQna_img(rs.getString("qna_img"));
                dto.setQna_writer(rs.getString("qna_writer"));
                dto.setQna_private(rs.getString("qna_private"));
                dto.setQna_readcount(rs.getInt("qna_readcount"));
                dto.setQna_writeday(rs.getTimestamp("qna_writeday"));
                dto.setQna_category(rs.getString("qna_category"));
                dto.setRegroup(rs.getInt("regroup"));
                dto.setRestep(rs.getInt("restep"));
                dto.setRelevel(rs.getInt("relevel"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 특정 regroup에 속한 모든 답변 글 목록 가져오기 (답변은 순서대로)
    public List<BoardSupportDto> getRepliesByRegroup(int regroup) {
        List<BoardSupportDto> list = new Vector<BoardSupportDto>();
        String sql = "SELECT * FROM tripful_qna WHERE regroup = ? AND relevel > 0 ORDER BY restep asc";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, regroup);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BoardSupportDto dto = new BoardSupportDto();
                dto.setQna_idx(rs.getString("qna_idx"));
                dto.setQna_title(rs.getString("qna_title"));
                dto.setQna_content(rs.getString("qna_content")); // 답변 내용은 가져옴
                dto.setQna_img(rs.getString("qna_img"));
                dto.setQna_writer(rs.getString("qna_writer"));
                dto.setQna_private(rs.getString("qna_private"));
                dto.setQna_readcount(rs.getInt("qna_readcount"));
                dto.setQna_writeday(rs.getTimestamp("qna_writeday"));
                dto.setQna_category(rs.getString("qna_category"));
                dto.setRegroup(rs.getInt("regroup"));
                dto.setRestep(rs.getInt("restep"));
                dto.setRelevel(rs.getInt("relevel"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 게시글/답변 수정
    public boolean updateSupport(BoardSupportDto dto) {
        boolean success = false;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        String sql = "UPDATE tripful_qna SET qna_title=?, qna_content=?, qna_img=?, qna_private=?, qna_category=? WHERE qna_idx=?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getQna_title());
            pstmt.setString(2, dto.getQna_content());
            pstmt.setString(3, dto.getQna_img());
            pstmt.setString(4, dto.getQna_private());
            pstmt.setString(5, dto.getQna_category());
            pstmt.setString(6, dto.getQna_idx());
            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) { // SQLException 명시
            System.out.println("updateSupport 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }

    // 게시글/답변 삭제
    public boolean deleteSupport(String qna_idx) {
        boolean success = false;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM tripful_qna WHERE qna_idx=?";
        try {
            pstmt = conn.prepareStatement(sql);
            // qna_idx가 DB에서 숫자형이면 Integer.parseInt(qna_idx) 또는 Long.parseLong(qna_idx) 후 setInt/setLong 사용
            pstmt.setString(1, qna_idx);
            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) { // SQLException 명시
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }
    
 // BoardSupportDao.java
 // ... (기존 getTotalCount, getMaxNum, updateRestep, insertReboard, getData, updateReadCount, getAllDatas, getRepliesByRegroup, updateSupport, deleteSupport 메소드들은 그대로 둡니다) ...

     // --- 통합 검색용 메소드 (수정된 부분) ---
     /**
      * 고객센터(Q&A) 검색 결과의 전체 개수를 반환합니다.
      * @param keyword 검색어
      * @return 검색된 총 게시물 수
      */
     public int getSearchSupportTotalCount(String keyword) {
         int total = 0;
         Connection conn = db.getConnection();
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         // qna_title 또는 qna_content에서 키워드 검색
         String sql = "select count(*) from tripful_qna where qna_title like ? or qna_content like ?"; // 테이블명 및 컬럼명 수정

         try {
             pstmt = conn.prepareStatement(sql);
             pstmt.setString(1, "%" + keyword + "%");
             pstmt.setString(2, "%" + keyword + "%");
             rs = pstmt.executeQuery();
             if (rs.next()) {
                 total = rs.getInt(1);
             }
         } catch (SQLException e) {
             System.out.println("Support Search Total Count Error: " + e.getMessage());
             e.printStackTrace();
         } finally {
             db.dbClose(rs, pstmt, conn);
         }
         return total;
     }

     /**
      * 키워드로 고객센터(Q&A) 게시물을 검색하고 페이징 처리된 목록을 반환합니다.
      * 검색 결과에는 원글과 답글이 섞여 나올 수 있으며, 정렬은 Q&A 특성에 맞게 regroup, restep 사용.
      * @param keyword 검색어
      * @param startNum 가져올 데이터의 시작 위치 (offset)
      * @param perPage 페이지당 보여줄 게시물 수
      * @return 검색된 Q&A 목록 (List<BoardSupportDto>)
      */
     public List<BoardSupportDto> searchSupport(String keyword, int startNum, int perPage) {
         List<BoardSupportDto> list = new ArrayList<>(); // 반환 타입에 맞게 ArrayList 사용 가능
         // 정렬 순서: 원글(regroup) 최신순(DESC), 같은 원글 내에서는 답글(restep) 순서대로(ASC)
         String sql = "select * from tripful_qna where qna_title like ? or qna_content like ? order by regroup desc, restep asc limit ?,?"; // 테이블명 및 정렬 수정
         Connection conn = db.getConnection();
         PreparedStatement pstmt = null;
         ResultSet rs = null;

         try {
             pstmt = conn.prepareStatement(sql);
             pstmt.setString(1, "%" + keyword + "%");
             pstmt.setString(2, "%" + keyword + "%");
             pstmt.setInt(3, startNum);
             pstmt.setInt(4, perPage);
             rs = pstmt.executeQuery();
             while (rs.next()) {
                 BoardSupportDto dto = new BoardSupportDto(); // BoardSupportDto 사용
                 dto.setQna_idx(rs.getString("qna_idx"));
                 dto.setQna_category(rs.getString("qna_category"));
                 dto.setQna_title(rs.getString("qna_title"));
                 // dto.setQna_content(rs.getString("qna_content")); // 목록에서는 보통 제목만, 필요시 주석 해제
                 dto.setQna_writer(rs.getString("qna_writer"));
                 dto.setQna_img(rs.getString("qna_img"));
                 dto.setQna_private(rs.getString("qna_private"));
                 dto.setQna_writeday(rs.getTimestamp("qna_writeday"));
                 dto.setQna_readcount(rs.getInt("qna_readcount"));
                 dto.setRegroup(rs.getInt("regroup"));
                 dto.setRestep(rs.getInt("restep"));
                 dto.setRelevel(rs.getInt("relevel"));
                 list.add(dto);
             }
         } catch (SQLException e) {
             System.out.println("Search Support Error: " + e.getMessage()); // 에러 메시지 수정
             e.printStackTrace();
         } finally {
             db.dbClose(rs, pstmt, conn);
         }
         return list;
     }
     
     
}
