

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="tag"
	uri="/resources/libs/travelin/taglib/customTaglib.tld"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="header.jsp" %>
	<%-- <%@ include file="search.jsp"%> --%>
	<div class="content">
	
		<div class="w3-row articlesresult" id="articles" style="display:none">
			<div class="w3-col l12" id="articlesmain">
			<div class="w3-row" style="margin-top:20px">
				<div class="w3-col l2 change tojournals" style="float:left;margin-left: -5%;background:#2e2e2e">< Chuyến đi</div>
				<div class="w3-col l2 change toplaces" style="float:right;margin-right: -5%;background:#2e2e2e">Địa điểm ></div>
			</div>
				<div id="banner">Danh sách bài viết</div>
				<c:if test="${empty articles }">
									<div class="w3-row" id="articlesitem">
										<h5>Không tìm thấy kết quả phù hợp</h5>
									</div>
				</c:if>	
	<c:if test="${not empty articles }">			
					<c:forEach items="${articles }" var="article">
						<div class="w3-row" id="articlesitem">
							<div id="title">${article.title }</div>

							<div class="w3-col l3">
								<img style="width: 100%; height: 150px;"
									src="<c:url value="/resources/images/articles/${article.id }.jpg"  />"
									alt="${article.title }">
							</div>
							<div class="w3-col l9">
								<div id="shortcontent">

									<div id="time">
										<fmt:formatDate type="both" dateStyle="short"
											timeStyle="short" value="${article.createddate }"
											pattern="dd/MM/yyyy HH:mm:ss" />
										đăng bởi ${article.author.username }
									</div>
									${article.description }
									<!-- ${fn:substring(article.content, 0, 60)} -->
								</div>
								<button class="w3-col l3 w3-btn" onclick="location.href='/travelin/articles/${article.id }';" id="readmorebtn">XEM
									THÊM</button>
							</div>
							<div class="w3-row" id="seperate"></div>
						</div>
					</c:forEach>
				</c:if>
				<%-- <div id="pagenav">
					<tag:paginate steps="6" page="${page}" count="${count}"
						uri="/travelin/articles?type=last&" first="&laquo;" last="&raquo;"
						next="&rsaquo;" previous="&lsaquo;" />
				</div> --%>
			</div>
			


		</div>
		
		
		<div class="w3-row placesresult" id="articles" style="display:show">
			<div class="w3-col l12" id="articlesmain">
			<div class="w3-row" style="margin-top:20px">
				<div class="w3-col l2 change toarticles" style="float:left;margin-left: -5%;background:#2e2e2e">< Bài viết</div>
				<div class="w3-col l2 change tojournals" style="float:right;margin-right: -5%;background:#2e2e2e">Chuyến đi ></div>
			</div>
				<div id="banner">Danh sách địa điểm</div>
				<c:if test="${empty places }">
									<div class="w3-row" id="articlesitem">
										<h5>Không tìm thấy kết quả phù hợp</h5>
									</div>
				</c:if>	
				<c:if test="${not empty places }">
					<c:forEach items="${places }" var="place">
						<div class="w3-row" id="articlesitem">
							<div id="title">${place.name }</div>

							<div class="w3-col l3">
								<img style="width: 100%; height: 150px;"
									src="<c:url value="/resources/images/places/${place.id }/theme.jpg"  />"
									alt="${place.name }">
							</div>
							<div class="w3-col l9">
								<div id="shortcontent">

									<div id="time">
										${place.address }
									</div>
									${place.description }
									
								</div>
								<button class="w3-col l3 w3-btn" onclick="location.href='/travelin/places/${place.id }';" id="readmorebtn">XEM
									THÊM</button>
							</div>
							<div class="w3-row" id="seperate"></div>
						</div>
					</c:forEach>
				</c:if>
				<%-- <div id="pagenav">
					<tag:paginate steps="6" page="${page}" count="${count}"
						uri="/travelin/articles?type=last&" first="&laquo;" last="&raquo;"
						next="&rsaquo;" previous="&lsaquo;" />
				</div> --%>
			</div>
			


		</div>
		
		
		<div class="w3-row journalsresult" id="articles" style="display:none">
			<div class="w3-col l12" id="articlesmain">
			<div class="w3-row" style="margin-top:20px">
				<div class="w3-col l2 change toplaces" style="float:left;margin-left: -5%;background:#2e2e2e">< Địa điểm</div>
				<div class="w3-col l2 change toarticles" style="float:right;margin-right: -5%;background:#2e2e2e">Bài viết ></div>
			</div>
				<div id="banner">Danh sách chuyến đi</div>
				<c:if test="${empty journals }">
					<div class="w3-row" id="articlesitem">
						<h5>Không tìm thấy kết quả phù hợp</h5>
					</div>
				</c:if>	
				<c:if test="${not empty journals }">
					<c:forEach items="${journals }" var="journal">
						<div class="w3-row" id="articlesitem">
							<div id="title">${journal.title }</div>

							<div class="w3-col l3">
								<img style="width: 100%; height: 150px;"
									src="<c:url value="/resources/images/journals/${journal.id }/theme.jpg"  />"
									alt="${journal.title }">
							</div>
							<div class="w3-col l9">
								<div id="shortcontent">

									<div id="time">
										<fmt:formatDate type="both" dateStyle="short"
											timeStyle="short" value="${journal.createddate }"
											pattern="dd/MM/yyyy HH:mm:ss" />
										đăng bởi ${journal.author.username }
									</div>
									${journal.content }
									
								</div>
								<button class="w3-col l3 w3-btn" onclick="location.href='/travelin/journals/${journal.id }';" id="readmorebtn">XEM
									THÊM</button>
							</div>
							<div class="w3-row" id="seperate"></div>
						</div>
					</c:forEach>
				</c:if>
				<%-- <div id="pagenav">
					<tag:paginate steps="6" page="${page}" count="${count}"
						uri="/travelin/articles?type=last&" first="&laquo;" last="&raquo;"
						next="&rsaquo;" previous="&lsaquo;" />
				</div> --%>
			</div>
			


		</div>
		
	</div>
	




	<script
		src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script
		src="<c:url value="/resources/libs/esimakin-twbs-pagination/jquery.twbsPagination.js" />"></script>
	<script
		src="<c:url value="/resources/libs/admin/js/bootstrap.min.js" />"></script>

	<%@ include file="footer.jsp"%>
	<script type="text/javascript">
		$('.tojournals').on('click',function(){
		    $('.placesresult').hide();
		    $('.articlesresult').hide();
		    $('.journalsresult').show();
		    
		})
		$('.toplaces').on('click',function(){
		    
		    $('.articlesresult').hide();
		    $('.journalsresult').hide();
		    $('.placesresult').show();
		    
		})
		$('.toarticles').on('click',function(){
		    $('.placesresult').hide();
		    
		    $('.journalsresult').hide();
		    $('.articlesresult').show();
		    
		})
	</script>