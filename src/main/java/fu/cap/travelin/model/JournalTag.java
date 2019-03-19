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
@Table(name = "JournalTag", uniqueConstraints = @UniqueConstraint(columnNames = { "JournalId", "TagId" }) )
public class JournalTag implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "JournalId")
    private Journal journal;

    @ManyToOne
    @JoinColumn(name = "TagId")
    private Tag tag;

    public JournalTag(Integer id, Journal journal, Tag tag) {
        this.id = id;
        this.journal = journal;
        this.tag = tag;
    }

    public JournalTag(Journal journal, Tag tag) {
        this.journal = journal;
        this.tag = tag;
    }

    public JournalTag() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Journal getJournal() {
        return journal;
    }

    public void setJournal(Journal journal) {
        this.journal = journal;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }
}
