<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- jQuery -->
<script src="//code.jquery.com/jquery.min.js"></script>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Member Page</title>
</head>
<body>
	<div class="container">
		<h2>MEMBER List</h2>
		<table class="table table-striped">
			<thead>
				<th scope="row">ID</th>
				<th scope="row">PASSWORD</th>
				<th scope="row">NAME</th>
				<th scope="row">ADDRESS1</th>
				<th scope="row">ADDRESS2</th>
				<th scope="row">Update</th>
				<th scope="row">Delete</th>
			</thead>
			<tbody>
				<c:forEach items="${member}" var="member">
					<tr>
						<td>${member.id }</td>
						<td>${member.password }</td>
						<td>${member.name }</td>
						<td>${member.address1 }</td>
						<td>${member.address2 }</td>
						<td><spring:url value="/article/updateArticle/${member.id }"
								var="updateURL" /> <a class="btn btn-primary"
							href="${updateURL }" role="button">Update</a></td>
						<td><spring:url value="/article/deleteArticle/${member.id }"
								var="deleteURL" /> <a class="btn btn-primary"
							href="${deleteURL }" role="button">Delete</a></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<spring:url value="/signup" var="addURL" />
		<a class="btn btn-primary" href="${addURL }" role="button">Add New Member</a>
	</div>
</body>
</html>