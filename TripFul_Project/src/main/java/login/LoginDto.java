package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

import mysql.db.DbConnect;

public class LoginDto {
	
	private String id, pw, name, email, birth;
	private int admin;
	private Timestamp joindate;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public int getAdmin() {
		return admin;
	}
	public void setAdmin(int admin) {
		this.admin = admin;
	}
	public Timestamp getJoindate() {
		return joindate;
	}
	public void setJoindate(Timestamp joindate) {
		this.joindate = joindate;
	}
	@Override
	public String toString() {
		return "LoginDto [id=" + id + ", pw=" + pw + ", name=" + name + ", email=" + email + ", birth=" + birth
				+ ", admin=" + admin + ", joindate=" + joindate + "]";
	}
	
	
	
}
