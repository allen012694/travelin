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
@Table(name = "Place")
public class Place implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "Name")
    private String name;

    @Column(name = "Description")
    private String description;

    @ManyToOne
    @JoinColumn(name = "AreaId")
    private Area area;

    @Column(name = "Longtitude")
    private Float longtitude;

    @Column(name = "Latitude")
    private Float latitude;

    @Column(name = "Address")
    private String address;

    @Column(name = "Phone")
    private String phone;

    @Column(name = "Website")
    private String website;

    @Column(name = "WorkingTime")
    private String workingtime;

    @Column(name = "DataStatus", columnDefinition = "INT(11) DEFAULT 1")
    private Integer datastatus;

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

    @Column(name = "Priority", columnDefinition = "INT(11) DEFAULT 0")
    private Integer priority;

    @Column(name = "Type")
    private Integer type;

    @Column(name = "Price")
    private String price;
    // @ManyToMany(fetch = FetchType.LAZY, mappedBy = "places")
    // private Set<Journal> journals = new HashSet<Journal>();

    // @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    // @JoinTable(name = "PlaceTag", joinColumns = @JoinColumn(name =
    // "PlaceId"), inverseJoinColumns = @JoinColumn(name = "TagId"))
    // private Set<Tag> tags = new HashSet<Tag>();

    public Date getUpdateddate() {
        return updateddate;
    }

    public void setUpdateddate(Date updateddate) {
        this.updateddate = updateddate;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public Place() {
    }

    public Place(Integer id, String name, String description, Area area, Float longtitude, Float latitude,
            Integer datastatus, Integer priority, Integer type, String address, String website, String phone,
            String workingtime, String price) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.area = area;
        this.longtitude = longtitude;
        this.latitude = latitude;
        this.datastatus = datastatus;
        this.priority = priority;
        this.type = type;
        this.address = address;
        this.website = website;
        this.phone = phone;
        this.workingtime = workingtime;
        this.price = price;
        // this.journals = journals;
        // this.tags = tags;
    }

    public Place(Integer id, String name, String description, Area area, Float longtitude, Float latitude,
            Integer datastatus, Date createddate, Date updateddate, Account createdaccount, Account updatedaccount,
            Integer priority, Integer type, String address, String website, String phone, String workingtime,
            String price) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.area = area;
        this.longtitude = longtitude;
        this.latitude = latitude;
        this.datastatus = datastatus;
        this.createddate = createddate;
        this.updateddate = updateddate;
        this.createdaccount = createdaccount;
        this.updatedaccount = updatedaccount;
        this.priority = priority;
        this.type = type;
        this.address = address;
        this.website = website;
        this.phone = phone;
        this.workingtime = workingtime;
        this.price = price;
        // this.journals = journals;
        // this.tags = tags;
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

    public Area getArea() {
        return area;
    }

    public void setArea(Area area) {
        this.area = area;
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

    public Integer getDatastatus() {
        return datastatus;
    }

    public void setDatastatus(Integer datastatus) {
        this.datastatus = datastatus;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getWorkingtime() {
        return workingtime;
    }

    public void setWorkingtime(String workingtime) {
        this.workingtime = workingtime;
    }

    public Date getCreateddate() {
        return createddate;
    }

    public void setCreateddate(Date createddate) {
        this.createddate = createddate;
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

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    // public Set<Journal> getJournals() {
    // return journals;
    // }

    // public void setJournals(Set<Journal> journals) {
    // this.journals = journals;
    // }

    // public Set<Tag> getTags() {
    // return tags;
    // }

    // public void setTags(Set<Tag> tags) {
    // this.tags = tags;
    // }
}
