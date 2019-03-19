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
@Table(name = "PlaceTag", uniqueConstraints = @UniqueConstraint(columnNames = { "PlaceId", "TagId" }) )
public class PlaceTag implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "PlaceId")
    private Place place;

    @ManyToOne
    @JoinColumn(name = "TagId")
    private Tag tag;

    public PlaceTag() {
    }

    public PlaceTag(Integer id, Place place, Tag tag) {
        this.id = id;
        this.place = place;
        this.tag = tag;
    }

    public PlaceTag(Place place, Tag tag) {
        this.place = place;
        this.tag = tag;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Place getPlace() {
        return place;
    }

    public void setPlace(Place place) {
        this.place = place;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }
}
