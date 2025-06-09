package review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class ReportDao {
	
	DbConnect db=new DbConnect();	
	
	public int getReportIdx(String review_idx) {
		int report_idx=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select report_idx from tripful_review_report where review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				report_idx=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		
		return report_idx;
	}

	public void insertReport(ReportDto dto){
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="insert into tripful_review_report(report_idx,member_id,report_content,report_cnt,review_idx) values(null,?,?,?,?)";
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
}
