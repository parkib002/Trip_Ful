package board;

import java.sql.Timestamp;

public class BoardNoticeDto {
	private String notice_idx;
	private String notice_title;
	private String notice_content;
	private String notice_img;
	private int notice_readcount;
	private Timestamp notice_writeday;
	private String notice_writer;
	
	public String getNotice_idx() {
		return notice_idx;
	}
	public void setNotice_idx(String notice_idx) {
		this.notice_idx = notice_idx;
	}
	public String getNotice_title() {
		return notice_title;
	}
	public void setNotice_title(String notice_title) {
		this.notice_title = notice_title;
	}
	public String getNotice_content() {
		return notice_content;
	}
	public void setNotice_content(String notice_content) {
		this.notice_content = notice_content;
	}
	public String getNotice_img() {
		return notice_img;
	}
	public void setNotice_img(String notice_img) {
		this.notice_img = notice_img;
	}
	public int getNotice_readcount() {
		return notice_readcount;
	}
	public void setNotice_readcount(int notice_readcount) {
		this.notice_readcount = notice_readcount;
	}
	public Timestamp getNotice_writeday() {
		return notice_writeday;
	}
	public void setNotice_writeday(Timestamp notice_writeday) {
		this.notice_writeday = notice_writeday;
	}
	public String getNotice_writer() {
		return notice_writer;
	}
	public void setNotice_writer(String notice_writer) {
		this.notice_writer = notice_writer;
	}
	
	
	
	
}
