package servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import services.UserServices;

/**
 * Servlet implementation class WelcomeServlet
 */
@WebServlet(urlPatterns={"/home"})
public class WelcomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WelcomeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String urlPattern = request.getServletPath();
		
		switch(urlPattern){
			case "/home": System.out.println("REDIRECTING TO PHOTO CONTROLLER"); 
						 	 response.sendRedirect("loadPublicPhotos");
							 break;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String urlPattern = request.getServletPath();
		
		switch(urlPattern){
			case "/home": System.out.println("REDIRECTING TO PHOTO CONTROLLER"); 
							 response.sendRedirect("loadPublicPhotos");
							 break;
		}
	}
	
}
