package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import board.BoardNoticeDto;
import mysql.db.DbConnect;

public class LoginDao {

	DbConnect db = new DbConnect();

	// 회원 정보 바탕 멤버 DB 저장 (회원가입)
	public void insertMember(LoginDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "insert into tripful_member(id, hash_pw, salt, name, email, birth, joindate) values(?,?,?,?,?,?,now())";

		try {
			String salt = null;
			String hash_pw = null;
			if (dto.getPw() != null) {
				salt = BCrypt.gensalt();
				hash_pw = BCrypt.hashpw(dto.getPw(), salt);
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, hash_pw);
			pstmt.setString(3, salt);
			pstmt.setString(4, dto.getName());
			pstmt.setString(5, dto.getEmail());
			pstmt.setString(6, dto.getBirth());

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}

	// 아이디 각종 제약 조건 확인
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

		String sql = "select id from tripful_member where id = ?";

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

	// 비밀번호 각종 제약 조건 확인
	public int chkPw(String id, String pw) {
		// 0 : DB 검색 실패 | 1 : 이전과 같은 비밀번호 | 2 : 가능

		int flag = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select hash_pw, salt from tripful_member where id = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				String salt = rs.getString("salt");
				String currPw = rs.getString("hash_pw");

				if (currPw.equals(BCrypt.hashpw(pw, salt))) {
					return 1;
				} else {
					return 2;
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

	// 이름 email 사용 ID 찾기
	public String findID(String name, String email) {
		String id = "";
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select id from tripful_member where name=? and email=?";

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

	// 이름 이메일 아이디를 통해 PW, Salt 리턴
	public String[] findPW(String name, String email, String id) {
		String salt = "";
		String pw = "";
		String[] hash_pw = new String[2];
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select hash_pw, salt from tripful_member where name=? and email=? and id = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, email);
			pstmt.setString(3, id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				pw = rs.getString("hash_pw");
				salt = rs.getString("salt");
				hash_pw[0] = pw;
				hash_pw[1] = salt;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		// 복호화 불가능 다만 새 비밀번호 생성시
		// 이전 PW와 비교 이전 비밀번호와 동일한 비밀번호 사용 불가 조건 추가
		return hash_pw;
	}

	// 로그인 시 해당 멤버 있는지 id와 pw를 받아 비교후 리턴
	public int loginMember(String id, String pw) {
		int flag = 0;
		// 0 : 로그인 불가 | 1 : 로그인 성공 | 2 : 어드민 계정
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select admin from tripful_member where id=? and hash_pw = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			String salt = this.getSalt(id); // id를 통해 Salt 가져오는 Method
			if (salt.equals("")) { // Salt 없을시 flag 바로 0 리턴
				return flag;
			}
			String hash_pw = BCrypt.hashpw(pw, salt);
			// System.out.println(hash_pw);
			pstmt.setString(2, hash_pw);

			rs = pstmt.executeQuery();

			if (rs.next()) { // id pw 맞는 지 확인 Select 성공시
				if (rs.getString("admin").equals("1")) { // admin 값 1이면 어드민 계정 flag 2 반환
					flag = 2;
					return flag;
				} else { // 나머지 flag 1 반환
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

	// id와 pw를 받아 pw 해싱후 DB 저장
	public void changePW(String id, String pw) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		String newsalt = BCrypt.gensalt();
		String hash_pw = BCrypt.hashpw(pw, newsalt);

		String sql = "update tripful_member set hash_pw = ?, salt = ? where id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, hash_pw);
			pstmt.setString(2, newsalt);
			pstmt.setString(3, id);

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	// ID를 통해 멤버 각종 정보 리턴
	public LoginDto getOneMember(String id) {
		LoginDto dto = new LoginDto();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from tripful_member where id = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				dto.setIdx(rs.getString("idx"));
				dto.setId(id);
				dto.setEmail(rs.getString("email"));
				dto.setBirth(rs.getString("birth"));
				dto.setName(rs.getString("name"));
				dto.setAdmin(rs.getInt("admin"));
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return dto;
	}

	// ID를 통해 솔트값 리턴 -> 로그인 시 활용
	public String getSalt(String id) {
		String salt = "";

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select salt from tripful_member where id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				salt = rs.getString("salt");
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		// System.out.println(salt);
		return salt;
	}

	// Social 멤버 로그인 시 소셜 테이블에서 해당 멤버 IDX 반환
	public String getMemberIdx(String provider, String key) {
		String m_idx = null;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select member_idx from tripful_social_member where social_provider = ? and social_provider_key = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, provider);
			pstmt.setString(2, key);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				m_idx = rs.getString("member_idx");
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return m_idx;
	}

	// 멤버 IDX를 통해 ID 값 반환 세션 내 아이디 추가 및 글 작성시 남길 ID
	public String getIdwithIdx(String idx) {
		String id = null;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select id from tripful_member where idx=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, idx);
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

	// 최초 소셜 로그인시 소셜 멤버 등록
	public void insertSocialMem(SocialDto s_dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "insert into tripful_social_member values(null, ?, ?, ?)";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, s_dto.getMember_idx());
			pstmt.setString(2, s_dto.getSocial_provider());
			pstmt.setString(3, s_dto.getSocial_provider_key());

			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}

	// 비밀번호 찾기 시 회원 인증
	public boolean authentication(LoginDto dto) {
		boolean flag = false;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from tripful_member where id=? and name=? and email=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getEmail());
			rs = pstmt.executeQuery();

			if (rs.next()) {
				flag = true;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return flag;
	}

	// 회원정보 수정
	public void updateMember(LoginDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "update tripful_member set id = ?, name = ?, email = ?, birth = ? where idx = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getBirth());
			pstmt.setString(5, dto.getIdx());

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	// 총 회원 수
	public int getTotalCount() {
		int n = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select count(*) from tripful_member";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				n = rs.getInt(1);
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return n;
	}

	// 회원 목록
	public List<LoginDto> getList(int startNum, int perPage) {
		List<LoginDto> list = new ArrayList<LoginDto>();
		String sql = "select * from tripful_member order by idx desc limit ?,?";
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			pstmt = conn.prepareStatement(sql);
			// 바인딩
			pstmt.setInt(1, startNum);
			pstmt.setInt(2, perPage);
			// 실행
			rs = pstmt.executeQuery();
			while (rs.next()) {
				LoginDto dto = new LoginDto();
				dto.setIdx(rs.getString("idx"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setEmail(rs.getString("email"));
				dto.setBirth(rs.getString("birth"));
				dto.setJoindate(rs.getTimestamp("joindate"));
				dto.setAdmin(rs.getInt("admin"));
				// list 에 추가
				list.add(dto);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
	}

	// 회원 탈퇴 및 삭제
	public void deleteMember(String id) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "delete from tripful_member where id = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
}
