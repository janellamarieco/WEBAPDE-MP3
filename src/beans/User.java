package beans;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="users")
public class User {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int user_id;	
	@Column
	private String username;
	@Column
	private String password;
	@Column
	private String description;
	
	@OneToMany(mappedBy = "user")
	List<Photo> photos = new ArrayList<Photo>();

	@ManyToMany(mappedBy = "sharedTo")
	List<Photo> sharedToMe = new ArrayList<Photo>();
	
	public User(){
		
	}

	public User(String username, String password, String description){
		this.username = username;
		this.password = password;
		this.description = description;
	}
	
	public User(String username, String password){
		this.username = username;
		this.password = password;
		this.description = null;
	}
	
	public int getUesr_id() {
		return user_id;
	}

	public void setUesr_id(int user_id) {
		this.user_id = user_id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public String toString() {
		return "User [user_id=" + user_id + ", username=" + username + ", password=" + password + ", description="
				+ description + "]";
	}
	
	
	
}	
