<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

<h2>DB연동 테스트 </h2>

<%
	Connection conn = null;
	
	try{
		Context init = new InitialContext();
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/OracleDB");
		conn = ds.getConnection();
		
		out.println("<h3>연결되었습니다.</h3>");
	} catch(Exception e){
		out.println("<h3>실패</h3>");
		e.printStackTrace();
	}
%>