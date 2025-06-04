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
				+ "where r.place_num=p.place_num and p.place_num=? order by review_idx desc";
		
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
	

	//리뷰 1개의 데이타 

	public ReviewDto getOneData(String review_idx) {
		ReviewDto dto=new ReviewDto();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select * from tripful_review where review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				dto.setReview_idx(rs.getString("review_idx"));
				dto.setReview_id(rs.getString("review_id"));
				dto.setReview_content(rs.getString("review_content"));
				dto.setReview_img(rs.getString("review_img"));
				dto.setReview_star(rs.getDouble("review_star"));
				dto.setReview_writeday(rs.getTimestamp("review_writeday"));
				dto.setPlace_num(rs.getString("place_num"));
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return dto;
		
	}
	

	//리뷰 업데이트
	public void updateReview(ReviewDto dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="update tripful_review set review_content=?, review_img=?, review_star=? where review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getReview_content());
			pstmt.setString(2, dto.getReview_img());
			pstmt.setDouble(3, dto.getReview_star());
			pstmt.setString(4, dto.getReview_idx());
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//리뷰 삭제
	public void deleteReview(String review_idx)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="delete from tripful_review where review_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, review_idx);
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}		
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


	public HashMap<String, String> getLatestReviewForPlace(String place_num) {
		HashMap<String, String> review = null; // review 라는 이름의 HashMap 사용
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT review_idx, review_id, review_content, review_img, review_star, review_writeday, place_num " +
				"FROM tripful_review WHERE place_num = ? ORDER BY review_writeday DESC LIMIT 1";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, place_num);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				review = new HashMap<>(); // 여기서 review 객체 초기화
				review.put("review_num", rs.getString("review_idx"));
				review.put("author", rs.getString("review_id"));
				review.put("rating", rs.getString("review_star"));
				// *** 이 부분입니다! review.put("text", ...); 로 수정해주세요. ***
				review.put("text", rs.getString("review_content"));
				review.put("photo", rs.getString("review_img"));
				review.put("date", rs.getString("review_writeday"));
				review.put("place_num", rs.getString("place_num"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return review;
	}

}