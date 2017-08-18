package services;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

import beans.User;

public class UserServices {

	public UserServices(){
		
	}
	
	public static void addUser(User u){
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("webapde");
		EntityManager em = emf.createEntityManager();
		
		EntityTransaction trans = em.getTransaction();
	
		/* insert User U into DB */
		
		try{
			trans.begin();
			
			em.persist(u);
			
			em.persist(u);
			
			trans.commit();
		} catch(Exception e){
			
			if(trans != null){
				trans.rollback();
			}
			
			e.printStackTrace();
			
		} finally{
			em.close();
		}

	}
	
	public static void deleteUser(){
		
	}
	
	public static void editUser(){
		
	}
	
	public static User getUser(int id){
		User u = null;
		
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("webapde");
		EntityManager em = emf.createEntityManager();
		
		EntityTransaction trans = em.getTransaction();
		
		try{
			trans.begin();
			
			u = em.find(User.class, id);
			
			trans.commit();
			System.out.println("user found");
		
		} catch(Exception e){
			e.printStackTrace();
			
		} finally {
			em.close();
		}
		
		return u;
	}
	
	public static List<User> getAllUsers(){
		List<User> users = null;
		
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("webapde");
		EntityManager em = emf.createEntityManager();
		
		EntityTransaction trans = em.getTransaction();
		
		try{
			
			trans.begin();
			
			/* select * from student (em.createNativeQuery("select * from student") 
			 * HQL (Hibernate Query Language) 
			 */
			
			TypedQuery<User> q = em.createQuery("FROM User", User.class);
			users = q.getResultList();
			
			trans.commit();
			System.out.println("got all users from db");
		} catch(Exception e){
			e.printStackTrace();
			
		} finally {
			em.close();
		}
		
		return users;
	}
	
	public static void main(String[] args){
		List<User> users = getAllUsers();
		
		for(int i = 0; i < users.size(); i++){
			users.get(i).toString();
		}
	}
	
}
