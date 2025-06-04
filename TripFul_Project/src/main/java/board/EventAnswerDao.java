package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import mysql.db.DbConnect; // DbConnect 클래스의 실제 경로로 수정해주세요.

public class EventAnswerDao {

    DbConnect db = new DbConnect();
    
    /**
     * 특정 이벤트의 전체 댓글 수를 가져옵니다.
     * @param event_idx 원본 이벤트 ID
     * @return 전체 댓글 수
     */
    public int getTotalAnswerCount(String event_idx) {
        int total = 0;
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "select count(*) from tripful_event_answer where event_idx = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, event_idx);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("댓글 전체 수 조회 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return total;
    }


    //페이징
    public List<EventAnswerDto> getAnswersByEventIdxWithPaging(String event_idx, String loggedInUserId, int start, int count) {
        List<EventAnswerDto> list = new ArrayList<>();
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // 최신 댓글이 위로 오도록 정렬 (answer_idx 또는 writeday 기준 DESC)
        String sql = "select * from tripful_event_answer where event_idx = ? order by answer_idx desc limit ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, event_idx);
            pstmt.setInt(2, start); // MySQL의 limit offset
            pstmt.setInt(3, count); // MySQL의 limit row_count

            rs = pstmt.executeQuery();

            while (rs.next()) {
                EventAnswerDto dto = new EventAnswerDto();
                String answerIdx = rs.getString("answer_idx");
                dto.setAnswer_idx(answerIdx);
                dto.setContent(rs.getString("content"));
                dto.setWriter(rs.getString("writer"));
                dto.setWriteday(rs.getTimestamp("writeday"));
                dto.setEvent_idx(rs.getString("event_idx"));
                dto.setLikecount(rs.getInt("likecount"));

                if (loggedInUserId != null && !loggedInUserId.isEmpty()) {
                    dto.setUserHasLiked(hasUserLiked(answerIdx, loggedInUserId));
                } else {
                    dto.setUserHasLiked(false);
                }
                list.add(dto);
            }
        } catch (SQLException e) {
            System.out.println("페이징된 댓글 목록 조회 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    
    //댓글 추가
    public boolean addAnswer(EventAnswerDto dto) {
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        // writeday는 DB에서 now()로, likecount는 0으로 초기화
        String sql = "insert into tripful_event_answer (content, writer, event_idx, writeday, likecount) values (?, ?, ?, now(), 0)";
        boolean success = false;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getContent());
            pstmt.setString(2, dto.getWriter());    // member 테이블의 id
            pstmt.setString(3, dto.getEvent_idx()); // event 테이블의 event_idx

            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) {
            System.out.println("댓글 추가 오류: " + e.getMessage());
            // 실제 운영 환경에서는 e.printStackTrace() 대신 로깅 프레임워크 사용을 권장합니다.
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }

 // 특정 이벤트의 댓글 목록 가져오기 (로그인 사용자 ID 파라미터 추가)
    public List<EventAnswerDto> getAnswersByEventIdx(String event_idx, String loggedInUserId) {
        List<EventAnswerDto> list = new ArrayList<>();
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "select * from tripful_event_answer where event_idx = ? order by writeday asc";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, event_idx);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                EventAnswerDto dto = new EventAnswerDto();
                String answerIdx = rs.getString("answer_idx"); // 현재 댓글 ID
                dto.setAnswer_idx(answerIdx);
                dto.setContent(rs.getString("content"));
                dto.setWriter(rs.getString("writer"));
                dto.setWriteday(rs.getTimestamp("writeday"));
                dto.setEvent_idx(rs.getString("event_idx"));
                dto.setLikecount(rs.getInt("likecount"));

                // ★ 현재 로그인한 사용자가 이 댓글에 좋아요를 눌렀는지 확인
                if (loggedInUserId != null && !loggedInUserId.isEmpty()) {
                    dto.setUserHasLiked(hasUserLiked(answerIdx, loggedInUserId));
                } else {
                    dto.setUserHasLiked(false); // 로그인하지 않았으면 false
                }
                list.add(dto);
            }
        } catch (SQLException e) {
            System.out.println("댓글 목록 조회 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    //댓글삭제
    public boolean deleteAnswer(String answer_idx, String writer_id) {
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        // writer_id 조건 추가하여 본인 댓글만 삭제 가능하도록 방어
        String sql = "delete from tripful_event_answer where answer_idx = ? and writer = ?";
        boolean success = false;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, answer_idx);
            pstmt.setString(2, writer_id);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) {
            System.out.println("댓글 삭제 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }
    
    /**
     * 댓글 삭제 (관리자용)
     * @param answer_idx 삭제할 댓글 ID
     * @return 성공 시 true, 실패 시 false
     */
    public boolean deleteAnswerByAdmin(String answer_idx) {
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        String sql = "delete from tripful_event_answer where answer_idx = ?";
        boolean success = false;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, answer_idx);
            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) {
            System.out.println("관리자 댓글 삭제 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(pstmt, conn);
        }
        return success;
    }

    // --- 좋아요 관련 메소드 ---

    /**
     * 특정 사용자가 특정 댓글에 좋아요를 눌렀는지 확인합니다.
     * @param answer_idx 댓글 ID
     * @param user_id 사용자 ID
     * @return 좋아요를 눌렀으면 true, 아니면 false
     */
    public boolean hasUserLiked(String answer_idx, String user_id) {
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // 'tripful_event_answer_like' 테이블은 실제 사용하는 좋아요 기록 테이블명으로 변경해야 합니다.
        String sql = "select count(*) from tripful_event_answer_like where answer_idx = ? and user_id = ?";
        boolean liked = false;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, answer_idx);
            pstmt.setString(2, user_id);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                liked = true;
            }
        } catch (SQLException e) {
            System.out.println("사용자 좋아요 여부 확인 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return liked;
    }

    /**
     * 댓글 좋아요 상태를 토글합니다 (좋아요 추가 또는 취소).
     * 이 메소드는 트랜잭션으로 관리됩니다.
     * @param answer_idx 댓글 ID
     * @param user_id 사용자 ID
     * @return "liked" (좋아요 추가 성공), "unliked" (좋아요 취소 성공), 또는 "error" (실패)
     */
    public String toggleLike(String answer_idx, String user_id) {
        Connection conn = null;
        PreparedStatement pstmtLikeAction = null; // for insert/delete into tripful_event_answer_like
        PreparedStatement pstmtUpdateCount = null; // for updating likecount in tripful_event_answer
        String resultAction = "error";

        boolean alreadyLiked = hasUserLiked(answer_idx, user_id);

        try {
            conn = db.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            if (alreadyLiked) {
                // 이미 좋아요 상태 -> 좋아요 취소 (tripful_event_answer_like에서 삭제)
                String sqlDeleteLike = "delete from tripful_event_answer_like where answer_idx = ? and user_id = ?";
                pstmtLikeAction = conn.prepareStatement(sqlDeleteLike);
                pstmtLikeAction.setString(1, answer_idx);
                pstmtLikeAction.setString(2, user_id);
                int deletedRows = pstmtLikeAction.executeUpdate();

                if (deletedRows > 0) {
                    // tripful_event_answer 테이블의 likecount 감소
                    String sqlUpdate = "update tripful_event_answer set likecount = GREATEST(0, likecount - 1) where answer_idx = ?";
                    pstmtUpdateCount = conn.prepareStatement(sqlUpdate);
                    pstmtUpdateCount.setString(1, answer_idx);
                    pstmtUpdateCount.executeUpdate();
                    resultAction = "unliked";
                }
            } else {
                // 좋아요 안한 상태 -> 좋아요 추가 (tripful_event_answer_like에 삽입)
                String sqlInsertLike = "insert into tripful_event_answer_like (answer_idx, user_id) values (?, ?)";
                pstmtLikeAction = conn.prepareStatement(sqlInsertLike);
                pstmtLikeAction.setString(1, answer_idx);
                pstmtLikeAction.setString(2, user_id);
                int insertedRows = pstmtLikeAction.executeUpdate();

                if (insertedRows > 0) {
                    // tripful_event_answer 테이블의 likecount 증가
                    String sqlUpdate = "update tripful_event_answer set likecount = likecount + 1 where answer_idx = ?";
                    pstmtUpdateCount = conn.prepareStatement(sqlUpdate);
                    pstmtUpdateCount.setString(1, answer_idx);
                    pstmtUpdateCount.executeUpdate();
                    resultAction = "liked";
                }
            }
            conn.commit(); // 모든 작업 성공 시 커밋
        } catch (SQLException e) {
            System.out.println("좋아요 토글 트랜잭션 오류: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // 오류 발생 시 롤백
                } catch (SQLException ex) {
                    System.out.println("롤백 오류: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
            resultAction = "error"; // 명시적으로 에러 상태 설정
        } finally {
            // 리소스 정리
            try { if (pstmtUpdateCount != null) pstmtUpdateCount.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtLikeAction != null) pstmtLikeAction.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // 자동 커밋 모드 복원
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                db.dbClose(null, conn); // ResultSet은 없으므로 null 전달, Connection만 닫도록 유도
            }
        }
        return resultAction;
    }


    public int getLikeCount(String answer_idx) {
        Connection conn = db.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "select likecount from tripful_event_answer where answer_idx = ?";
        int likeCount = 0;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, answer_idx);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                likeCount = rs.getInt("likecount");
            }
        } catch (SQLException e) {
            System.out.println("좋아요 수 조회 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return likeCount;
    }
}