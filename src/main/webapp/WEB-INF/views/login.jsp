<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:include page="header.jsp">
    <jsp:param value="TravelIn" name="headtitle"/>
</jsp:include>
<style>
	#loginpage h1{
	font-family: "UTMBEBAS";
	margin-top: 20px;
	background: #2e2e2e;
	color: #faf5ef;
	text-align: center;
	font-size: 28px;
	letter-spacing: 2px;
	word-spacing: 6px;
	line-height: 40px;
	border: 1px solid #2e2e2e;
	}
</style>
	<div class="content" id="loginpage" style="width: 50%;background:#faf5ef;margin: 20px 25%;padding: 20px 5% 20px 5%;">
	<div>
								<h1>ĐĂNG NHẬP</h1>
							</div>
		<div class="w3-row">

	<c:if test="${cookie.containsKey('authen')}">
		<c:set var="authens" value="${fn:split(cookie['authen'].value,'|')}"/>
	</c:if>
		<p style="color: red;">${err }</p>
		<form:form action="/travelin/login" method="post" modelAttribute="accountForm">
		<form:input class="w3-input" path="email" type="text" value="${authens[0]}" placeholder="Email"/><br>
		<form:input class="w3-input" path="password" type="password" value="${authens[1]}" placeholder="Mật khẩu"/><br><br>
		<input style="margin-bottom: 20px" class="w3-check" type="checkbox" name="rememberme" <c:if test="${not empty authens}">checked</c:if>> LƯU THÔNG TIN ĐĂNG NHẬP<br>
		<input type="submit" value="Đăng nhập" class="w3-btn w3-red">
		<a  style="margin-left:5%;" href="/travelin/register">Chưa có tài khoản?</a>
	</form:form></div>
</div>
<%@ include file="footer.jsp" %>