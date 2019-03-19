package fu.cap.travelin.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Journal")
public class Journal implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "Title")
    private String title;

    @ManyToOne
    @JoinColumn(name = "AuthorId")
    private Account author;

    @Column(name = "Content")
    private String content;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "UpdatedDate", insertable = false, updatable = false)
    private Date updateddate;

    @Column(name = "Priority")
    private Integer priority;

    @Column(name = "DataStatus", columnDefinition = "INT(11) DEFAULT 1")
    private Integer datastatus;

    // @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    // @JoinTable(name = "JournalPlace", joinColumns = @JoinColumn(name =
    // "JournalId"), inverseJoinColumns = @JoinColumn(name = "PlaceId") )
    // private Set<Place> places = new HashSet<Place>();

    public Journal(Integer id, String title, Account author, String content, Integer priority, Integer datastatus) {
        this.id = id;
        this.author = author;
        this.content = content;
        this.title = title;
        this.priority = priority;
        this.datastatus = datastatus;
    }

    public Journal(Integer id, String title, Account author, String content, Date createddate, Date updateddate,
            Integer priority, Integer datastatus) {
        this.id = id;
        this.author = author;
        this.content = content;
        this.title = title;
        this.createddate = createddate;
        this.updateddate = updateddate;
        this.priority = priority;
        this.datastatus = datastatus;
    }

    public Journal(Integer id, String title, Account author, String content, Date createddate, Date updateddate,
            Integer priority, Integer datastatus, Set<Place> places) {
        this.id = id;
        this.author = author;
        this.content = content;
        this.createddate = createddate;
        this.title = title;
        this.updateddate = updateddate;
        this.priority = priority;
        this.datastatus = datastatus;
        // this.places = places;
    }

    public Journal() {
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
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

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getDatastatus() {
        return datastatus;
    }

    public void setDatastatus(Integer datastatus) {
        this.datastatus = datastatus;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

}
