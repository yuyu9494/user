<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0"/ -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<!-- Bootstrap -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요한) -->
<script src="https://code.jquery.com/jquery-3.5.0.min.js"></script>
<!-- 모든 합쳐진 플러그인을 포함하거나 (아래) 필요한 각각의 파일들을 포함하세요 -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<!-- Respond.js 으로 IE8 에서 반응형 기능을 활성화하세요 (https://github.com/scottjehl/Respond) -->
<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>

<!-- pagination -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/paginationjs/2.1.4/pagination.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/paginationjs/2.1.4/pagination.css"/>

<script>
  $(document).ready(function() {
    // 아이디 중복 확인
    $("#id").keyup(function() {
      if ($("#id").val().length >= 2) {
        $.ajax({
        url : "/check",
        type : "post",
        dataType : "json",
        data : {
          "id" : $("#id").val()
        },
        success : function(data) {
          if (data == 1) {
          //alert("이미 존재하는 아이디입니다.");
            $("#signupBtn").attr("value", "N");
            $("#checkMsg").html("이미 존재하는 아이디입니다.");
            $("#checkMsg").addClass("text-danger");
            $("#checkMsg").removeClass("text-primary");
          } else if (data == 0) {
          //alert("사용 가능한 아이디입니다.");
            $("#signupBtn").attr("value", "Y");
            $("#checkMsg").html("사용 가능한 아이디입니다.");
            $("#checkMsg").addClass("text-primary");
            $("#checkMsg").removeClass("text-danger");
          }
        }
        });
      } else {
        // alert("아이디는 두 글자 이상 입력하세요");
        $("#signupBtn").attr("value", "N");
        $("#checkMsg").html("두 글자 이상 입력하세요.");
        $("#checkMsg").addClass("text-danger");
        $("#checkMsg").removeClass("text-primary");
      }
    });

    // 회원 가입 취소
    $("#cancleBtn").on("click", function() {
      location.href = "/login";
    });
    
    // 회원 가입 버튼
    $("#signupBtn").on("click", function() {
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
      if ($("#name").val() == "") {
        alert("이름을 입력하세요");
        $("#name").focus();
        return false;
      }
      if ($("#address2").val() == "") {
        alert("상세주소를 입력하세요");
        $("#address2").focus();
        return false;
      }

      if ($("#signupBtn").val() == "N") {
        alert("아이디를 중복 확인하세요");
      } else if ($("#signupBtn").val() == "Y") {
        $("#form").submit();
        alert("가입을 축하드립니다!");
      }
    });
    
    // 모달 창 클릭 시 주소 리스트 값 초기화
    $("#zip_codeBtn").on("click", function() {
      $("#data-container").empty();
      $("#pagination").empty();
      $("#query").val("");
    })
    
    // 찾은 우편번호를 클릭 시 값을 회원가입 창의 input태그로 삽입
    /* $("#data-container").on("click", function(event) {
      console.log(event.target.tagName);
      if(event.target.tagName !== "A") return;
      const addressATag = event.target;
      const zipcodeDivTag = addressATag.parentNode.previousSibling; // 에이태그의 부모노드로 가서 형제노드를 잡아주는?
      const address = addressATag.innerText;
      // $(this).text();
      // var zipcode = $(this).prop('zipcode');
      const zipcode = zipcodeDivTag.innerText;
      put(address, zipcode);
  	}) */
  	
  	$("#data-container").on("click", "a", function(e) {
      var addressATag = $(e.target);
      console.log(addressATag);
      
      const zipcode = addressATag.parent().prev().text();
      const address = addressATag.text();
      // $(this).text();
      // var zipcode = $(this).prop('zipcode');
      
      $("#zip_codeModal").modal("hide");
      $("#zip_code").val(zipcode);
      $("#address1").val(address);
  	})
  	
  });
  
  /////////////////////////// 우편번호 ////////////////////////////////
  $(function () {
    // 검색버튼 눌렸을 때 함수 실행
    $("#searchBtn").click(function (e) {
      e.preventDefault();
      $.ajax({
        // zip_codeList controller 진입 url
        url: "zip_codeList",
        // zip_codeForm의 객체를 한 번에 받음.
        data: $("#zip_codeForm").serialize(), // input의 정보를 json으로
        type: "POST",
        // dataType 은 json형태로 보냅니다.
        dataType: "json",
        success: function (result) {
          // $("#data-container").empty();
          $("#data-container > div").remove();
          // $("#divTbody > div > p").html("");

          if (result.errorCode != null && result.errorCode != "") {
            $("#pagination").empty();
            // $("#data-container").append('<div class="col-md-12 m-2">' + result.errorMessage + "</div>");
            alert(result.errorMessage);
          } else {
            // 검색결과를 list에 담는다.
            // const list = result.list;
            // const plist = result.plist;

            // pagination.js
            $(function () {
              let container = $("#pagination");
              container.pagination({
                dataSource: function (done) {
                  var list = result.list;

                  var addressList = [];

                  for (var i = 0; i < list.length; i++) {
                    var zipcode = list[i].zipcode; // 우편번호
                    var address = list[i].address; // 주소

                    addressList.push(list[i].zipcode + list[i].address);
                  }
                  done(list);
                },
                pageSize: 5,
                callback: function (data, pagination) {
                  var dataHtml = "";

                  $.each(data, function (index, list) {
                    dataHtml += '<div class="row text-center border-bottom">';
                    dataHtml += '<div class="col-md-4 m-2">' + list.zipcode + "</div>";
                    dataHtml += '<div class="col-md-7 m-2"><a href="#" class="addr" zipcode="'+list.zipcode+'">' + list.address + '</a></div>';
                  	dataHtml += '</div>';
                  	
                  });
                  /* onclick="`put(\ ${list.address}\,\ ${list.zipcode}\)`"  */

                  $("#data-container").html(dataHtml);
                  
                },
              });
            });
            // pagination.js
          }
        },
      });
    });
  });
  
  // 원하는 우편번호 선택시 함수 실행
  /* function put(address, zipcode) {
    console.log("put", address);
    var address = address;
    var zipcode = zipcode;
    // 모달창 닫기
    $("#zip_codeModal").modal("hide");
    $("#zip_code").val(zipcode);
    $("#address1").val(address);
  } */
  
  // 실시간 아이디 중복체크 (oninput)
  /* function checkId() {
    if ($("#id").val().length >= 2) {
      $.ajax({
      url : "/check",
      type : "post",
      dataType : "json",
      data : {
        "id" : $("#id").val()
      },
      success : function(data) {
        if (data == 1) {
          $("#signupBtn").attr("value", "N");
          $("#checkMsg").html("이미 존재하는 아이디입니다.");
          $("#checkMsg").css("color", "red");
        } else if (data == 0) {
          $("#signupBtn").attr("value", "Y");
          $("#checkMsg").html("사용 가능한 아이디입니다.");
          $("#checkMsg").css("color", "blue");
        }
      }
      });
    } else {
      // alert("아이디는 두 글자 이상 입력하세요.");
      $("#checkMsg").html("두 글자 이상 입력하세요.");
      $("#checkMsg").css("color", "red");
    }
  }; */
</script>

<title>SignUp Page</title>

</head>
<body>
	<div class="container">
		<%-- <spring:url value="/insert" var="saveURL" /> --%>
		<div class="container col-md-8">
			<div class="card m-5">
				<div class="card-header text-center">회원 가입</div>
				<div class="card-body">
					<form:form name="form" id="form" class="form-signup" role="form" modelAttribute="memberForm" method="post" action="/signup">
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">아이디</label>
							<div class="col-md-4">
								<form:input path="id" id="id" class="form-control" />
							</div>
							<div class="input-group col-md-4 my-auto">
								<!-- <button type="button" class="btn btn-outline-secondary" id="checkBtn" value="N">중복 확인</button> -->
								<div class="small font-weight-bold" id="checkMsg"></div>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">비밀번호</label>
							<div class="col-md-7">
								<form:password path="password" id="password" class="form-control" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">이름</label>
							<div class="col-md-7">
								<form:input path="name" id="name" class="form-control" />
							</div>
						</div>

						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">주소</label>
							<div class="input-group col-md-4">
								<form:input path="zipcode" type="text" id="zip_code" class="form-control" placeholder="우편번호" readonly="true" />
							</div>
							<div class="input-group col-md-4">
								<button type="button" class="btn btn-outline-secondary" id="zip_codeBtn" data-toggle="modal" data-target="#zip_codeModal">우편번호 찾기</button>
							</div>
						</div>
						<div class="form-group row">
							<div class="col-md-3"></div>
							<div class="input-group col-md-7">
								<form:input path="address1" type="text" id="address1" class="form-control" placeholder="도로명 주소" readonly="true" />
							</div>
						</div>
						<div class="form-group row">
							<div class="col-md-3"></div>
							<div class="input-group col-md-7">
								<form:input path="address2" type="text" id="address2" class="form-control" placeholder="상세 주소" />
							</div>
						</div>
						<div class="text-right" style="margin: 10px;">
							<button type="button" class="btn btn-primary" id="signupBtn" value="N">가입</button>
							<button type="button" class="btn btn-primary" id="cancleBtn">취소</button>
						</div>
					</form:form>
				</div>
			</div>
		</div>

		<!-- modal -->
		<div class="modal fade" id="zip_codeModal">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<b class="modal-title text-center" id="myModalLabel">우편번호 찾기</b>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">x</span>
						</button>
					</div>
					<div class="modal-body text-center">
						<form id="zip_codeForm">
							<div class="input-group">
								<div class="input-group col-md-7">
									<input type="text" class="form-control" name="query" id="query" placeholder="주소를 입력하세요" />
								</div>
								<div class="col-md-4">
									<span class="input-group-btn"> <input type="submit" class="btn btn-outline-secondary" value="검색" id="searchBtn" onkeydown="javascript:if(event.keyCode==13)" />
									</span>
								</div>
							</div>
						</form>
						<br />
						<div>
							<div style="width: 100%; height: 300px; overflow: auto;">
							
								<div id="divTable">
									<div class="row border border-secondary" id="divThead">
										<div class="col-md-4 m-2 text-secondary">
											<b>우편번호</b>
										</div>
										<div class="col-md-7 m-2 text-secondary">
											<b>주소</b>
										</div>
									</div>

									<!-- paging -->
									<div id="data-container"></div>
									<div class="text-center m-2" id="pagination" ></div>
									<!-- //paging -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	<!-- modal -->
	</div>
</body>

</html>