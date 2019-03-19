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
@Table(name= "Feedback")
public class Feedback implements Serializable{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="Id")
	private Integer id;
	
	@ManyToOne
	@JoinColumn(name="AccountId")
	private Account account;
	
	@Column(name= "CreatedDate", insertable = false, updatable = false)
	private Date createddate;
	
	@Column(name="UpdatedDate", insertable = false, updatable = false)
	private Date updateddate;
	
	@Column(name="Content")
	private String content;
	
	@Column(name="DataStatus", columnDefinition = "INT(11) DEFAULT 1")
	private Integer datastatus;
	
	@ManyToOne
	@JoinColumn(name="UpdatedAccountId")
	private Account updatedaccount;
	
	public Feedback() {}

	public Feedback(Integer id, Account account, Date createddate, Date updateddate, String content, Integer datastatus,
			Account updatedaccount) {
		this.id = id;
		this.account = account;
		this.createddate = createddate;
		this.updateddate = updateddate;
		this.content = content;
		this.datastatus = datastatus;
		this.updatedaccount = updatedaccount;
	}

	public Feedback(Integer id, Account account, String content, Integer datastatus) {
		this.id = id;
		this.account = account;
		this.content = content;
		this.datastatus = datastatus;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
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

	public Account getUpdatedaccount() {
		return updatedaccount;
	}

	public void setUpdatedaccount(Account updatedaccount) {
		this.updatedaccount = updatedaccount;
	}
}
