<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - ${currentAccount.firstname}"
		name="headtitle" />
</jsp:include>


<div id="profilecontainer">
	<div class="w3-col l3" style="width: 24%; margin-right: 1%">
		<div class="panel">
			<div class="media media-photo-block">
				<div> <img
					src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>"
					style="width: 100%; height: 220px;" class="img-responsive">
				</div>
			</div>
			<div class="panel-body">
					<h2 class="text-center" style="margin-top: 0;">${currentAccount.username}</h2>
					<ul class="list-unstyled text-center text-bold" style="margin-bottom: 0;">
						<li><a href="/travelin/profile?k=${currentAccount.id}" class="link-styled">Xem hồ sơ</a></li>
					</ul>
				</div>
		</div>

		<div class="panel">
			<div class="panel-header">Chuyển tiếp</div>

			<div class="panel-body" style="padding:0px">
					<ul class="list-unstyled text-bold">
					<c:if test="${(currentAccount.role == 1) || (currentAccount.role == 2) || (currentAccount.role == 3)}">
						<a href="/travelin/admin"><li style="padding: 20px 20px 0px 20px; margin-bottom: -20px;">Trang quản trị<hr></li></a>
					</c:if>
						<a href="/travelin/myjournals"><li style="padding: 20px 20px 0px 20px; ">Chuyến đi của bạn<hr></li></a>
						<a href="/travelin/favorite/list"><li style="padding: 0px 20px 0px 20px;">Danh sách yêu thích<hr></li></a>
						<a href="/travelin/list-friends"><li style="padding: 0px 20px 0px 20px;">Bạn bè<hr></li></a>
						<a href="/travelin/messages"><li style="padding: 0px 20px 0px 20px;">Tin nhắn<hr></li></a>
						<a href="/travelin/logout"><li style="padding: 0px 20px 20px 20px;">Đăng xuất</li></a>
					</ul>
				</div>
		</div>
	</div>

	<div class="w3-col l9" style="width: 74%; margin-left: 1%">
		<div class="panel">
			<div class="panel-header">Danh sách bạn bè</div>

			<div class="panel-body w3-row">
			
				<c:if test="${not empty listfriend1 }">
					<c:forEach items="${listfriend1 }" var="lfriend1">
						
						<div class="w3-col l6" style="margin-bottom:20px">
							<div class="w3-col l3">
								<a href="/travelin/profile?k=${lfriend1.accountsecond.id}"> <img
									src="<c:url value="/resources/images/accounts/${lfriend1.accountsecond.id}/avatar.jpg"/>"
									style="width: 50px; height: 50px;" class="img-responsive">
								</a>
							</div>

							<div class="w3-col l9" >
								<a href="/travelin/profile?k=${lfriend1.accountsecond.id}"> 
									${lfriend1.accountsecond.username}
								</a>
							</div>

						</div>
					</c:forEach>
				</c:if>
				<c:if test="${not empty listfriend2 }">
					<c:forEach items="${listfriend2 }" var="lfriend2">
						
						<div class="w3-col l6" >
							<div class="w3-col l3">
								<a href="/travelin/profile?k=${lfriend2.accountfirst.id}"> <img
									src="<c:url value="/resources/images/accounts/${lfriend2.accountfirst.id}/avatar.jpg"/>"
									style="width: 50px; height: 50px;" class="img-responsive">
								</a>
							</div>

							<div class="w3-col l9">
								<a href="/travelin/profile?k=${lfriend2.accountfirst.id}"> 
									${lfriend2.accountfirst.username}
								</a>
							</div>

						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
	</div>
</div>
<jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript">
    var respFReq = function(e, resStatus) {
        var btn = $(e.target);
        $.ajax({
            url : "/travelin/resp-friend",
            type : "POST",
            data : {

                'responseCode' : resStatus
            },
            dataType : 'json'
        }).success(function() {

        })
    }
</script>