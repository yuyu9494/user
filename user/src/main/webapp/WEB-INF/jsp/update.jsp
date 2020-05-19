<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/paginationjs/2.1.4/pagination.css"/>
<script>
  $(document).ready(function() {
	// 수정
    $("#updateBtn").on("click", function() {
      if ($("#password").val() == "") {
        alert("비밀번호를 입력해주세요.");
        $("#password").focus();
        return false;
      }
      if ($("#name").val() == "") {
        alert("이름을 입력해주세요.");
        $("#name").focus();
        return false;
      }
      if ($("#address2").val() == "") {
        alert("상세 주소를 입력해주세요.");
        $("#address2").focus();
        return false;
      }
      if (confirm("수정하시겠습니까?")) {
        $("#updateForm").attr("action", "/update");
        $("#updateForm").submit();
      }
    });

    // 삭제
    $("#deleteBtn").on("click", function() {
      if (confirm("정말 탈퇴하시겠습니까?")) {
        $("#updateForm").attr("action", "/delete");
        $("#updateForm").submit();
      }
    })

    // 취소
    $("#cancleBtn").on("click", function() {
      location.href = "/login";
    })
    
    // modal 버튼 클릭 시 값 초기화
    $("#zip_codeBtn").on("click", function() {
      $("#data-container").empty();
      $("#pagination").empty();
      $("#query").val("");
    })
    
    // 우편번호 찾기 성공 => 주소 값을 input으로 삽입
    $("#data-container").on("click", function(event) {
      console.log(event.target.tagName);
      if(event.target.tagName !== "A") return;
      const addressATag = event.target;
      const zipcodeDivTag = addressATag.parentNode.previousSibling; // 에이태그의 부모노드로 가서 형제노드를 잡아주는?
      const address = addressATag.innerText;
      const zipcode = zipcodeDivTag.innerText;
      put(address, zipcode);
  	})
  })
  
  $(function() {
    // 검색버튼 눌렸을 때 함수 실행
    $("#searchBtn").click(function(e) {
      e.preventDefault();
      // ajax
      $.ajax({
      // zip_codeList controller 진입 url
      url : "zip_codeList",
      // zip_codeForm을 serialize 해줍니다.
      data : $("#zip_codeForm").serialize(),
      type : "POST",
      dataType : "json",
      success : function(result) {
        $("#data-container > div").remove();
        if (result.errorCode != null && result.errorCode != "") {
          $("#pagination").empty();
          alert(result.errorMessage);
        } else {
          // 검색결과를 list에 담는다.
          var list = result.list;

          $(function() {
            let container = $("#pagination");
            container.pagination({
            dataSource : function(done) {
              var list = result.list;

              var map = [];

              for (var i = 0; i < list.length; i++) {
                var zipcode = list[i].zipcode; // 우편번호
                var address = list[i].address; // 주소

                map.push(list[i].zipcode + list[i].address);
              }
              done(list);
            },
            pageSize : 5,
            callback : function(data, pagination) {
              var dataHtml = "";

              $.each(data, function(index, list) {
                dataHtml += '<div class="row text-center border-bottom">'
                dataHtml += '<div class="col-md-4 m-2">' + list.zipcode + "</div>";
                dataHtml += '<div class="col-md-7 m-2"><a href="#" >' + list.address + '</a></div>';
                dataHtml += '</div>'

              });

              $("#data-container").html(dataHtml);

            },
            });
          });
        }
        // 완성된 html(우편번호 list)를 zip_codeList밑에 append
        // $("#zip_codeList").append(html);
      }
      });
    });
  });

  // 원하는 우편번호 선택시 함수 실행
  function put(address, zipcode) {
    console.log("put", put);
    var address = address;
    var zipcode = zipcode;
    // 모달창 닫기
    $("#zip_codeModal").modal("hide");
    $("#zip_code").val(zipcode);
    $("#address1").val(address);
  }
</script>

<title>Member Update Page</title>

</head>
<body>
	<div class="container">
		<div class="container col-md-8">
			<div class="card m-5">
				<div class="card-header text-center">회원 정보</div>
				<div class="card-body">
					<form name="updateForm" id="updateForm" method="post">
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">아이디</label>
							<div class="col-md-7">
								<input type="text" id="id" name="id" class="form-control" readonly value="${member.id}" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">비밀번호</label>
							<div class="col-md-7">
								<input type="password" id="password" name="password" class="form-control" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">이름</label>
							<div class="col-md-7">
								<input id="name" name="name" class="form-control" value="${member.name}" />
							</div>
						</div>

						<div class="form-group row">
							<label class="col-md-3 col-form-label text-md-center">주소</label>
							<div class="input-group col-md-4">
								<input type="text" id="zip_code" name="zipcode" class="form-control" readonly value="${member.zipcode}" />
							</div>
							<div class="input-group col-md-4">
								<button type="button" class="btn btn-outline-secondary" id="zip_codeBtn" data-toggle="modal" data-target="#zip_codeModal">우편번호 찾기</button>
							</div>
						</div>
						<div class="form-group row">
							<div class="col-md-3"></div>
							<div class="input-group col-md-7">
								<input type="text" id="address1" name="address1" class="form-control" readonly value="${member.address1}" />
							</div>
						</div>
						<div class="form-group row">
							<div class="col-md-3"></div>
							<div class="input-group col-md-7">
								<input type="text" id="address2" name="address2" class="form-control" value="${member.address2}" />
							</div>
						</div>
						<div class="text-right">
							<button class="btn btn-primary" type="button" id="updateBtn">수정</button>
							<button class="btn btn-warning" type="button" id="deleteBtn">탈퇴</button>
							<button class="btn btn-primary" type="button" id="cancleBtn">취소</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<!-- modal -->
		<div class="modal fade" id="zip_codeModal">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header text-center">
						<b class="modal-title text-center" id="myModalLabel"> 우편번호 찾기 </b>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">x</span>
						</button>
					</div>
					<div class="modal-body text-center">
						<form id="zip_codeForm">
							<div class="input-group">
								<div class="input-group col-md-8">
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
								<!-- <table class="table table-hover text-center">
									<thead class="thead-light">
										<tr>
											<th style="width: 150px;">우편번호</th>
											<th style="width: 600px;">주소</th>
										</tr>
									</thead>
									<tbody id="zip_codeList"></tbody>
								</table> -->

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
									<div class="text-center m-2" id="pagination"></div>
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
