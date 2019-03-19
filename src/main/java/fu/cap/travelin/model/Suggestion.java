package fu.cap.travelin.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Suggestion")
public class Suggestion implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "Id")
	private Integer id;

	@ManyToOne
	@JoinColumn(name = "AuthorId")
	private Account author;

	@ManyToOne
	@JoinColumn(name = "PlaceId")
	private Place place;

	@Column(name = "Content")
	private String content;

	@Column(name = "DataStatus", columnDefinition = "INT(11) DEFAULT 1")
	private Integer datastatus;

	@Column(name = "Recommend")
	private Integer recommend;

	@Column(name = "CreatedDate", insertable = false, updatable = false)
	private Date createddate;

	@Column(name = "UpdatedDate", insertable = false, updatable = false)
	private Date updateddate;

	public Suggestion() {
	}

	public Suggestion(Integer id, Account author, Place place, String content, Integer datastatus, Integer recommend,
			Date createddate, Date updateddate) {
		this.id = id;
		this.author = author;
		this.place = place;
		this.content = content;
		this.datastatus = datastatus;
		this.recommend = recommend;
		this.createddate = createddate;
		this.updateddate = updateddate;
	}

	public Suggestion(Integer id, Account author, Place place, String content, Integer datastatus, Integer recommend) {
		this.id = id;
		this.author = author;
		this.place = place;
		this.content = content;
		this.datastatus = datastatus;
		this.recommend = recommend;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Account getAuthor() {
		return author;
	}

	public void setAuthor(Account author) {
		this.author = author;
	}

	public Place getPlace() {
		return place;
	}

	public void setPlace(Place place) {
		this.place = place;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getDatastatus() {
		return datastatus;
	}

	public void setDatastatus(Integer datastatus) {
		this.datastatus = datastatus;
	}

	public Integer getRecommend() {
		return recommend;
	}

	public void setRecommend(Integer recommend) {
		this.recommend = recommend;
	}

	public Date getCreateddate() {
		return createddate;
	}

	public void setCreateddate(Date createddate) {
		this.createddate = createddate;
	}

	public Date getUpdateddate() {
		return updateddate;
	}

	public void setUpdateddate(Date updateddate) {
		this.updateddate = updateddate;
	}
}
