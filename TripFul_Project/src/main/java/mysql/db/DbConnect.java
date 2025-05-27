package mysql.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DbConnect {
		
		static final String URL = "jdbc:mysql://localhost:3306/coffee";
		static final String USERNAME = "kch0101";
		static final String PW = "a1234";
		static final String MySqlDriver="com.mysql.cj.jdbc.Driver";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		public DbConnect() {
			try {
				Class.forName(MySqlDriver);
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("MySql 드라이버 실패: "+e.getMessage());
			}
		}
		
		
		
		public Connection getConnection() {
			Connection conn =null;
			
			try {
				conn = DriverManager.getConnection(URL, USERNAME, PW);
				
				//System.out.println("연결 성공");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				System.out.println("연결 실패 "+ e.getMessage());
			}
			
			return conn;
		}
		
		public void dbClose(ResultSet rs, Statement stmt, Connection conn) {
			try {
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		public void dbClose(Statement stmt, Connection conn) {
			try {
				
				if(stmt != null) stmt.close();
				if(conn != null) conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		public void dbClose(ResultSet rs, PreparedStatement pstmt, Connection conn) {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		public void dbClose(PreparedStatement pstmt, Connection conn) {
			try {
				
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		


		public static void main(String[] args) {
		    try {
		        Class.forName("oracle.jdbc.OracleDriver");
		        System.out.println("Oracle JDBC Driver Loaded");
		        Connection conn = DriverManager.getConnection(
		            "jdbc:oracle:thin:@localhost:1521:XE", "kch5406", "a1234");
		        System.out.println("Database connected successfully");
		        conn.close();
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}
}
