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
@Table(name = "Notification")
public class Notification implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "ObjectId")
    private NotificationObject object;

    @Column(name = "Action")
    private String action;

    @ManyToOne
    @JoinColumn(name = "ActorId")
    private Account actor;

    @Column(name = "Status")
    private Integer status;

    @Column(name = "DetailObjectId")
    private Integer detailobjectid;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "UpdatedDate", insertable = false, updatable = false)
    private Date updateddate;

    public Notification(Integer id, NotificationObject object, String action, Account actor, Integer status,
            Integer detailobjectid) {
        this.id = id;
        this.object = object;
        this.action = action;
        this.actor = actor;
        this.status = status;
        this.detailobjectid = detailobjectid;
    }

    public Notification(NotificationObject object, String action, Account actor, Integer status,
            Integer detailobjectid) {
        this.object = object;
        this.action = action;
        this.actor = actor;
        this.status = status;
        this.detailobjectid = detailobjectid;
    }

    public Notification() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public NotificationObject getObject() {
        return object;
    }

    public void setObject(NotificationObject object) {
        this.object = object;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Account getActor() {
        return actor;
    }

    public void setActor(Account actor) {
        this.actor = actor;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getDetailobjectid() {
        return detailobjectid;
    }

    public void setDetailobjectid(Integer detailobjectid) {
        this.detailobjectid = detailobjectid;
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
