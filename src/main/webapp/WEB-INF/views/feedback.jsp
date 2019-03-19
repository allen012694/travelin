<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="header.jsp" %>
		<div class="content">
		<div class="w3-row" id="feedback">
	<div id="banner">Đóng góp ý kiến của bạn ở đây</div>
	<div style="width: 90%;margin-left:5%;margin-right:5%">
	<form:form action="/travelin/feedback/new" method="post" modelAttribute="newFeedback" onkeypress="return event.keyCode != 13;">
		<form:textarea class="w3-input w3-col l12" id="commenttext"
										style="resize:none" rows="5" path="content" />
		
		<input class="w3-btn" type="submit" value="Gửi">
	</form:form>
	</div>
		</div>
	</div>
<%@ include file="footer.jsp" %>