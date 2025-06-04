package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class MyPageDao {
	DbConnect db = new DbConnect();
	
	public List<String> getWishList(String id){
		List<String> wishList = new ArrayList<String>();
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select place_num from tripful_place_like where id=?";
		
		return wishList;
	}
}
