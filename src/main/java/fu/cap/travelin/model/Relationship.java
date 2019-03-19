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
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "Relationship", uniqueConstraints = @UniqueConstraint(columnNames = { "AccountFirstId",
        "AccountSecondId" }) )
public class Relationship implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "AccountFirstId")
    private Account accountfirst; // inviter

    @ManyToOne
    @JoinColumn(name = "AccountSecondId")
    private Account accountsecond; // receiver

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "UpdatedDate", insertable = false, updatable = false)
    private Date updateddate;

    @Column(name = "Status")
    private Integer status;

    public Relationship(Integer id, Account accountfirst, Account accountsecond, Date createddate, Date updateddate,
            Integer status) {
        this.id = id;
        this.accountfirst = accountfirst;
        this.accountsecond = accountsecond;
        this.createddate = createddate;
        this.updateddate = updateddate;
        this.status = status;
    }

    public Relationship(Account accountfirst, Account accountsecond, Integer status) {
        this.accountfirst = accountfirst;
        this.accountsecond = accountsecond;
        this.status = status;
    }

    public Relationship() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Account getAccountfirst() {
        return accountfirst;
    }

    public void setAccountfirst(Account accountfirst) {
        this.accountfirst = accountfirst;
    }

    public Account getAccountsecond() {
        return accountsecond;
    }

    public void setAccountsecond(Account accountsecond) {
        this.accountsecond = accountsecond;
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

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

}
