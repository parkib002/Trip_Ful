package review;

import java.net.ConnectException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import mysql.db.DbConnect;

public class ReviewDao {
	DbConnect db=new DbConnect();
	
	//insertReview
	public void insertReview(ReviewDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="insert into tripful_review values(null,?,?,?,?,now(),?)";
		
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
	//관광지 이름 가져오기
	public String getPlaceName(String Place_num)
	{
		String Place_name="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select Place_name from tripful_place where place_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, Place_num);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				Place_name=rs.getString("place_name");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return Place_name;
	}
	
	//관광지 아이디
	public String getPlaceCode(String Place_num)
	{
		String Place_code="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select Place_code from tripful_place where place_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, Place_num);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				Place_code=rs.getString("place_code");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return Place_code;
	}
	
	//관광지 전체리스트
	public List<HashMap<String, String>> getPlaceList(String place_name)
	{
		String sql="select r.review_idx, r.review_id, r.review_content, r.review_img, r.review_star, r.review_writeday, r.place_num "
				+ "from tripful_review r,tripful_place p "
				+ "where r.place_num=p.place_num and p.place_name=?";
		
		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_name);
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				HashMap<String, String> map=new HashMap<String, String>();
				
				map.put("review_idx", rs.getString("review_idx"));
				map.put("review_id", rs.getString("review_id"));
				map.put("review_content", rs.getString("review_content"));
				map.put("review_img", rs.getString("review_img"));
				map.put("review_star", rs.getString("review_star"));
				map.put("review_writeday", rs.getString("review_writeday"));
				map.put("place_num", rs.getString("place_num"));				
				
				//list에 추가
				list.add(map);
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
