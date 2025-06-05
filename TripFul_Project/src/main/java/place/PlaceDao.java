package place;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;


import mysql.db.DbConnect;
import review.ReviewDto;

public class PlaceDao {

	DbConnect db=new DbConnect();
	
	public void insertPlace(PlaceDto dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into tripful_place values(null,?,?,?,?,?,?,0,?,?,0)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getCountry_name());
			pstmt.setString(2, dto.getPlace_img());
			pstmt.setString(3, dto.getPlace_content());
			pstmt.setString(4, dto.getPlace_tag());
			pstmt.setString(5, dto.getPlace_code());
			pstmt.setString(6, dto.getPlace_name());
			pstmt.setString(7, dto.getContinent_name());
			pstmt.setString(8, dto.getPlace_addr());
			
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	public List<PlaceDto> selectCountryPlaces(String country) {
	    List<PlaceDto> list = new Vector<>();

	    String sql = "SELECT p.*, " +
	                 "       (SELECT ROUND(AVG(r.review_star), 1) FROM tripful_review r WHERE r.place_num = p.place_num) AS avg_rating " +
	                 "FROM tripful_place p " +
	                 "WHERE p.country_name = ? " +
	                 "ORDER BY p.place_name ASC";

	    try (Connection conn = db.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, country);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                PlaceDto dto = new PlaceDto();

	                dto.setContinent_name(rs.getString("continent_name"));
	                dto.setCountry_name(rs.getString("country_name"));
	                dto.setPlace_num(rs.getString("place_num"));
	                dto.setPlace_img(rs.getString("place_img"));
	                dto.setPlace_content(rs.getString("place_content"));
	                dto.setPlace_tag(rs.getString("place_tag"));
	                dto.setPlace_code(rs.getString("place_code"));
	                dto.setPlace_name(rs.getString("place_name"));
	                dto.setPlace_count(rs.getInt("place_count")); // 조회수 추가
	                dto.setPlace_like(rs.getInt("place_like"));   // 좋아요 추가
	                dto.setAvg_rating(rs.getDouble("avg_rating")); // 별점

	                list.add(dto);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	public List<PlaceDto> selectAllPlaces() throws SQLException {
	    List<PlaceDto> list = new Vector<>();

	    String sql = "SELECT p.*, " +
	                 "       (SELECT ROUND(AVG(r.review_star), 1) FROM tripful_review r WHERE r.place_num = p.place_num) AS avg_rating " +
	                 "FROM tripful_place p " +
	                 "ORDER BY p.place_name ASC";

	    try (Connection conn = db.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            PlaceDto dto = new PlaceDto();

	            dto.setPlace_num(rs.getString("place_num"));
	            dto.setPlace_name(rs.getString("place_name"));
	            dto.setPlace_img(rs.getString("place_img"));
	            dto.setCountry_name(rs.getString("country_name"));
	            dto.setPlace_count(rs.getInt("place_count")); // 조회수 추가
	            dto.setPlace_like(rs.getInt("place_like"));   // 좋아요 추가
	            dto.setAvg_rating(rs.getDouble("avg_rating")); // 별점

	            list.add(dto);
	        }
	    }

	    return list;
	}
	
	public List<PlaceDto> selectContinentPlaces(String continent, String sort) {
	    List<PlaceDto> list = new Vector<>();

	    String orderBy = "p.place_count DESC"; // 기본: 조회순 내림차순
	    if ("rating".equals(sort)) {
	        orderBy = "avg_rating IS NULL, avg_rating DESC";
	    } else if ("likes".equals(sort)) {
	        orderBy = "p.place_like DESC";
	    } else if ("name".equals(sort)) {
	        orderBy = "p.place_name ASC";
	    } else if ("views".equals(sort)) {
	        orderBy = "p.place_count DESC";
	    }

	    System.out.println("selectContinentPlaces orderBy: " + orderBy);  // 여기 꼭 찍어보기

	    String sql = "SELECT p.*, avg_rating_table.avg_rating " +
	             "FROM tripful_place p " +  // <-- 여기에 공백 반드시 넣기
	             "LEFT JOIN ( " +
	             "  SELECT place_num, ROUND(AVG(review_star), 1) AS avg_rating " +
	             "  FROM tripful_review " +
	             "  GROUP BY place_num " +
	             ") avg_rating_table ON p.place_num = avg_rating_table.place_num " +
	             "WHERE p.continent_name = ? " +
	             "ORDER BY " + orderBy; // ⭐ 여기를 고정된 쿼리 대신 동적 변수로 변경
	    
	    try (Connection conn = db.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, continent);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                PlaceDto dto = new PlaceDto();

	                dto.setPlace_num(rs.getString("place_num"));
	                dto.setContinent_name(rs.getString("continent_name"));
	                dto.setCountry_name(rs.getString("country_name"));
	                dto.setPlace_img(rs.getString("place_img"));
	                dto.setPlace_name(rs.getString("place_name"));
	                dto.setPlace_count(rs.getInt("place_count")); // 조회수
	                dto.setPlace_like(rs.getInt("place_like"));   // 좋아요
	                dto.setAvg_rating(rs.getDouble("avg_rating")); // 별점

	                list.add(dto);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	public PlaceDto getPlaceData(String num)
	{
		PlaceDto dto=new PlaceDto();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from tripful_place where place_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, num);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				dto.setContinent_name(rs.getString("continent_name"));
				dto.setCountry_name(rs.getString("country_name"));
				dto.setPlace_num(rs.getString("place_num"));
				dto.setPlace_img(rs.getString("place_img"));
				dto.setPlace_content(rs.getString("place_content"));
				dto.setPlace_tag(rs.getString("place_tag"));
				dto.setPlace_code(rs.getString("place_code"));
				dto.setPlace_name(rs.getString("place_name"));
				dto.setPlace_count(rs.getInt("place_count"));
				dto.setPlace_addr(rs.getString("place_addr"));
				dto.setPlace_like(rs.getInt("place_like"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
	
	public void placeReadCount(String num)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update tripful_place set place_count=place_count+1 where place_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, num);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	public List<ReviewDto> selectReview(String num)
	{
		List<ReviewDto> list=new Vector<ReviewDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from tripful_review where place_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, num);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				ReviewDto dto=new ReviewDto();
				
				dto.setReview_idx(rs.getString("review_idx"));
				dto.setReview_id(rs.getString("review_id"));
				dto.setReview_content(rs.getString("review_content"));
				dto.setReview_img(rs.getString("review_img"));
				dto.setReview_star(rs.getDouble("review_star"));
				dto.setReview_writeday(rs.getTimestamp("review_writeday"));
				dto.setPlace_num(rs.getString("place_num"));
				
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
	
	public int getLikeCount(String num) {
	    int like = 0;
	  
	    Connection conn=db.getConnection();
	    PreparedStatement pstmt=null;
	    ResultSet rs=null;
	    
	    String sql = "SELECT place_like FROM tripful_place WHERE place_num = ?";
	  
	    try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, num);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				like=rs.getInt("place_like");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
	    
	    return like;
	}
	
	public void likeCount(String num)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update tripful_place set place_like=place_like+1 where place_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, num);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	public List<PlaceDto> selectAllPlacesPaged(int start, int count) throws SQLException {
	    List<PlaceDto> list = new ArrayList<>();
	    String sql = "SELECT p.*, " +
	                 "       (SELECT ROUND(AVG(r.review_star), 1) FROM tripful_review r WHERE r.place_num = p.place_num) AS avg_rating " +
	                 "FROM tripful_place p " +
	                 "ORDER BY p.place_name ASC LIMIT ?, ?";

	    try (Connection conn = db.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, start);
	        pstmt.setInt(2, count);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                PlaceDto dto = new PlaceDto();
	                dto.setPlace_num(rs.getString("place_num"));
	                dto.setPlace_name(rs.getString("place_name"));
	                dto.setPlace_img(rs.getString("place_img"));
	                dto.setCountry_name(rs.getString("country_name"));
	                dto.setPlace_count(rs.getInt("place_count")); // 조회수 추가
	                dto.setPlace_like(rs.getInt("place_like"));   // 좋아요 추가
	                dto.setAvg_rating(rs.getDouble("avg_rating"));
	                list.add(dto);
	            }
	        }
	    }

	    return list;
	}
	
	public void updatePlace(PlaceDto dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update tripful_place set place_name=?, place_addr=?, place_code=?,country_name=?,continent_name=?,place_tag=?,place_content=?,place_img=? where place_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getPlace_name());
			pstmt.setString(2, dto.getPlace_addr());
			pstmt.setString(3, dto.getPlace_code());
			pstmt.setString(4, dto.getCountry_name());
			pstmt.setString(5, dto.getContinent_name());
			pstmt.setString(6, dto.getPlace_tag());
			pstmt.setString(7, dto.getPlace_content());
			pstmt.setString(8, dto.getPlace_img());
			pstmt.setString(9, dto.getPlace_num());
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	public void deletePlace(String num)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from tripful_place where place_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, num);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	

	public void insertLike(String place_num, String user_id) {
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    String sql1 = "INSERT INTO tripful_place_like (place_num, user_id) VALUES (?, ?)";
	    String sql2 = "UPDATE tripful_place SET place_like = place_like + 1 WHERE place_num = ?";
	    try {
	        conn.setAutoCommit(false);
	        
	        pstmt = conn.prepareStatement(sql1);
	        pstmt.setString(1, place_num);
	        pstmt.setString(2, user_id);
	        pstmt.executeUpdate();
	        pstmt.close();

	        pstmt = conn.prepareStatement(sql2);
	        pstmt.setString(1, place_num);
	        pstmt.executeUpdate();

	        conn.commit();
	    } catch (Exception e) {
	        e.printStackTrace();
	        try { conn.rollback(); } catch (Exception ignore) {}
	    } finally {
	        db.dbClose(pstmt, conn);
	    }
	}
	
	public boolean hasUserLikedPlace(String place_num, String user_id) {
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "SELECT COUNT(*) FROM tripful_place_like WHERE place_num = ? AND user_id = ?";
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, place_num);
	        pstmt.setString(2, user_id);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1) > 0;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }
	    return false;
	}
	
	public void deleteLike(String place_num, String user_id) {
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    String sql1 = "DELETE FROM tripful_place_like WHERE place_num = ? AND user_id = ?";
	    String sql2 = "UPDATE tripful_place SET place_like = place_like - 1 WHERE place_num = ?";
	    
	    try {
	        conn.setAutoCommit(false);

	        pstmt = conn.prepareStatement(sql1);
	        pstmt.setString(1, place_num);
	        pstmt.setString(2, user_id);
	        pstmt.executeUpdate();
	        pstmt.close();

	        pstmt = conn.prepareStatement(sql2);
	        pstmt.setString(1, place_num);
	        pstmt.executeUpdate();

	        conn.commit();
	    } catch (Exception e) {
	        e.printStackTrace();
	        try { conn.rollback(); } catch (Exception ignore) {}
	    } finally {
	        db.dbClose(pstmt, conn);
	    }
	}
	
	public List<PlaceDto> getRandomPlaces(int count) {
	    List<PlaceDto> list = new ArrayList<>();
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "SELECT p.*, " +
	                 "       (SELECT ROUND(AVG(r.review_star), 1) FROM tripful_review r WHERE r.place_num = p.place_num) AS avg_rating " +
	                 "FROM tripful_place p " +
	                 "ORDER BY RAND() LIMIT ?";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, count);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            PlaceDto dto = new PlaceDto();
	            dto.setPlace_num(rs.getString("place_num"));
	            dto.setCountry_name(rs.getString("country_name"));
	            dto.setPlace_img(rs.getString("place_img"));
	            dto.setPlace_content(rs.getString("place_content"));
	            dto.setPlace_tag(rs.getString("place_tag"));
	            dto.setPlace_code(rs.getString("place_code"));
	            dto.setPlace_name(rs.getString("place_name"));
	            dto.setPlace_count(rs.getInt("place_count"));
	            dto.setContinent_name(rs.getString("continent_name"));
	            dto.setPlace_addr(rs.getString("place_addr"));
	            dto.setPlace_like(rs.getInt("place_like"));

	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}
	
	public List<PlaceDto> getCountPlace(String sort) {
	    List<PlaceDto> list = new Vector<>();

	    String orderBy = "p.place_count DESC"; // 기본: 조회순 내림차순
	    if ("rating".equals(sort)) {
	        orderBy = "avg_rating IS NULL, avg_rating DESC";
	    } else if ("likes".equals(sort)) {
	        orderBy = "p.place_like DESC";
	    } else if ("name".equals(sort)) {
	        orderBy = "p.place_name ASC";
	    } else if ("views".equals(sort)) {
	        orderBy = "p.place_count DESC";
	    }

	    System.out.println("getCountPlace orderBy: " + orderBy);  // 여기 꼭 찍어보기

	    String sql =  
	    	    "SELECT p.*, avg_rating_table.avg_rating " +
	    	    "FROM tripful_place p " +
	    	    "LEFT JOIN ( " +
	    	    "  SELECT place_num, ROUND(AVG(review_star), 1) AS avg_rating " +
	    	    "  FROM tripful_review " +
	    	    "  GROUP BY place_num " +
	    	    ") avg_rating_table ON p.place_num = avg_rating_table.place_num " +
	    	    "ORDER BY " + orderBy + " LIMIT 5"; // ★ DESC 제거됨!
	    
	    try (Connection conn = db.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                PlaceDto dto = new PlaceDto();

	                dto.setCountry_name(rs.getString("country_name"));
	                dto.setPlace_name(rs.getString("place_name"));
	                dto.setPlace_count(rs.getInt("place_count")); // 조회수
	                dto.setPlace_like(rs.getInt("place_like"));   // 좋아요
	                dto.setAvg_rating(rs.getDouble("avg_rating")); // 별점

	                list.add(dto);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	

}