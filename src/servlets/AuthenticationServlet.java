package servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import services.UserServices;

/**
 * Servlet implementation class AuthenticationServlet
 */
@WebServlet(urlPatterns={"/login", "/signup"})
public class AuthenticationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AuthenticationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		String urlPattern = request.getServletPath();
		
		switch(urlPattern){					 
			case "/login":	System.out.println(request.getParameter("username") + " " + request.getParameter("password"));
							boolean found = findUser(request, response); /* if user is found in db, log in user */
							response.getWriter().write(String.valueOf(found));
							
							System.out.println(found);
							break;
							
			case "/signup": System.out.println(request.getParameter("username") + " " + request.getParameter("password"));
							found = findUser(request, response);
							if(found){ /* if user is already registered */
								response.getWriter().write(String.valueOf(false));
							} else { /* successfully register user */
								User u = new User(request.getParameter("username"), request.getParameter("password"), request.getParameter("description"));
								UserServices.addUser(u);
								response.getWriter().write(String.valueOf(true));
							}
							
							break;
		}
	}
	
	public boolean findUser(HttpServletRequest request, HttpServletResponse response){
		boolean found = false;
		
		String username = request.getParameter("username");	
		List<User> allUsers = UserServices.getAllUsers();
		
		System.out.println("searching for " + username);
		
		for(int i = 0; i < allUsers.size(); i++){
			if(allUsers.get(i).getUsername().equals(username)){
				System.out.println("user found!");
				found = true;
			}
		}
		
		return found;
	}
}
