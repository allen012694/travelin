package fu.cap.travelin.model;

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
@Table(name = "Conversation")
public class Conversation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "AccountFirstId")
    private Account accountfirst;

    @ManyToOne
    @JoinColumn(name = "AccountSecondId")
    private Account accountsecond;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "UpdatedDate", insertable = false, updatable = false)
    private Date updateddate;

    @Column(name = "DataStatus")
    private Integer datastatus;

    public Conversation(Integer id, Account accountfirst, Account accountsecond, Date createddate, Date updateddate,
            Integer datastatus) {
        this.id = id;
        this.accountfirst = accountfirst;
        this.accountsecond = accountsecond;
        this.createddate = createddate;
        this.updateddate = updateddate;
        this.datastatus = datastatus;
    }

    public Conversation(Account accountfirst, Account accountsecond, Integer datastatus) {
        this.accountfirst = accountfirst;
        this.accountsecond = accountsecond;
        this.datastatus = datastatus;
    }

    public Conversation() {

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

    public Integer getDatastatus() {
        return datastatus;
    }

    public void setDatastatus(Integer datastatus) {
        this.datastatus = datastatus;
    }
}
