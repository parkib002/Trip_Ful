package place;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import board.MainPlaceDto;
import mysql.db.DbConnect;

public class PlaceDao {

	DbConnect db=new DbConnect();
	
	public void insertPlace(PlaceDto dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into tripful_place values(null,?,?,?,?,?,?,0,?,?)";
		
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
	
	public List<PlaceDto> selectCountryPlaces(String country)
	{
		List<PlaceDto> list=new Vector<PlaceDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from tripful_place where country_name=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, country);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				PlaceDto dto=new PlaceDto();
				
				dto.setContinent_name(rs.getString("continent_name"));
				dto.setCountry_name(rs.getString("country_name"));
				dto.setPlace_num(rs.getString("place_num"));
				dto.setPlace_img(rs.getString("place_img"));
				dto.setPlace_content(rs.getString("place_content"));
				dto.setPlace_tag(rs.getString("place_tag"));
				dto.setPlace_code(rs.getString("place_code"));
				dto.setPlace_name(rs.getString("place_name"));
				dto.setPlace_count(rs.getInt("place_count"));
				
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
	
	public List<PlaceDto> selectAllPlaces() throws SQLException {
	    List<PlaceDto> list = new Vector<PlaceDto>();
	    String sql = "SELECT * FROM tripful_place order by place_name ASC";
	    try (Connection conn = db.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {
	        while (rs.next()) {
	            PlaceDto dto = new PlaceDto();
	            dto.setPlace_num(rs.getString("place_num"));
	            dto.setPlace_name(rs.getString("place_name"));
	            dto.setPlace_img(rs.getString("place_img"));
	            dto.setCountry_name(rs.getString("country_name"));
	            list.add(dto);
	        }
	    }
	    return list;
	}
	
	public List<PlaceDto> selectContinentPlaces(String continent)
	{
		List<PlaceDto> list=new Vector<PlaceDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		 String sql = "SELECT place_num, country_name, place_name, place_img, continent_name FROM tripful_place WHERE continent_name = ?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, continent);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				PlaceDto dto=new PlaceDto();
				
				dto.setPlace_num(rs.getString("place_num"));
				dto.setContinent_name(rs.getString("continent_name"));
				dto.setCountry_name(rs.getString("country_name"));
				dto.setPlace_img(rs.getString("place_img"));
				dto.setPlace_name(rs.getString("place_name"));
				
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
		
		String sql="update set tripful_place place_count=place_count+1 where place_num=?";
		
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
	

}