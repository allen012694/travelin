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
@Table(name = "Area")
public class Area implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "Name")
    private String name;

    @Column(name = "Description")
    private String description;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private Date createddate;

    @Column(name = "UpdatedDate", insertable = false, updatable = false)
    private Date updateddate;

    @ManyToOne
    @JoinColumn(name = "CreatedAccountId")
    private Account createdaccount;

    @ManyToOne
    @JoinColumn(name = "UpdatedAccountId")
    private Account updatedaccount;

    @ManyToOne
    @JoinColumn(name = "ParentAreaId")
    private Area parentarea;

    @Column(name = "Longtitude")
    private Float longtitude;

    @Column(name = "Latitude")
    private Float latitude;

    @Column(name = "Type")
    private Integer type;

    @Column(name = "DataStatus", columnDefinition = "INT(11) DEFAULT 1")
    private Integer datastatus;

    @Column(name = "Priority")
    private Integer priority;

    public Area() {
    }

    public Area(Integer id, String name, String description, Integer datastatus, Integer priority) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.datastatus = datastatus;
        this.priority = priority;
    }

    public Area(Integer id, String name, String description, Area parentarea, Date createddate, Date updateddate,
            Account createdaccount, Account updatedaccount, Integer datastatus, Integer priority) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.createddate = createddate;
        this.updateddate = updateddate;
        this.createdaccount = createdaccount;
        this.updatedaccount = updatedaccount;
        this.datastatus = datastatus;
        this.priority = priority;
        this.parentarea = parentarea;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public Account getCreatedaccount() {
        return createdaccount;
    }

    public void setCreatedaccount(Account createdaccount) {
        this.createdaccount = createdaccount;
    }

    public Account getUpdatedaccount() {
        return updatedaccount;
    }

    public void setUpdatedaccount(Account updatedaccount) {
        this.updatedaccount = updatedaccount;
    }

    public Integer getDatastatus() {
        return datastatus;
    }

    public void setDatastatus(Integer datastatus) {
        this.datastatus = datastatus;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Area getParentarea() {
        return parentarea;
    }

    public void setParentarea(Area parentarea) {
        this.parentarea = parentarea;
    }

    public Float getLongtitude() {
        return longtitude;
    }

    public void setLongtitude(Float longtitude) {
        this.longtitude = longtitude;
    }

    public Float getLatitude() {
        return latitude;
    }

    public void setLatitude(Float latitude) {
        this.latitude = latitude;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}
