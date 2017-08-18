package services;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

import beans.Photo;
import beans.User;

public class PhotoServices {

	public void addPhoto(){
		
	}
	
	public void updatePhoto(){
		
	}
	
	public void deletePhoto(){
		
	}
	
	public Photo getPhoto(){
		Photo p = new Photo();
		
		return p;
	}
	
	public static List<Photo> getAllPhotos(){
		List<Photo> allPhotos = new ArrayList<Photo>();
		
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("webapde");
		EntityManager em = emf.createEntityManager();
		
		EntityTransaction trans = em.getTransaction();
		
		try{
			
			trans.begin();
			
			/* select * from student (em.createNativeQuery("select * from student") 
			 * HQL (Hibernate Query Language) 
			 */
			
			TypedQuery<Photo> q = em.createQuery("FROM Photo", Photo.class);
			allPhotos = q.getResultList();
			
			trans.commit();
			System.out.println("got all photos from db");
		} catch(Exception e){
			e.printStackTrace();
			
		} finally {
			em.close();
		}
		
		return allPhotos;
	}
	
	public static boolean addUserTag(int pID, User u){
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("mysqldb");
		EntityManager em = emf.createEntityManager();

		EntityTransaction trans = em.getTransaction();

		boolean updated = false;
		
		try{
			Photo photo = em.find(Photo.class, pID);
			
			trans.commit();
			updated = true;
			
			
		} catch(Exception e){

			if(trans != null){
				trans.rollback();
			}

			e.printStackTrace();

		} finally{
			em.close();
		}

		return updated;
	}
	
	public static void main(String[] args){
		List<Photo> photos = getAllPhotos();
		
		for(int i = 0; i < photos.size(); i++)
			System.out.println(photos.get(i).toString());
	}
}
