<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@page import="javax.naming.NamingException"%>

<%
	request.setCharacterEncoding("UTF-8");

	String dong="";
	if(request.getParameter("dong")!=null)
		dong = request.getParameter("dong");
	
	int cpage=1;
	if(request.getParameter("cpage")!=null)
		cpage = Integer.parseInt(request.getParameter("cpage"));
	
	
	//페이징을 위한 변수 선언
	int rows = 0;
	int perpage = 10; //한 페이지당 보여지는 글 수
	int perblock = 5; //한 페이지 블록당 들어가는 페이지수
	int totalpage = 0;
	int skip = 0;
	int startblock = (((cpage-1)/perblock)*perblock)+1;
	int endblock = (((cpage-1)/perblock)*perblock)+perblock;
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer sb= null;
	String query = "";
	

	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource)envCtx.lookup("jdbc/oracle");
		conn = ds.getConnection();

		if(!dong.equals("")){	
			query = "select zipcode, sido, gugun, dong, bunji from zipcode where dong like ?";
		}
		pstmt = conn.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		pstmt.setString(1, "%"+dong+"%");
		if(!dong.equals("")){
			rs = pstmt.executeQuery();
		}
		sb = new StringBuffer();
		//데이타의 총 개수
		rs.last();
		rows = rs.getRow();
		rs.beforeFirst();
		//종 페이지의 수
		totalpage = (rows%perpage==0)? rows/perpage : rows/perpage+1;
		if(totalpage <= endblock)
			endblock = totalpage;

		//각 페이지의 첫번째 보여줄 자료의 번호, 건너뛸 단위
		skip =(cpage-1)*perpage +1;
		if(skip > 0) rs.absolute(skip);
		
			for(int i=0;i <perpage && rs.next(); i++){
				sb.append("<tr>");
				sb.append("<td>"+rs.getString("zipcode")+"</td><td>"+rs.getString("sido")+"</td><td>"+rs.getString("gugun")+"</td><td>"+rs.getString("dong")+"</td><td>"+rs.getString("bunji")+"</td>");
				sb.append("</tr>");
			}
		
	} catch (NamingException e) {
	} catch (SQLException e) {
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException e) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
		if (conn != null) try { conn.close(); } catch (SQLException e) { }
	}


%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우편번호 검색기</title>
<script language='javascript'>
<!--
	String.prototype.trim = function() {
		return this.replace(/(^\s*)|(\s*$)/gi, "");
	}

	function ChkForm(form) {
		if(document.frm.dong.value.trim() == ""){
			window.alert("동이름을 입력해주세요.");
			return false;
		}
		else if(document.frm.dong.value.trim().length < 2){
			window.alert("2자 이상 입력해주세요.");
			return false;
		}
		return true;
	}
//-->
</script>
</head>
<body>
<form action='post.jsp' method='post' name='frm' onsubmit='return ChkForm(this)'>
<table border='0'>
<tr>
<td>동 이름 : </td>
<td>
<input type='text' name='dong' value='<%=dong %>'>
</td>
<td>
<input type='submit' value='찾기'>
</td>
</tr>
</table>

<table border='0'>
<% if(sb != null)
	out.println(sb); %>
</table>
<% if(!dong.equals("")) { %>
		<table width='100%' border='0' cellpadding='0' cellspacing='0'>
			<tr>
				<td width='500' height='30'>

<!-- 페이지 네비게이션 -->				
				<%
				if(cpage <= perblock)
					out.println("");
				else
					out.println("<a href='post.jsp?cpage="+(startblock-1)+"&dong="+dong+"'><<</a>");
				
				if(cpage==1)
					out.println("");
				else
					out.println("<a href='post.jsp?cpage="+(cpage-1)+"&dong="+dong+"'><</a>");
				%>
				
				|
				<% 
				
				for(int i=startblock;i <= endblock; i++){
					if(i==cpage)
						out.println("<b><u>["+i+"]</u></b>");
					else
						out.println("<a href='post.jsp?cpage="+i+"&dong="+dong+"'>"+i+"</a>");
				}
				%>
				|
				
				<%
				if(cpage == totalpage)
					out.println("");
				else
					out.println("<a href='post.jsp?cpage="+(cpage+1)+"&dong="+dong+"'>></a>");
				
				if(endblock >= totalpage)
					out.println("");
				else
					out.println("<a href='post.jsp?cpage="+(endblock+1)+"&dong="+dong+"'>>></a>");

				%>
<!--  -->			

</td>
				<td align='right'></td>
			</tr>
		</table>
		
<% } %>
</form>
</body>
</html>