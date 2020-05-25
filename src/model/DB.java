package model;

import java.sql.*;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.io.PrintWriter;
import java.util.logging.Logger;

public class DB{
	
	public static Connection getConnection(String dsvar) {
		Connection con = null;
		try {
//			JNDI 開始
		Context ctx = new javax.naming.InitialContext();
		DataSource ds = (DataSource) ctx.lookup(dsvar);
		con = ds.getConnection();
//			JNDI 結束
	} catch (Exception e) {
		logger.put("Exception caught: " + e.getMessage());
	}
	return con;}
	}
