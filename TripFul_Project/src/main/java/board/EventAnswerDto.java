package board;

import java.sql.Timestamp;

public class EventAnswerDto {
	private String answer_idx;
	private String content;
	private String writer;
	private Timestamp writeday;
	private String event_idx;
	private int likecount;
	private boolean userHasLiked;
	
	public boolean isUserHasLiked() {
		return userHasLiked;
	}
	public void setUserHasLiked(boolean userHasLiked) {
		this.userHasLiked = userHasLiked;
	}
	public String getAnswer_idx() {
		return answer_idx;
	}
	public void setAnswer_idx(String answer_idx) {
		this.answer_idx = answer_idx;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public Timestamp getWriteday() {
		return writeday;
	}
	public void setWriteday(Timestamp writeday) {
		this.writeday = writeday;
	}
	public String getEvent_idx() {
		return event_idx;
	}
	public void setEvent_idx(String event_idx) {
		this.event_idx = event_idx;
	}
	public int getLikecount() {
		return likecount;
	}
	public void setLikecount(int likecount) {
		this.likecount = likecount;
	}
	
	
}
