<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요한) -->
<script src="http://code.jquery.com/jquery.js"></script>
<!-- Bootstrap -->
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	rel="stylesheet" type="text/css" />
<!-- 모든 합쳐진 플러그인을 포함하거나 (아래) 필요한 각각의 파일들을 포함하세요 -->
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$("#logoutBtn").on("click", function() {
			location.href = "/logout";
		})
		$("#signupBtn").on("click", function() {
			location.href = "/signup";
		})
		$("#updateBtn").on("click", function() {
			location.href = "/update";
		})

		$("#loginBtn").on("click", function() {
			if ($("#id").val() == "") {
				alert("아이디를 입력하세요");
				$("#id").focus();
				return false;
			}
			if ($("#password").val() == "") {
				alert("비밀번호를 입력하세요");
				$("#password").focus();
				return false;
			}

		})
	})
</script>
<title>Login Page</title>
</head>
<body>
	<div class="container col-md-7">
		<div class="card m-5">
			<c:if test="${member == null}">
				<div class="card-header text-center">로그인</div>
			</c:if>
			<c:if test="${member != null}">
				<div class="card-header text-center">개인 정보</div>
			</c:if>
			
			<div class="card-body m-5">
				<form method="post" action="/login">
					<c:if test="${member == null}">
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">아이디</label>
							<div class="col-md-8">
								<input type="text" id="id" name="id" class="form-control" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">비밀번호</label>
							<div class="col-md-8">
								<input type="password" id="password" name="password"
									class="form-control" />
							</div>
						</div>
						<div class="text-right">
							<a href="#" id="signupBtn">회원가입</a>
						</div>
						<div class="text-center" style="margin: 10px;">
							<button type="submit" id="loginBtn" class="btn btn-primary">로그인</button>
						</div>
					</c:if>

					<c:if test="${member != null }">
						<div class="text-center">
							<p>${member.id}님환영합니다.</p>
							<button class="btn btn-primary" type="button" id="updateBtn">회원정보
								수정</button>
							<button class="btn btn-primary" type="button" id="logoutBtn">로그아웃</button>
						</div>
					</c:if>

					<c:if test="${msg == false}">
						<div class="text-center">
							<p class="text-danger">아이디 혹은 비밀번호가 정확하지 않습니다.</p>
						</div>
					</c:if>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
