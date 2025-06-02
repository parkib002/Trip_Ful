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
			pstmt.setDouble(4, dto.getReview_star());
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
	public String getPlaceName(String place_num)
	{
		String Place_name="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select Place_name from tripful_place where place_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
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
	public String getPlaceCode(String place_num)
	{
		String Place_code="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select Place_code from tripful_place where place_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
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
	public List<HashMap<String, String>> getPlaceList(String place_num)
	{
		String sql="select r.review_idx, r.review_id, r.review_content, r.review_img, r.review_star, r.review_writeday, p.place_num "
				+ "from tripful_review r,tripful_place p "
				+ "where r.place_num=p.place_num and p.place_num=?";
		
		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
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
	
	public double getAverageRatingByPlace(String place_num) {
	    
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
		
		double avg = 0.0;
	    try {
	        String sql = "SELECT round(AVG(review_star),1) FROM tripful_review WHERE place_num = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, place_num);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            avg = rs.getDouble(1);
	            if (rs.wasNull()) { // 평균값이 없으면
	                avg = -1.0; // 평점 없음 표시를 위해 -1.0 반환
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }finally {
			db.dbClose(rs, pstmt, conn);
		}
		return avg;
	}

	// 모든 리뷰를 가져오는 메서드: getPlaceList와 동일한 HashMap 키를 사용하도록 수정
	public List<HashMap<String, String>> getAllReviews() {
		List<HashMap<String, String>> list = new ArrayList<>();
		Connection conn=db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// 테이블 이름을 'tripful_review'로 변경하고, select하는 컬럼명도 정확히 맞춰줍니다.
			// review_read_type이 없다면 쿼리에서 제거하거나, DB에 추가해야 합니다.
			String sql = "SELECT review_idx, review_id, review_content, review_img, review_star, review_writeday, place_num " +
					"FROM tripful_review ORDER BY review_writeday DESC";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				HashMap<String, String> map = new HashMap<>();
				map.put("review_num", rs.getString("review_idx")); // review_idx를 review_num으로 매핑
				map.put("author", rs.getString("review_id"));       // review_id를 author로 매핑
				map.put("rating", rs.getString("review_star"));     // review_star를 rating으로 매핑
				map.put("text", rs.getString("review_content"));    // review_content를 text로 매핑
				map.put("photo", rs.getString("review_img"));       // review_img를 photo로 매핑
				map.put("date", rs.getString("review_writeday"));   // review_writeday를 date로 매핑\
				map.put("place_num", rs.getString("place_num"));
				// 'review_read_type' 컬럼이 'tripful_review' 테이블에 없거나 필요 없다면 이 줄은 삭제하세요.
				// map.put("read", rs.getString("review_read_type"));

				list.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
	}
}