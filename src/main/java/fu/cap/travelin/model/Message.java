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
@Table(name = "Message")
public class Message implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "ConversationId")
    private Conversation conversation;

    @ManyToOne
    @JoinColumn(name = "FromAccountId")
    private Account fromaccount;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "Content")
    private String content;

    @Column(name = "IsRead")
    private Boolean isread;

    @Column(name = "DataStatus")
    private Integer datastatus;

    public Message(Integer id, Conversation conversation, Account fromaccount, Date createddate, String content,
            Boolean isread, Integer datastatus) {
        this.id = id;
        this.conversation = conversation;
        this.fromaccount = fromaccount;
        this.createddate = createddate;
        this.content = content;
        this.isread = isread;
        this.datastatus = datastatus;
    }

    public Message(Conversation conversation, Account fromaccount, String content, Boolean isread, Integer datastatus) {
        this.conversation = conversation;
        this.fromaccount = fromaccount;
        this.content = content;
        this.isread = isread;
        this.datastatus = datastatus;
    }

    public Message() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Conversation getConversation() {
        return conversation;
    }

    public void setConversation(Conversation conversation) {
        this.conversation = conversation;
    }

    public Account getFromaccount() {
        return fromaccount;
    }

    public void setFromaccount(Account fromaccount) {
        this.fromaccount = fromaccount;
    }

    public Date getCreateddate() {
        return createddate;
    }

    public void setCreateddate(Date createddate) {
        this.createddate = createddate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getIsread() {
        return isread;
    }

    public void setIsread(Boolean isread) {
        this.isread = isread;
    }

    public Integer getDatastatus() {
        return datastatus;
    }

    public void setDatastatus(Integer datastatus) {
        this.datastatus = datastatus;
    }

}
