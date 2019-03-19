package fu.cap.travelin.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "ArticleTag", uniqueConstraints = @UniqueConstraint(columnNames = { "ArticleId", "TagId" }) )
public class ArticleTag implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "ArticleId")
    private Article article;

    @ManyToOne
    @JoinColumn(name = "TagId")
    private Tag tag;

    public ArticleTag() {
    }

    public ArticleTag(Integer id, Article article, Tag tag) {
        this.id = id;
        this.article = article;
        this.tag = tag;
    }

    public ArticleTag(Article article, Tag tag) {
        this.article = article;
        this.tag = tag;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }
}
