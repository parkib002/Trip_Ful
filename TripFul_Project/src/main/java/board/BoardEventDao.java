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
			public List<BoardEventDto> getList(int start,int perpage)
			{
				List<BoardEventDto> list=new ArrayList<BoardEventDto>();
				String sql="select * from tripful_event order by num desc limit ?,?";
				Connection conn=db.getConnection();
				PreparedStatement pstmt=null;
				ResultSet rs=null;
					
					
				try {
					pstmt=conn.prepareStatement(sql);
					//바인딩
					pstmt.setInt(1, start);
					pstmt.setInt(2, perpage);
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
				
				
}
