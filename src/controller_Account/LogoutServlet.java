package controller_Account;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;


/**
 * Servlet implementation class LogoutServlet
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogoutServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("LogoutServlet");
		request.getSession().removeAttribute("user");
		request.getSession().removeAttribute("level");
		request.getSession().removeAttribute("doID");
		request.getSession().removeAttribute("cart");
		request.getSession().removeAttribute("checkcart");
		request.getSession().removeAttribute("vaild");
//		String cookiename="myuser";
//		String findname =request.getParameter("user");// 該用戶名稱
//		String findpassword =request.getParameter("password");// 該用戶密碼
//		Cookie[] cookies = request.getCookies();
//		  for(Cookie cookie:cookies)
//		  {
//			  String name = cookie.getName();
//			  String value = cookie.getValue();
//			  if(cookiename.equals(name)&& (findname +"&"+findpassword).equals(value))
//			  {
//				  cookie.setMaxAge(0);
//				  response.addCookie(cookie);
//				  System.out.println("logout cookies" + name+ value+cookie.getMaxAge());
//
//			  }
//		  }
			response.sendRedirect("HomeServlet");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
