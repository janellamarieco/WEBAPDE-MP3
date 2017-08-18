package servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Photo;
import beans.User;
import services.PhotoServices;
import services.UserServices;

/**
 * Servlet implementation class PhotoController
 */
@WebServlet(urlPatterns={"/loadPublicPhotos", "/uploadPhoto", "/tagUser"})
public class PhotoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PhotoController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String urlPattern = request.getServletPath();
		
		switch(urlPattern){
		case "/loadPublicPhotos": request.setAttribute("publicPhotos", loadAllPublicPhotos(request, response));
								  request.getRequestDispatcher("index.jsp").forward(request, response);
								  break;
		case "/uploadPhoto": break;
		case "/tagUser": System.out.println(request.getParameter("username") + " " + request.getParameter("password"));
					  	 boolean found = findUser(request, response);
	 					 if(found){ /* if user is in db */
							response.getWriter().write(String.valueOf(true));
						 } else { /* successfully register user */
							response.getWriter().write(String.valueOf(false));
						 }
						 break;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String urlPattern = request.getServletPath();
		
		switch(urlPattern){
			case "/loadPublicPhotos": request.setAttribute("publicPhotos", loadAllPublicPhotos(request, response));
							 		  request.getRequestDispatcher("index.jsp").forward(request, response);
							 		  break;
			case "/findUser": System.out.println(request.getParameter("username") + " " + request.getParameter("password"));
		  	 				  User found = findUser(request, response);
		  	 				  if(found != null){ /* if user is in db */
		  	 					  response.getWriter().write(String.valueOf(true));
		  	 				  } else { /* successfully register user */
		  	 					  response.getWriter().write(String.valueOf(false));
		  	 				  }
		  	 				  break;
			case "/tagUser": System.out.println(request.getParameter("username") + " " + request.getParameter("password"));
							 found = findUser(request, response);
							 int id = Integer.parseInt(request.getParameter("photo_id"));
							 if(found != null){ /* if user is in db */
								PhotoServices.addUserTag(id, found);
							 } else { /* successfully register user */
								 response.getWriter().write(String.valueOf(false));
							 }
							 break;
		}
	}
	
	protected List<Photo> loadAllPublicPhotos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Photo> allPhotos = PhotoServices.getAllPhotos();
		List<Photo> publicPhotos = new ArrayList<Photo>();
		for(int i = 0; i < allPhotos.size(); i++){
			allPhotos.get(i).toString();
			if(allPhotos.get(i).getPrivacy().equals("public")){
				publicPhotos.add(allPhotos.get(i));
			}
		}
		
		System.out.println("got all public photos");
		
		return publicPhotos;
	}
	
	protected User findUser(HttpServletRequest request, HttpServletResponse response){
		User found = null;

		String username = request.getParameter("username");	
		List<User> allUsers = UserServices.getAllUsers();

		System.out.println("searching for " + username);

		for(int i = 0; i < allUsers.size(); i++){
			if(allUsers.get(i).getUsername().equals(username)){
				System.out.println("user found!");
				found = allUsers.get(i);
			}
		}

		return found;
	}

}
