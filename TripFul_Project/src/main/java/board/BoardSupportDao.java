package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import mysql.db.DbConnect;

public class BoardSupportDao {
	
	DbConnect db=new DbConnect();
	
		//전체 원본글갯수
		public int getTotalCount()
		{
			int n=0;
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			String sql="select count(*) from tripful_qna where relevel = 0";
				
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
		
		//num의 max값 구해서 리턴(null일경우 0으로 리턴)
		public int getMaxNum()
		{
			int max=0;
			
			String sql="select ifnull(max(qna_idx),0) max from tripful_qna";
			
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			
			try {
				pstmt=conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
				if(rs.next())
					max=rs.getInt(1);
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(rs, pstmt, conn);
			}
			
			
			return max;
		}
		
		//데이터 추가시 같은그룹중에서 전달받은 step보다 큰값을 가진 데이타들은 
		//무조건 restep+1 해준다
		public void updateRestep(int regroup,int restep)
		{
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			
			String sql="update tripful_qna set restep=restep+1 where regroup=? and restep>?";
			
			try {
				pstmt=conn.prepareStatement(sql);
				
				pstmt.setInt(1, regroup);
				pstmt.setInt(2, restep);
				
				pstmt.execute();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(pstmt, conn);
			}
			
		}
		
		//insert: 새글로 추가할지 답글로 추가할지 
		//판단: dto의 num이 null이면 새글로 아니면 답글로 insert할것
		public void insertReboard(BoardSupportDto dto)
		{
			String idx=dto.getQna_idx();
			int regroup=dto.getRegroup();
			int restep=dto.getRestep();
			int relevel=dto.getRelevel();
			
			String sql="insert into tripful_qna values (null,?,?,?,?,?,0,now(),?,?,?,?)";
			
			if(idx==null) {
				//새글을 의미
				regroup=this.getMaxNum()+1;
				restep=0;
				relevel=0;
			}else {
				//답글을 의미
				//같은 그룹중에서 restep이 전달받은 값보다 큰경우 무조건 1씩 증가
				this.updateRestep(regroup, restep);
				//그리고 전달받은 level,step 1씩증가
				relevel+=1;
				restep++;
			}
			
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			
			try {
				pstmt=conn.prepareStatement(sql);
				
				//바인딩 
				pstmt.setString(1, dto.getQna_title());
				pstmt.setString(2, dto.getQna_content());
				pstmt.setString(3, dto.getQna_img());
				pstmt.setString(4, dto.getQna_writer());
				pstmt.setString(5, dto.getQna_private());
				pstmt.setString(6, dto.getQna_category());
				pstmt.setInt(7, regroup);
				pstmt.setInt(8, restep);
				pstmt.setInt(9, relevel);
				
				pstmt.execute();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(pstmt, conn);
			}
			
		}
		
		//디테일페이지(num에대한 하나의 dto)
		public BoardSupportDto getData(String idx)
		{
			BoardSupportDto dto=new BoardSupportDto();
			
			String sql="select * from tripful_qna where qna_idx=?";
			
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			
			try {
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, idx);
				rs=pstmt.executeQuery();
				
				if(rs.next())
				{
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(rs, pstmt, conn);
			}
			
			
			return dto;
		}
		//디테일페이지에서 조회수1 증가해야 하므로
		public void updateReadCount(String idx)
		{
			String sql="update tripful_qna set readcount=readcount+1 where qna_idx=?";
			
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			
			try {
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, idx);
				pstmt.execute();
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(pstmt, conn);
			}
			
		}
		
		//전체목록
			public List<BoardSupportDto> getAllDatas(int startNum,int perPage)
			{
				List<BoardSupportDto> list=new Vector<BoardSupportDto>();
				
				//그룹변수 내림차순 같은그룹인경우 step의 오름차순 정렬
				String sql="select * from tripful_qna where relevel = 0 order by regroup desc, restep asc limit ?, ?";
					
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
			
			//답글
			public List<BoardSupportDto> getRepliesByRegroup(int regroup) {
			    List<BoardSupportDto> list = new Vector<BoardSupportDto>();
			    // 답글만 가져오고, restep 순으로 정렬
			    String sql = "SELECT * FROM tripful_qna WHERE regroup = ? AND relevel > 0 ORDER BY restep desc";
			    Connection conn = db.getConnection();
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;

			    try {
			        pstmt = conn.prepareStatement(sql);
			        pstmt.setInt(1, regroup);
			        rs = pstmt.executeQuery();

			        while (rs.next()) {
			            BoardSupportDto dto = new BoardSupportDto();
			            // getAllDatas와 유사하게 DTO 필드 채우기
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
}
