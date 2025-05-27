package review;

import java.net.ConnectException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class ReviewDao {
	DbConnect db=new DbConnect();
	
	//insertReview
	public void insertReview(ReviewDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="insert into review values(null,?,?,?,?,?,now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getReview_id());
			pstmt.setString(2, dto.getReview_content());
			pstmt.setString(3, dto.getReview_img());
			pstmt.setInt(4, dto.getReview_star());
			pstmt.setString(5, dto.getPlace_num());
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
}
