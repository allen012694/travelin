<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:include page="header.jsp">
    <jsp:param value="TravelIn" name="headtitle"/>
</jsp:include>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/autocomplete/jquery.auto-complete.css" />">
		<div class="header">
			<div class="bannerHolder">
				<div class="BannerReel" id="Reel">
				<c:forEach items="${lastarts}" var="art" varStatus="counter">
					<div class="banner" id="banner${counter.index + 1}">
						<h1 style="background: rgba(0,0,0,0.6);">${art.title}</h1>
						<p>
							<br><a href="/travelin/articles/${art.id}">Xem chi tiết</a>
						</p>
						<img src="<c:url value="/resources/images/articles/${art.id}.jpg"/>" />
					</div>
				</c:forEach>
				</div>
				<ul class="BannerNav">
					<li><a href="#">1</a></li>
					<li><a href="#">2</a></li>
					<li><a href="#">3</a></li>
					<li><a href="#">4</a></li>
					<li><a href="#">5</a></li>
				</ul>
				<a href="#" id="goNext">&raquo;</a> <a href="#" id="goPrev">&laquo;</a>
			</div>
		</div>
			<%@ include file="search.jsp" %>
		<div class="content">
			<div class="w3-row" id="placelists">
				<div class="w3-container" style="text-align:center; color:#faf5ef">
				DANH SÁCH TỈNH THÀNH
				</div>
				<div class="pagespan container" id="scrollcontainer">
					<div class="wrap" id="places">
						<div class="frame smart" id="framelist" style="overflow-x: hidden; overflow-y: hidden;">
							<ul class="items" id="areas" style="height: 3030px; -webkit-transform: translateZ(0px) translateY(-303px);">
							</ul>
						</div>
						<div class="controls center">
						</div>
					</div>
					<div class="wrap" id="placedetails">

						<div class="frame nonitembased" id="framedetails" style="overflow-x: hidden; overflow-y: hidden;">
							<div class="slidee" id="areadetails" style="-webkit-transform: translateZ(0px);">
							</div>
						</div>
						
						<div class="controls center">
						</div>
					</div>
	</div>
				</div>
			<div class="w3-row" id="hotjournals" >
				<div class="w3-container" style="text-align:center">
					CHUYẾN ĐI NỔI BẬT
				</div>
				<c:if test="${not empty bestjours}">
				<div class="w3-row-padding w3-margin-top">
					<c:forEach items="${bestjours}" var="jour" varStatus="c">
							<div class="w3-quarter w3-margin-top">
								<a href="/travelin/journals/${jour.id}">
									<div class="w3-card-2">
										<img src="<c:url value="/resources/images/journals/${jour.id}/theme.jpg"/>" style="width: 100%;height:100%">
										<span class="w3-card-2-in">${jour.title}</span>
									</div>
								</a>
							</div>
						<c:if test="${c.index == 3}">
							
							
						</c:if>
					</c:forEach>
					</div>
				</c:if>
			</div>
			<div class="w3-row" id="hotplaces">
			<div class="w3-container" style="text-align:center">
					ĐỊA ĐIỂM MỚI NHẤT
				</div>
				<div style="float: right;margin: 0 2% 20px 0;">
					<!-- <hr>e -->
					<span style="color: #EDEDED">Tại </span>
					<select id="ctysel">
						<option value="-1">- Khu vực -</option>
						<c:if test="${not empty cities}">
							<c:forEach items="${cities }" var="city">
								<option value="${city.id }">${city.name}</option>
							</c:forEach>
						</c:if>
					</select>
				</div>
				<div class="tabs">
					<div class="loading-layer" style="height: 650px;display:none;"><img src="<c:url value="/resources/libs/travelin/img/ring.gif"/>"></div>
					<div class="tab w3-col l3" id="firsttabcontainer">
						<input type="radio" id="tab-1" name="tab-group-1" checked> <label for="tab-1" class="w3-twothird" id="firsttab" style="cursor: pointer;">Ăn Uống</label>
						<div class="tabcontent" id="tab1">
							<c:if test="${not empty lastestplaces[0]}">
							<div class="w3-row-padding w3-margin-top">
								<c:forEach items="${lastestplaces[0]}" var="place" varStatus="i">
									<div class="w3-third w3-margin-top">
										<a href="/travelin/places/${place.id}">
											<div class="w3-card-2">
												<img src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%;height:100%">
												<span class="w3-card-2-in">${place.name}</span>
											</div>
										</a>
									</div>
								</c:forEach>
							</div>
							</c:if>
						</div>
					</div>

					<div class="tab w3-col l2">
						<input type="radio" id="tab-2" name="tab-group-1" class="w3-col l2"> 
						<label for="tab-2" class="w3-col" style="cursor: pointer;">Du lịch</label>
						<div class="tabcontent" id="tab2">
							<c:if test="${not empty lastestplaces[1]}">
							<div class="w3-row-padding w3-margin-top">
								<c:forEach items="${lastestplaces[1]}" var="place" varStatus="i">
									<div class="w3-third w3-margin-top">
										<a href="/travelin/places/${place.id}">
											<div class="w3-card-2">
												<img src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%;height:100%">
												<span class="w3-card-2-in">${place.name}</span>
											</div>
										</a>
									</div>
								</c:forEach>
							</div>
							</c:if>
						</div>
					</div>

					<div class="tab w3-col l2">
						<input type="radio" id="tab-3" name="tab-group-1" class="w3-col l2"> 
						<label for="tab-3" class="w3-col" style="cursor: pointer;">Sức khỏe</label>
						<div class="tabcontent" id="tab3">
							<c:if test="${not empty lastestplaces[2]}">
							<div class="w3-row-padding w3-margin-top">
								<c:forEach items="${lastestplaces[2]}" var="place" varStatus="i">
									<div class="w3-third w3-margin-top">
										<a href="/travelin/places/${place.id}">
											<div class="w3-card-2">
												<img src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%;height:100%">
												<span class="w3-card-2-in">${place.name}</span>
											</div>
										</a>
									</div>
								</c:forEach>
							</div>
							</c:if>
						</div>
					</div>
					<div class="tab w3-col l2">
						<input type="radio" id="tab-4" name="tab-group-1" class="w3-col l2"> 
						<label for="tab-4" class="w3-col" style="cursor: pointer;">Giải trí</label>
						<div class="tabcontent" id="tab4">
							<c:if test="${not empty lastestplaces[3]}">
							<div class="w3-row-padding w3-margin-top">
								<c:forEach items="${lastestplaces[3]}" var="place" varStatus="i">
									<div class="w3-third w3-margin-top">
										<a href="/travelin/places/${place.id}">
											<div class="w3-card-2">
												<img src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%;height:100%">
												<span class="w3-card-2-in">${place.name}</span>
											</div>
										</a>
									</div>
								</c:forEach>
							</div>
							</c:if>
						</div>
					</div>

					<div class="tab w3-col l3" id="lasttabcontainer">
						<input type="radio" id="tab-5" name="tab-group-1" class="w3-col l2"> 
						<label for="tab-5" class="w3-twothird" style="cursor: pointer;">Mua sắm</label>
						<div class="tabcontent" id="tab5">
						<c:if test="${not empty lastestplaces[4]}">
							<div class="w3-row-padding w3-margin-top">
								<c:forEach items="${lastestplaces[4]}" var="place" varStatus="i">
									<div class="w3-third w3-margin-top">
										<a href="/travelin/places/${place.id}">
											<div class="w3-card-2">
												<img src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%;height:100%">
												<span class="w3-card-2-in">${place.name}</span>
											</div>
										</a>
									</div>
								</c:forEach>
							</div>
						</c:if>
						</div>
					</div>

				</div>
			</div>

		
<%@ include file="footer.jsp" %>

<script src="<c:url value="/resources/libs/autocomplete/jquery.auto-complete.min.js" />"></script>

<script type="text/javascript">

	$(document).ready(function() {
		$('#ctysel').on('change', function() {
			$('.loading-layer').show();
			// $('.tabs tabcontent').remove();
			$.ajax({
				url: "/travelin/lasthomeplaces",
				type: 'POST',
				data: {
					'aid': $(this).val()
				},
				dataType: 'JSON'
			}).success(function(data) {
				$('.tabs .tabcontent').empty();
				
				for (var i = 0; i < data.length; i++) {
					if (data[i].length > 0) {
						var tab = $('#tab'+(i+1));
						tab.append($('<div class="w3-row-padding w3-margin-top"></div>'));
						var tabinner = tab.children().first();
						for (var j = 0; j < data[i].length; j++) {
							var tabcont = '<div class="w3-third w3-margin-top">'
										+'<a href="/travelin/places/'+data[i][j].id+'">'
										+	'<div class="w3-card-2">'
										+		'<img src="/travelin/resources/images/places/'+data[i][j].id+'/theme.jpg" style="width: 100%;height:100%">'
										+		'<span class="w3-card-2-in">'+data[i][j].name+'</span>'
										+	'</div>'
										+'</a>'
										+'</div>';
							tabinner.append(tabcont);
						}
					}
				}

				$('.loading-layer').hide();
			});
		});
	});
	
</script>

