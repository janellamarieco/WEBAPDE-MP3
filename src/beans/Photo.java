package beans;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="photos")
public class Photo {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int photo_id;
	@Column(name="title")
	private String title;
	@Column(name="description")
	private String description;
	@Column(name="privacy")
	private String privacy;
	@Column(name="url")
	private String url;
	
	@ManyToOne
	@JoinColumn(name="user_id", referencedColumnName="user_id")
	private User user;

	@ManyToMany
	@JoinTable(name="photo_tags", 
		joinColumns = @JoinColumn(name = "photo_id"), 
		inverseJoinColumns = @JoinColumn(name = "tag_id"))
	private List<Tag> tags = new ArrayList<Tag>();
	
	@ManyToMany
	@JoinTable(name= "shared_users", 
		joinColumns = @JoinColumn(name = "photo_id"), 
		inverseJoinColumns = @JoinColumn(name = "user_id"))
	private List<User> sharedTo = new ArrayList<User>();
	
	public Photo(){
		
	}

	public int getPhoto_id() {
		return photo_id;
	}

	public void setPhoto_id(int photo_id) {
		this.photo_id = photo_id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPrivacy() {
		return privacy;
	}

	public void setPrivacy(String privacy) {
		this.privacy = privacy;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return "Photo [photo_id=" + photo_id + ", title=" + title + ", description=" + description + ", privacy="
				+ privacy + ", url=" + url + ", user=" + user + "]";
	}
	
	
}
