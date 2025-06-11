package review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class ReportDao {
	
	DbConnect db=new DbConnect();	
	
	public int reportCnt(String member_id) {
		int reportCnt=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select member_id from tripful_review_report where report_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				reportCnt=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		
		return reportCnt;
	}

	
	//아이디 중복방지
	public int getIdCheck(String member_id, String review_idx)
	{
		int idCheck=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select count(*) from tripful_review_report where member_id=? and review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			pstmt.setString(2, review_idx);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				idCheck=rs.getInt(1);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}		
		
		return idCheck;
	}
	
	//cnt 전체 값 불러오기
	public int getAllreportCnt(String review_idx)
	{
		int cnt=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select  sum(report_cnt) allreportcnt from tripful_review_report where review_idx=? ";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				cnt=rs.getInt("allreportcnt");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return cnt;
	}
	
	//cnt체크
	public int getCntCheck( String member_id,String review_idx)
	{
		int cnt=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select report_cnt from tripful_review_report where member_id=? and review_idx=? ";
		try {
			pstmt=conn.prepareStatement(sql);			
			pstmt.setString(1, member_id);
			pstmt.setString(2, review_idx);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				cnt=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return cnt;
	}
	
	
	//like 전체 값 불러오기
	public int getLikeCount(String review_idx)
	{
		int like=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select sum(report_like) totlike from tripful_review_report where review_idx=? ";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				like=rs.getInt("totlike");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return like;
	}
	
	
	
	//like체크
	public int getlike(String member_id,String review_idx)
	{
		int like=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select report_like from tripful_review_report where member_id=? and review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			pstmt.setString(2, review_idx);
			
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				like=rs.getInt("report_like");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return like;
	}
	
	//좋아요 없을때 신고 하기
	public void insertReport(ReportDto dto){
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;	
		
		String sql="insert into tripful_review_report(report_idx, member_id, report_content, report_cnt, review_idx) values(null,?,?,?,?)";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getMember_id());			
			pstmt.setString(2, dto.getReport_content());
			pstmt.setInt(3, dto.getReport_cnt());
			pstmt.setString(4, dto.getReview_idx());
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//리뷰 카운트가 10개 이상이면 리뷰 삭제
	public void deleteReport(String review_idx) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="delete from tripful_review_report where review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
	
	//멤버아이디와 리뷰인덱스 값이 일치한 report_idx 구하기
	public String getReportIdx(String member_id,String review_idx)
	{
		String report_idx="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select report_idx from tripful_review_report where member_id=? and review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			pstmt.setString(2, review_idx);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				report_idx=rs.getString("report_idx");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return report_idx;
	}
	
	//좋아요 있을시 신고 업데이트
	public void updateReport(ReportDto dto) {
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="update tripful_review_report set report_content=?, report_cnt=? where report_idx=?";
		try {
			
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getReport_content());
			pstmt.setInt(2, dto.getReport_cnt());
			pstmt.setString(3, dto.getReport_idx());
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	//좋아요 있으면 like-- 없으면 like++ 업데이트 만들기
	public void updateLike(ReportDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="update tripful_review_report set report_like=? where report_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getLike());
			pstmt.setString(2, dto.getReport_idx());			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//신고 없으면 좋아요 insert
	//신고 하기
	public void insertLike(ReportDto dto){
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;	
		
		String sql="insert into tripful_review_report(report_idx,member_id,report_like,review_idx) values(null,?,?,?)";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getMember_id());
			pstmt.setInt(2, dto.getLike());			
			pstmt.setString(3, dto.getReview_idx());
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//모든 report_idx 값 가져오기
	public String getAllReportIdx()
	{
		String report_idx="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select report_idx from tripful_review_report";
		try {
			pstmt=conn.prepareStatement(sql);			
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				report_idx=rs.getString("report_idx");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return report_idx;
	}
	
	
}
