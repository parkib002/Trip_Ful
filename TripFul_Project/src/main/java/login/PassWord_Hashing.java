package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import org.mindrot.jbcrypt.BCrypt;

import mysql.db.DbConnect;

public class PassWord_Hashing {

	public Vector<String> hashing(String id) {
		Vector<String> hash = new Vector<String>();

		DbConnect db = new DbConnect();
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select pw from tripful_member where id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				String pw = rs.getString("pw");
				String new_salt = BCrypt.gensalt();
				String hashed_pw = BCrypt.hashpw(pw, new_salt);

				hash.add(id);
				hash.add(new_salt);
				hash.add(hashed_pw);
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return hash;
	}
	
	public static void change_pw(String id) {
		DbConnect db = new DbConnect();
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		PassWord_Hashing ph = new PassWord_Hashing();

		String sql = "update tripful_member set hash_pw=?, salt=? where id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			Vector<String> hash = ph.hashing(id);
			pstmt.setString(1, hash.get(2));
			pstmt.setString(2, hash.get(1));
			pstmt.setString(3, hash.get(0));

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	public void hashing_test() {
		DbConnect db = new DbConnect();
		Connection conn = db.getConnection();
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		
		String sql = "select hash_pw, salt from tripful_member where id = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "hgd1234");
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				String salt = rs.getString("salt");
				String hash_pw = rs.getString("hash_pw");
				
				if(hash_pw.equals(BCrypt.hashpw("qwer1234!", salt))) {
					System.out.println("해싱 테스트 성공");
				}
				else {
					System.out.println("안되네");
				}
			}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
	}

	public static void main(String[] args) {


	}

}
