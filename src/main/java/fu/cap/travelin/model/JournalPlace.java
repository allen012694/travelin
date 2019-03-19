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
@Table(name = "JournalPlace", uniqueConstraints = @UniqueConstraint(columnNames = { "JournalId", "PlaceId" }) )
public class JournalPlace implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "Id")
	private Integer id;

	@ManyToOne
	@JoinColumn(name = "JournalId")
	private Journal journal;

	@ManyToOne
	@JoinColumn(name = "PlaceId")
	private Place place;

	public JournalPlace(Integer id, Journal journal, Place place) {
		this.id = id;
		this.journal = journal;
		this.place = place;
	}

	public JournalPlace(Journal journal, Place place) {
		this.journal = journal;
		this.place = place;
	}

	public JournalPlace() {
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

	public Place getPlace() {
		return place;
	}

	public void setPlace(Place place) {
		this.place = place;
	}
}
