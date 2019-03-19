<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Chuyến đi" name="headtitle"/>
</jsp:include>
<div class="content">
		<div class="w3-row" id="myjournal">
	<div id="banner">Chuyến đi của bạn</div>
	
	<div class="w3-row collection">
		<c:if test="${not empty journals }">
			<c:forEach items="${journals }" var="journal" varStatus="i">
				<div data-id="${journal.id}" class="w3-col card" style="border:1px solid rgba(46,46,46,0.5);margin:20px 1.25%; width: 22.5%">
				  	<a href="/travelin/journals/${journal.id}"><img data-holder-rendered="true" src="<c:url value="/resources/images/journals/${journal.id}/theme.jpg"/>" style="height: 180px; width: 100%; display: block;" class="card-img-top" data-src="holder.js/100px180/" alt="100%x180"></a>
				  	<div class="card-block">
				  		<div class="card-middle">
				  		<c:if test="${journal.datastatus == 1}"><div style="position:absolute;padding-top:5px;padding-left:10px;top:inherit;right:inherit;color:green;"><i id="global" class="fa fa-globe" aria-hidden="true"></i></div></c:if>
				  		<c:if test="${journal.datastatus == 2}"><div style="position:absolute;padding-top:5px;padding-left:10px;top:inherit;right:inherit;color:blue;"><i id="onlyfriend" class="fa fa-users" aria-hidden="true" ></i></div></c:if>
				  		<c:if test="${journal.datastatus == 3}"><div style="position:absolute;padding-top:5px;padding-left:10px;top:inherit;right:inherit;color:red;"><i id="private" class="fa fa-lock" aria-hidden="true" ></i></div></c:if>
				  		<c:if test="${journal.datastatus == 0}"><div style="position:absolute;padding-top:5px;padding-left:10px;top:inherit;right:inherit;"><i id="draft" class="fa fa-file-text" aria-hidden="true" ></i></div></c:if>
				    		<h4 class="card-title" style="padding: 0px 20px;"><a href="/travelin/journals/${journal.id}">${journal.title}</a></h4>
				    	</div>
				    	<div class="card-bottom">
				    		<%--<span><fmt:formatDate type="both" dateStyle="short" timeStyle="short"
							value="${journal.createddate }" pattern="dd/MM/yy HH:mm:ss" /></span>--%>
							<a href="/travelin/profile?k=${targetAccount.id}" style="text-decoration:none;position: relative;  width: 100%; height: 100%;"><img class="circled" style="position: relative;left: 25%;" src="<c:url value="/resources/images/accounts/${targetAccount.id}/avatar.jpg"/>"><p style="text-align: center;margin:0 auto;">${targetAccount.username}</p></a>
							
				    	</div>
				    	<c:if test="${currentAccount.email != null && currentAccount.id == targetAccount.id}">
				    	<div class="w3-row">
					    	<a href="/travelin/journals/update?k=${journal.id}" style="text-align: center" class="w3-col l5 w3-btn w3-red">Sửa</a>
					    	
					    	<button type="button" style="float:right" class="w3-btn w3-teal w3-col l5" onclick="removeJour(${journal.id}, event)">Xóa</button>
				    	</div>
				    	</c:if>
  					</div>
				</div>
			</c:forEach>
		</c:if>
		<c:if test="${currentAccount.email != null && currentAccount.id == targetAccount.id}">
			<a class="w3-col w3-btn " style="width: 22.5%;margin:20px 1.25%;" href="/travelin/journals/new">Tạo chuyến đi mới</a>
		</c:if>
		
	</div>
	</div>
	</div>
	<script src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script type="text/javascript">
		var removeJour = function(jid, e) {
			$.ajax({
				url: '/travelin/journals/del',
				type: 'POST',
				data: {
					jid: jid
				}
			}).success(function() {
				$(e.target).parent().parent().parent().remove();
			});
		};
	</script>
<%@ include file="footer.jsp" %>