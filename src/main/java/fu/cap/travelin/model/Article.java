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
@Table(name = "Article")
public class Article implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "Title")
    private String title;

    @Column(name = "Content")
    private String content;

    @Column(name = "DataStatus", columnDefinition = "INT(11) DEFAULT 1")
    private Integer datastatus;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "UpdatedDate", insertable = false, updatable = false)
    private Date updateddate;

    @ManyToOne
    @JoinColumn(name = "AuthorId")
    private Account author;

    @Column(name = "Description")
    private String description;
    // @Column(name = "ViewCount")
    // private Integer viewcount;

    @Column(name = "Priority", columnDefinition = "INT(11) DEFAULT 1")
    private Integer priority;

    // @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    // @JoinTable(name = "ArticleTag", joinColumns = @JoinColumn(name =
    // "ArticleId"), inverseJoinColumns = @JoinColumn(name = "TagId"))
    // private Set<Tag> tags = new HashSet<Tag>();

    public Article(Integer id, String title, String content, Integer datastatus, Account author, Integer priority,
            String description) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.datastatus = datastatus;
        this.author = author;
        this.priority = priority;
        this.description = description;
        // this.viewcount = viewcount;
    }

    public Article(Integer id, String title, String content, Integer datastatus, Date createddate, Date updateddate,
            Account author, Integer priority, String description) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.datastatus = datastatus;
        this.createddate = createddate;
        this.updateddate = updateddate;
        this.author = author;
        this.priority = priority;
        this.description = description;
        // this.viewcount = viewcount;
    }

    public Article() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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

    public Account getAuthor() {
        return author;
    }

    public void setAuthor(Account author) {
        this.author = author;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    // public Set<Tag> getTags() {
    // return tags;
    // }
    //
    // public void setTags(Set<Tag> tags) {
    // this.tags = tags;
    // }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
