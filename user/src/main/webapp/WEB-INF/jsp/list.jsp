<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- Bootstrap -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요한) -->
<script src="http://code.jquery.com/jquery.js"></script>
<!-- 모든 합쳐진 플러그인을 포함하거나 (아래) 필요한 각각의 파일들을 포함하세요 -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<!-- pagination -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/paginationjs/2.1.4/pagination.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/paginationjs/2.1.4/pagination.css" />

<script>
$(document).ready(function() {
  $("table th, td").addClass("small");
})
</script>

<title>Member List Page</title>
</head>
<body>
	<div class="container col-md-10">
		<div class="card m-5">
			<div class="card-header text-center">Member List</div>
			<div class="card-body">
				<form name="listForm" id="listForm" method="post">
					<table class="table table-bordered table-hover text-center">
						<thead class="thead-light">
							<tr>
								<th>Id</th>
								<th>Password</th>
								<th>Name</th>
								<th>Zipcode</th>
								<th>Address</th>
								<th>Update</th>
								<th>Delete</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${member}" var="member">
								<tr>
									<td>${member.id }</td>
									<td>${member.password }</td>
									<td>${member.name }</td>
									<td>${member.zipcode }</td>
									<%-- <td>${member.address1 }</td> --%>
									<td>
									<c:choose>
										<c:when test="${fn:length(member.address1) > 20}">
											<c:out value="${fn:substring(member.address1, 0, 20)}" />...
										</c:when>
										<c:otherwise>
											<c:out value="${member.address1 }" />
										</c:otherwise>
									</c:choose>
									</td>
									<td><a type="button" class="btn btn-primary" href="#" id="updateBtn">Update</a></td>
									<td><a type="button" class="btn btn-warning" href="/listdel?id=${member.id }" onclick="if (!(confirm('Are you sure you want to delete this member?'))) return false">Delete</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div id="pagination"></div>
				</form>

				<div class="text-right">
					<spring:url value="/signup" var="addURL" />
					<a class="btn btn-primary" href="/signup" role="button">Add New Member</a>
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>