package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import mysql.db.DbConnect;

public class MyPageDao {

	DbConnect db = new DbConnect();

	// 좋아요한 관광지 목록 리턴
	public List<String> getWishList(String continent, String id) {
		List<String> wishList = new ArrayList<String>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select place_num from tripful_place where continent_name = ? "
				+ "and place_num = any(select place_num from tripful_place_like where user_id = ?);";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, continent);
			pstmt.setString(2, id);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				wishList.add(rs.getString("place_num"));
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return wishList;
	}

	// 작성한 리뷰 리턴
	public List<HashMap<String, String>> getMyReview(String continent, String id) {
		List<HashMap<String, String>> myReview = new ArrayList<HashMap<String, String>>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from tripful_review where review_id = ? "
				+ "and place_num = any(select place_num from tripful_place where continent_name = ?)";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, continent);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("review_idx", rs.getString("review_idx"));
				map.put("review_id", rs.getString("review_id"));
				map.put("review_content", rs.getString("review_content"));
				map.put("review_img", rs.getString("review_img"));
				map.put("review_star", rs.getString("review_star"));
				map.put("review_writeday", rs.getString("review_writeday"));
				myReview.add(map);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return myReview;
	}
}
