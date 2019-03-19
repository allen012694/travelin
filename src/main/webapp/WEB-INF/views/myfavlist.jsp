<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Danh sách yêu thích"
		name="headtitle" />
</jsp:include>


<div id="profilecontainer">
	<div class="w3-col l3" style="width: 24%; margin-right: 1%">
		<div class="panel">
			<div class="media media-photo-block">
				<div>
					<img
						src="<c:url value="/resources/images/accounts/${accountProfile.id}/avatar.jpg"/>"
						style="width: 100%; height: 220px;" class="img-responsive">
				</div>
			</div>
			<div class="panel-body">
				<h2 class="text-center" style="margin-top: 0;">${accountProfile.username}</h2>
				<ul class="list-unstyled text-center text-bold"
					style="margin-bottom: 0;">
					<li><a href="/travelin/profile?k=${accountProfile.id}"
						class="link-styled">Xem hồ sơ</a></li>
				</ul>
			</div>
		</div>

		<c:if test="${currentAccount.id == accountProfile.id}">
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
		</c:if>
		<c:if test="${currentAccount.id != accountProfile.id}">
			<div class="panel">
				<div class="panel-header">Chuyển tiếp</div>

				<div class="panel-body">
					<ul class="list-unstyled text-bold">
						<li><a href="/travelin/myjournals?k=${accountProfile.id}">Chuyến đi đã đăng</a><hr></li>
						<li><a href="/travelin/favorite/list?k=${accountProfile.id}">Danh sách yêu thích</a></li>
					</ul>
				</div>
			</div>
		</c:if>
	</div>

	<div class="w3-col l9" style="width: 74%; margin-left: 1%">
		<div class="panel">
			<div class="panel-header">
				<h4>Chuyến đi yêu thích</h4>
				<div class="panel-body w3-row">
					<div class="collection">
						<c:if test="${not empty favJournals}">
							<c:forEach items="${favJournals}" var="journal">
								<a href="/travelin/journals/${journal.id}">
									<div class="w3-col card" style="width: 24%;margin: 0px 1px;">
											<img data-holder-rendered="true" src="<c:url value="/resources/images/journals/${journal.id}/theme.jpg"/>" style="width: 100%; display: block;" class="card-img-top" data-src="holder.js/100px180/" alt="100%x180">
										<div class="card-block">
											<div class="card-middle">
												<h4 class="card-title">
													<a href="/travelin/journals/${journal.id}">${journal.title}</a>
												</h4>
											</div>
											<div class="card-bottom">
												<a href="/travelin/profile?k=${journal.author.id}" style="text-decoration:none;position: relative;"><p style="text-align: center;margin:0 auto;">${journal.author.username}</p></a>
											</div>
										</div>
									</div>
								</a>
							</c:forEach>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="w3-col l9" style="width: 74%; margin-left: 1%">
		<div class="panel">
			<div class="panel-header">
				<h4>Địa điểm yêu thích</h4>
				<div class="panel-body w3-row">
					<div class="collection">
						<c:if test="${not empty favPlaces}">
							<c:forEach items="${favPlaces}" var="place">
								<a href="/travelin/places/${place.id}">
									<div class="w3-col card" style="width: 24%;margin: 1px 1px;">
										<img data-holder-rendered="true"
											src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>"
											style="width: 100%; display: block;" class="card-img-top"
											data-src="holder.js/100px180/" alt="100%x180">
										<div class="card-block">
											<div class="card-middle">
												<h4 class="card-title">
													<a href="/travelin/places/${place.id}">${place.name}</a>
												</h4>
											</div>
											<div class="card-bottom">
												<span style="font-size: 10px;">${place.address}, ${place.area.name}</span>
											</div>
										</div>
									</div>
								</a>
							</c:forEach>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>
<jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript">
$(document).ready(function() {
$(window).resize(function(){
$('.card img, .card-middle').css("height", $('.card').width()*0.5);})
$('.card img, .card-middle').css("height", $('.card').width()*0.5);
$('.card').removeClass("hidden");
});
</script>