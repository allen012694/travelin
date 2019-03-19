
<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Bài viết" name="headtitle" />
</jsp:include>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="tag" uri="/resources/libs/travelin/taglib/customTaglib.tld"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%-- <%@ include file="search.jsp"%> --%>
	<div class="content">
		<div class="w3-row" id="articles">
			<div class="w3-col l8" id="articlesmain">
				<div id="banner">Danh sách bài viết</div>
				<c:if test="${not empty articles }">
					<c:forEach items="${articles }" var="article">
						<div class="w3-row" id="articlesitem">
							<div id="title">
								<a href="/travelin/articles/${article.id }">${article.title }</a>
							</div>

							<div class="w3-col l3">
								<a href="/travelin/articles/${article.id }"> <img
									style="width: 100%; height: 150px;"
									src="<c:url value="/resources/images/articles/${article.id }.jpg"  />"
									alt="${article.title }">
								</a>
							</div>
							<div class="w3-col l9">
								<div id="shortcontent">

									<div id="time">
										<fmt:formatDate type="both" dateStyle="short"
											timeStyle="short" value="${article.createddate }"
											pattern="dd/MM/yyyy HH:mm:ss" />
										đăng bởi ${article.author.username }
									</div>
									${article.description}
									<!-- ${fn:substring(article.description, 0, 60)}... -->
								</div>
								<button class="w3-col l3 w3-btn"
									onclick="location.href='/travelin/articles/${article.id }';"
									id="readmorebtn">XEM THÊM</button>
							</div>
							<div class="w3-row" id="seperate"></div>
						</div>
					</c:forEach>
				</c:if>
				<div id="pagenav">
					<tag:paginate steps="6" page="${page}" count="${count}"
						uri="/travelin/articles?type=last&" first="&laquo;" last="&raquo;"
						next="&rsaquo;" previous="&lsaquo;" />
				</div>
			</div>
			<div class="w3-col l4" id="articlessub">
				<div id="banner">BÀI VIẾT NỔi BẬT</div>
				<div id="hotarts">
					<c:if test="${not empty hotArticles }">
						<c:forEach items="${hotArticles }" var="hotArt">
							<div class="w3-row" id="articlesitem">
								<div class="w3-col l4">
									<a href="/travelin/articles/${hotArt.Id }"> <img
										style="width: 100%; height: 80px;"
										src="<c:url value="/resources/images/articles/${hotArt.Id }.jpg"  />"
										alt="${hotArt.Title }">
									</a>
								</div>
								<div class="w3-col l8">
									<div id="title">
										<a href="/travelin/articles/${hotArt.Id }">${hotArt.Title }</a>
									</div>
									<div style="margin: 5px 0 0 5%;">${fn:substring(hotArt.Description, 0, 60)}<c:if
											test="${fn:length(hotArt.Description) > 60}">...</c:if>
									</div>
								</div>
								<div class="w3-row" id="seperate"></div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div id="banner">BÀI VIẾT MỚI NHẤT</div>
				<div id="hotarts">
					<c:if test="${not empty lastarticles }">
						<c:forEach items="${lastarticles }" var="article">
							<div class="w3-row" id="articlesitem">
								<div class="w3-col l4">
									<a href="/travelin/articles/${article.id }"> <img
										style="width: 100%; height: 80px;"
										src="<c:url value="/resources/images/articles/${article.id }.jpg"  />"
										alt="${article.title }">
									</a>
								</div>
								<div class="w3-col l8">
									<div id="title">
										<a href="/travelin/articles/${article.id }">${article.title }</a>
									</div>
									<div style="margin: 5px 0 0 5%;">${fn:substring(article.description, 0, 60)}<c:if
											test="${fn:length(article.description) > 60}">...</c:if>
									</div>
								</div>
								<div class="w3-row" id="seperate"></div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div id="banner">TỪ KHÓA NỔI BẬT</div>
				<div id="hottags">
					<c:if test="${not empty hotTags}">
						<c:forEach items="${hotTags}" var="tag">
							<a href="/travelin/search?t=${tag.name}">${tag.name}</a>
						</c:forEach>
					</c:if>
				</div>

			</div>


		</div>

	</div>




	<script
		src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script
		src="<c:url value="/resources/libs/esimakin-twbs-pagination/jquery.twbsPagination.js" />"></script>
	<script
		src="<c:url value="/resources/libs/admin/js/bootstrap.min.js" />"></script>

	<jsp:include page="footer.jsp"></jsp:include>