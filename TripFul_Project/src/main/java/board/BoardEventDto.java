package board;

import java.sql.Timestamp;

public class BoardEventDto {
	private String event_idx;
	private String event_title;
	private String event_content;
	private String event_img;
	private int event_readcount;
	private Timestamp event_writeday;
	private String event_writer;
	
	public String getEvent_idx() {
		return event_idx;
	}
	public void setEvent_idx(String event_idx) {
		this.event_idx = event_idx;
	}
	public String getEvent_title() {
		return event_title;
	}
	public void setEvent_title(String event_title) {
		this.event_title = event_title;
	}
	public String getEvent_content() {
		return event_content;
	}
	public void setEvent_content(String event_content) {
		this.event_content = event_content;
	}
	public String getEvent_img() {
		return event_img;
	}
	public void setEvent_img(String event_img) {
		this.event_img = event_img;
	}
	public int getEvent_readcount() {
		return event_readcount;
	}
	public void setEvent_readcount(int event_readcount) {
		this.event_readcount = event_readcount;
	}
	public Timestamp getEvent_writeday() {
		return event_writeday;
	}
	public void setEvent_writeday(Timestamp event_writeday) {
		this.event_writeday = event_writeday;
	}
	public String getEvent_writer() {
		return event_writer;
	}
	public void setEvent_writer(String event_writer) {
		this.event_writer = event_writer;
	}
	
	
	
	
}
