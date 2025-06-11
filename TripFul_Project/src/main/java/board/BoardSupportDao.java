package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect; // 실제 사용하는 DB 연결 클래스 경로로 수정하세요.

public class BoardSupportDao {

    DbConnect db = new DbConnect();
    
    //미답변 글갯수
    public int getUnansweredTotalCount() {
        int n = 0;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 원본글(relevel=0)이면서, 해당 글과 같은 그룹(regroup)에 속한 답변글(relevel > 0)이 존재하지 않는 글의 수를 센다.
        String sql = "SELECT count(*) FROM tripful_qna q WHERE q.relevel = 0 " +
                     "AND NOT EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0)";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                n = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getUnansweredTotalCount 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return n;
    }

    // 전체 원본글갯수 (relevel = 0 인 글) - 필터링 조건 추가
    public int getTotalCount(String filter) { // filter 파라미터 추가
        int n = 0;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sqlBuilder = new StringBuilder("SELECT count(*) FROM tripful_qna q WHERE q.relevel = 0 ");

        // 필터 조건에 따라 WHERE 절 추가
        if ("answered".equals(filter)) {
            sqlBuilder.append("AND EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) ");
        } else if ("unanswered".equals(filter)) {
            sqlBuilder.append("AND NOT EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) ");
        }
        // "all" 또는 그 외의 경우 추가 조건 없음

        try {
            pstmt = conn.prepareStatement(sqlBuilder.toString());
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

    public void insertReboard(BoardSupportDto dto) {
        int finalRegroup;
        int finalRestep;
        int finalRelevel;

        if (dto.getRegroup() == 0 && dto.getRestep() == 0 && dto.getRelevel() == 0) {
            finalRegroup = this.getMaxNum() + 1;
            finalRestep = 0;
            finalRelevel = 0;
        } else {
            finalRegroup = dto.getRegroup();
            int parentRestep = dto.getRestep();
            int parentRelevel = dto.getRelevel();
            this.updateRestep(finalRegroup, parentRestep);
            finalRestep = parentRestep + 1;
            finalRelevel = parentRelevel + 1;
        }

        String sql = "insert into tripful_qna (qna_title, qna_content, qna_img, qna_writer, qna_private, qna_readcount, qna_writeday, qna_category, regroup, restep, relevel) " +
                     "values (?,?,?,?,?,0,now(),?,?,?,?)";

        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getQna_title());
            pstmt.setString(2, dto.getQna_content());
            pstmt.setString(3, dto.getQna_img());
            pstmt.setString(4, dto.getQna_writer());
            pstmt.setString(5, dto.getQna_private());
            pstmt.setString(6, dto.getQna_category());
            pstmt.setInt(7, finalRegroup);
            pstmt.setInt(8, finalRestep);
            pstmt.setInt(9, finalRelevel);
            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
    }
    
    
    //idx기반으로 하나의 데이터 가져오기 삭제,수정
    public BoardSupportDto getData(String idx) {
        BoardSupportDto dto = null;
        String sql = "select * from tripful_qna where qna_idx=?";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, idx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardSupportDto();
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
    
    //id기반으로 전체 데이터 가져오기 
    public List<BoardSupportDto> getAllDataForMyPage(String writer) {
    	List<BoardSupportDto> list = new ArrayList<BoardSupportDto>();
    	
        String sql = "SELECT q.*, " +
                "EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) as answered_status " +
                "FROM tripful_qna q " +
                "WHERE q.qna_writer = ? ORDER BY q.regroup DESC, q.restep ASC";
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, writer);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	BoardSupportDto dto=new BoardSupportDto();
            	
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
                dto.setAnswered(rs.getBoolean("answered_status"));
                
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

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

    // 페이징을 위한 원본 글 목록 가져오기 (답변 상태 포함) - 필터링 조건 추가
    public List<BoardSupportDto> getAllDatas(int startNum, int perPage, String filter) { // filter 파라미터 추가
        List<BoardSupportDto> list = new ArrayList<BoardSupportDto>();

        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT q.*, ");
        sqlBuilder.append("EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) as answered_status ");
        sqlBuilder.append("FROM tripful_qna q ");
        sqlBuilder.append("WHERE q.relevel = 0 ");

        // 필터 조건에 따라 WHERE 절 추가
        if ("answered".equals(filter)) {
            sqlBuilder.append("AND EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) ");
        } else if ("unanswered".equals(filter)) {
            sqlBuilder.append("AND NOT EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) ");
        }
        // "all" 또는 그 외의 경우 추가 조건 없음

        sqlBuilder.append("ORDER BY q.regroup DESC, q.restep ASC LIMIT ?, ?");

        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            pstmt.setInt(1, startNum);
            pstmt.setInt(2, perPage);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                BoardSupportDto dto = new BoardSupportDto();
                dto.setQna_idx(rs.getString("qna_idx"));
                dto.setQna_title(rs.getString("qna_title"));
                dto.setQna_img(rs.getString("qna_img"));
                dto.setQna_writer(rs.getString("qna_writer"));
                dto.setQna_private(rs.getString("qna_private"));
                dto.setQna_readcount(rs.getInt("qna_readcount"));
                dto.setQna_writeday(rs.getTimestamp("qna_writeday"));
                dto.setQna_category(rs.getString("qna_category"));
                dto.setRegroup(rs.getInt("regroup"));
                dto.setRestep(rs.getInt("restep"));
                dto.setRelevel(rs.getInt("relevel"));
                dto.setAnswered(rs.getBoolean("answered_status"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    public List<BoardSupportDto> getRepliesByRegroup(int regroup) {
        List<BoardSupportDto> list = new ArrayList<BoardSupportDto>();
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
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

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
        } catch (SQLException e) {
            System.out.println("updateSupport 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }

    public boolean deleteSupport(String qna_idx) {
        boolean success = false;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM tripful_qna WHERE qna_idx=?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, qna_idx);
            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }

    /**
     * 고객센터(Q&A) 게시글 검색 결과의 총 개수를 반환합니다.
     * @param keyword 검색할 키워드 (제목 또는 내용)
     * @return 검색된 게시글의 총 개수
     */
    public int getSearchSupportTotalCount(String keyword) {
        int total = 0;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 제목 또는 내용에 키워드가 포함된 원본글(relevel=0)의 수를 셉니다.
        String sql = "SELECT count(*) FROM tripful_qna WHERE relevel=0 AND (qna_title LIKE ? OR qna_content LIKE ?)";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return total;
    }

    /**
     * 고객센터(Q&A) 게시글을 키워드로 검색하여 페이징 처리된 목록을 반환합니다.
     * @param keyword 검색할 키워드 (제목 또는 내용)
     * @param startNum 시작 번호
     * @param perPage 페이지당 게시글 수
     * @return 검색된 게시글 목록
     */
    public List<BoardSupportDto> searchSupport(String keyword, int startNum, int perPage) {
        List<BoardSupportDto> list = new ArrayList<>();
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 제목 또는 내용에 키워드가 포함된 원본글(relevel=0)을 찾고, 답변 상태까지 함께 조회합니다.
        String sql = "SELECT q.*, " +
                     "EXISTS (SELECT 1 FROM tripful_qna r WHERE r.regroup = q.regroup AND r.relevel > 0) as answered_status " +
                     "FROM tripful_qna q " +
                     "WHERE q.relevel = 0 AND (q.qna_title LIKE ? OR q.qna_content LIKE ?) " +
                     "ORDER BY q.regroup DESC, q.restep ASC LIMIT ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setInt(3, startNum);
            pstmt.setInt(4, perPage);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardSupportDto dto = new BoardSupportDto();
                dto.setQna_idx(rs.getString("qna_idx"));
                dto.setQna_title(rs.getString("qna_title"));
                dto.setQna_content(rs.getString("qna_content"));
                dto.setQna_writer(rs.getString("qna_writer"));
                dto.setQna_private(rs.getString("qna_private"));
                dto.setQna_writeday(rs.getTimestamp("qna_writeday"));
                dto.setRegroup(rs.getInt("regroup"));
                dto.setAnswered(rs.getBoolean("answered_status")); // 답변 상태 설정
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }
}