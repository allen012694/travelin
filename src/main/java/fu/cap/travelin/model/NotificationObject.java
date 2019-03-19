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

@Entity
@Table(name = "NotificationObject")
public class NotificationObject implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "AccountId")
    private Account account;

    @Column(name = "ObjectType")
    private String objecttype;

    public NotificationObject() {
    }

    public NotificationObject(Integer id, Account account, String objecttype) {
        this.id = id;
        this.account = account;
        this.objecttype = objecttype;
    }

    public NotificationObject(Account account, String objecttype) {
        this.account = account;
        this.objecttype = objecttype;
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

    public String getObjecttype() {
        return objecttype;
    }

    public void setObjecttype(String objecttype) {
        this.objecttype = objecttype;
    }

}
