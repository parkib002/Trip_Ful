package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class BoardEventDao {
	
	DbConnect db=new DbConnect();
	
	//추가
	public void insertBoard(BoardEventDto dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into tripful_event values(null,?,?,?,?,now(),?)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getEvent_title());
			pstmt.setString(2, dto.getEvent_content());
			pstmt.setString(3, dto.getEvent_img());
			pstmt.setString(4, dto.getEvent_writer());
			pstmt.setInt(5, dto.getEvent_readcount());

			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//전체글갯수
		public int getTotalCount()
		{
			int n=0;
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			String sql="select count(*) from tripful_event";
			
			try {
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				if(rs.next())
				{
					n=rs.getInt(1);
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(rs, pstmt, conn);
			}

			return n;
		}
		
	//페이징처리한 리스트 목록 반환
			public List<BoardEventDto> getList(int startNum,int perPage)
			{
				List<BoardEventDto> list=new ArrayList<BoardEventDto>();
				String sql="select * from tripful_event order by event_idx desc limit ?,?";
				Connection conn=db.getConnection();
				PreparedStatement pstmt=null;
				ResultSet rs=null;
					
					
				try {
					pstmt=conn.prepareStatement(sql);
					//바인딩
					pstmt.setInt(1, startNum);
					pstmt.setInt(2, perPage);
					//실행
					rs=pstmt.executeQuery();
					while(rs.next())
					{
						BoardEventDto dto=new BoardEventDto();
						dto.setEvent_idx(rs.getString("event_idx"));
						dto.setEvent_title(rs.getString("event_title"));
						dto.setEvent_content(rs.getString("event_content"));
						dto.setEvent_img(rs.getString("event_img"));
						dto.setEvent_readcount(rs.getInt("event_readcount"));
						dto.setEvent_writer(rs.getString("event_writer"));
						dto.setEvent_writeday(rs.getTimestamp("event_writeday"));
						//list 에 추가
						list.add(dto);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally {
					db.dbClose(rs, pstmt, conn);
				}
				return list;
			}
		
			
			//조회수 증가
			// 조회수 1 증가
		    public void updateReadCount(String idx) {
		        String sql = "update tripful_event set event_readcount=event_readcount+1 where event_idx=?";
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
		    
		 // 특정 이벤트 게시물 데이터 가져오기
		    public BoardEventDto getData(String event_idx) {
		        BoardEventDto dto = null; // 게시물을 찾지 못하면 null 반환
		        String sql = "select * from tripful_event where event_idx=?";
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;

		        try {
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, event_idx);
		            rs = pstmt.executeQuery();

		            if (rs.next()) { // 해당 ID의 게시물이 있다면
		                dto = new BoardEventDto(); // DTO 객체 생성
		                dto.setEvent_idx(rs.getString("event_idx"));
		                dto.setEvent_title(rs.getString("event_title"));
		                dto.setEvent_content(rs.getString("event_content"));
		                dto.setEvent_img(rs.getString("event_img"));
		                dto.setEvent_readcount(rs.getInt("event_readcount"));
		                dto.setEvent_writer(rs.getString("event_writer"));
		                dto.setEvent_writeday(rs.getTimestamp("event_writeday"));
		            }
		        } catch (SQLException e) {
		            e.printStackTrace(); // 실제 운영에서는 로깅 등으로 대체하는 것이 좋습니다.
		        } finally {
		            db.dbClose(rs, pstmt, conn);
		        }
		        return dto; // DTO 객체 또는 null 반환
		    }
		    
		 // 이벤트 게시물 수정
		    public void updateEvent(BoardEventDto dto) {
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = null;

		        // event_writeday를 현재 시간으로 업데이트 (수정 시각 반영)
		        // event_writer는 DTO에 포함된 값으로 업데이트 (폼에서 hidden으로 전달받음)
		        String sql = "update tripful_event set event_title=?, event_content=?, event_img=?, event_writer=?, event_writeday=now() where event_idx=?";

		        try {
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, dto.getEvent_title());
		            pstmt.setString(2, dto.getEvent_content());
		            pstmt.setString(3, dto.getEvent_img());      // 수정된 이미지 경로 또는 파일명
		            pstmt.setString(4, dto.getEvent_writer());   // 수정된 작성자 (폼에서 전달받은 값)
		            pstmt.setString(5, dto.getEvent_idx());      // WHERE 절에 사용될 게시물 ID

		            pstmt.executeUpdate(); // UPDATE 실행
		        } catch (SQLException e) {
		            e.printStackTrace(); // 실제 운영에서는 로깅 등으로 대체하는 것이 좋습니다.
		        } finally {
		            db.dbClose(pstmt, conn);
		        }
		    }
		    
		 // 이벤트 게시물 삭제
		    public void deleteEvent(String event_idx) {
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = null;
		        String sql = "delete from tripful_event where event_idx=?";

		        try {
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, event_idx);
		            pstmt.executeUpdate(); // DELETE 실행
		        } catch (SQLException e) {
		            e.printStackTrace(); // 실제 운영에서는 로깅 등으로 대체하는 것이 좋습니다.
		        } finally {
		            db.dbClose(pstmt, conn);
		        }
		    }
		    
		
		    
		 // --- 통합 검색용 메소드 추가 ---
		    /**
		     * 이벤트 검색 결과의 전체 개수를 반환합니다.
		     * @param keyword 검색어
		     * @return 검색된 총 이벤트 수
		     */
		    public int getSearchEventTotalCount(String keyword) {
		        int total = 0;
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "select count(*) from tripful_event where event_title like ? or event_content like ?";

		        try {
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, "%" + keyword + "%");
		            pstmt.setString(2, "%" + keyword + "%");
		            rs = pstmt.executeQuery();
		            if (rs.next()) {
		                total = rs.getInt(1);
		            }
		        } catch (SQLException e) {
		            System.out.println("Event Search Total Count Error: " + e.getMessage());
		            e.printStackTrace();
		        } finally {
		            db.dbClose(rs, pstmt, conn);
		        }
		        return total;
		    }

		    /**
		     * 키워드로 이벤트를 검색하고 페이징 처리된 목록을 반환합니다.
		     * @param keyword 검색어
		     * @param startNum 가져올 데이터의 시작 위치 (offset)
		     * @param perPage 페이지당 보여줄 게시물 수
		     * @return 검색된 이벤트 목록 (List<BoardEventDto>)
		     */
		    public List<BoardEventDto> searchEvents(String keyword, int startNum, int perPage) {
		        List<BoardEventDto> list = new ArrayList<>();
		        String sql = "select * from tripful_event where event_title like ? or event_content like ? order by event_idx desc limit ?,?";
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
		                BoardEventDto dto = new BoardEventDto();
		                dto.setEvent_idx(rs.getString("event_idx"));
		                dto.setEvent_title(rs.getString("event_title"));
		                // dto.setEvent_content(rs.getString("event_content")); // 필요시
		                dto.setEvent_writer(rs.getString("event_writer"));
		                dto.setEvent_writeday(rs.getTimestamp("event_writeday"));
		                dto.setEvent_readcount(rs.getInt("event_readcount"));
		                dto.setEvent_img(rs.getString("event_img"));
		                list.add(dto);
		            }
		        } catch (SQLException e) {
		            System.out.println("Search Events Error: " + e.getMessage());
		            e.printStackTrace();
		        } finally {
		            db.dbClose(rs, pstmt, conn);
		        }
		        return list;
		    }
		    
		    
		    //전체 리스트
		    public List<BoardEventDto> getAllEvents()
			{
				List<BoardEventDto> list = new ArrayList<BoardEventDto>();
				
				// limit 없이 최신순으로 모든 데이터를 가져옵니다.
				String sql = "select * from tripful_event order by event_idx desc";
				
				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
					
				try {
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					while(rs.next())
					{
						BoardEventDto dto = new BoardEventDto();
						dto.setEvent_idx(rs.getString("event_idx"));
						dto.setEvent_title(rs.getString("event_title"));
						dto.setEvent_content(rs.getString("event_content"));
						dto.setEvent_img(rs.getString("event_img")); // JSP에서 사용할 이미지 파일명
						dto.setEvent_writer(rs.getString("event_writer"));
						dto.setEvent_readcount(rs.getInt("event_readcount"));
						dto.setEvent_writeday(rs.getTimestamp("event_writeday"));
						
						list.add(dto); // 리스트에 추가
					}
				} catch (SQLException e) {
					e.printStackTrace();
				} finally {
					db.dbClose(rs, pstmt, conn);
				}
				
				return list;
			}
		    
}
