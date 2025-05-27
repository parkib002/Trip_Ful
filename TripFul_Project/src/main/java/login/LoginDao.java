package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class LoginDao {

	DbConnect db = new DbConnect();

	public void insertMember(LoginDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "insert into tourful_member(id, pw, name, email, birth, joindate) values(?,?,?,?,?,now())";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getEmail());
			pstmt.setString(5, dto.getBirth());

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}

	public int chkDup(String inputId) {

		// 반환 값 : 사용가능 | 중복 | 글자수 제한 | 문자형태 제한 | 영문+숫자형태 제한
		// 0 1 2 3 4

		int flag = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		if (inputId.length() < 6 || inputId.length() > 16) {
			flag = 2;
			return flag;
		} else if (inputId.matches("[^a-zA-Z0-9]+")) {
			flag = 3;
			return flag;
		} else if (inputId.matches("[a-zA-Z]+") || inputId.matches("[0-9]+")) {
			flag = 4;
			return flag;
		}

		String sql = "select id from tourful_member where id = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, inputId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				flag = 1;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return flag;
	}

	public String findID(String name, String email) {
		String id = "";
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select id from tourful_member where name=? and email=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, email);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				id = rs.getString("id");
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return id;
	}

	public String findPW(String name, String email, String id) {
		String pw = "";
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select pw from tourful_member where name=? and email=? and id = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, email);
			pstmt.setString(3, id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				pw = rs.getString("pw");
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return pw;
	}

	public int loginMember(String id, String pw) {
		int flag = 0;
		// 0 : 로그인 불가 | 1 : 로그인 성공 | 2 : 어드민 계정
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "Select admin from tourful_member where id=? and pw = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				if (rs.getString("admin").equals("1")) {
					flag = 2;
					return flag;
				} else {
					flag = 1;
					return flag;
				}
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return flag;
	}

	public void changePW(String id, String pw) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "update into tourful_member set pw=? where id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pw);
			pstmt.setString(2, id);
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

}
