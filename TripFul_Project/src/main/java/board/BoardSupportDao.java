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

    // 검색 기능은 필터링 조건 추가가 필요하면 유사하게 수정 (현재는 유지)
    public int getSearchSupportTotalCount(String keyword) {
        int total = 0;
        // ... (기존 코드)
        // 만약 검색 시에도 답변 상태 필터를 적용하려면, 이 메소드도 filter 파라미터를 받고 SQL을 수정해야 합니다.
        return total;
    }

    public List<BoardSupportDto> searchSupport(String keyword, int startNum, int perPage) {
        List<BoardSupportDto> list = new ArrayList<>();
        // ... (기존 코드)
        // 만약 검색 시에도 답변 상태 필터를 적용하려면, 이 메소드도 filter 파라미터를 받고 SQL을 수정해야 합니다.
        // dto.setAnswered(rs.getBoolean("answered_status")); 부분은 이미 추가되어 있습니다.
        return list;
    }
}