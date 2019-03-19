<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${param.headtitle}</title>
<%@ include file="library.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {	
	    if($('#dropmenu').length >0){
	    $('#dropmenu').css("left",$('#usercontrol').position().left+$('#usercontrol').find('img').width()-200);
	    }
	    $(window).resize(function(){
	        $('#dropmenu').css("left",$('#usercontrol').position().left+$('#usercontrol').find('img').width()-200);
	    });
	    
		var aid = $('#ijklmn').text();
		if (aid.length > 0) {
			connect(aid);
		}

		 $('#usercontrol').click(function() {
          $('#dropmenu').animate({
            display: 'initial',
            opacity: 'toggle'
          },200);
          return false;
        });

		$('#dropmenu').click(function(ev) {
          ev.stopPropagation();
        });

        $(document).click(function() {
          $('#dropmenu').animate({
            display: 'none',
            opacity: 'hide'
          },200);
        });
	});
	
	
</script>
</head>

<body>

	<div class="w3-row top">
		<%-- <div class="languages">
					<div>
						<a href="#"><img src="<c:url value="/resources/libs/travelin/img/en.jpg"  />" alt="EN"></a> <a href="#"><img
							src="<c:url value="/resources/libs/travelin/img/vn.jpg" />" alt="VN"></a>
					</div>
				</div> --%>
		<div class="w3-col l3 user">

			<c:if test="${currentAccount.email == null}">
				<button class="popup-with-form w3-btn w3-red" id="login_btn">ĐĂNG
					NHẬP</button>
				<!-- <a href="/travelin/login" class="w3-btn w3-red" id="login_btn">ĐĂNG NHẬP</a> -->
				<div class="mfp-hide" id="popup-login">
					<div id="loginform" class="white-popup-block">
						<form class="w3-container" action="/travelin/login-on-page"
							method="POST">
							<div>
								<h1>ĐĂNG NHẬP</h1>
							</div>
							<c:if test="${cookie.containsKey('authen')}">
								<c:set var="authens" value="${fn:split(cookie['authen'].value,'|')}"/>
							</c:if>
							<fieldset style="border: 0;">
								<input class="w3-input" id="email" name="email" type="text" value="${authens[0]}" placeholder="Email" required>
									<input class="w3-input" id="password" name="password" type="password" value="${authens[1]}"
									placeholder="Mật khẩu" required>
									<input class="w3-check" type="checkbox" name="rememberme" <c:if test="${not empty authens}">checked</c:if>> LƯU THÔNG TIN ĐĂNG NHẬP<br>
									<input type="hidden" name="cururl" value="${requestScope['javax.servlet.forward.request_uri']}">
								<div id="errorMessage" style="color: red"></div>
								<button class="w3-btn" id="logonpage">ĐĂNG NHẬP</button>&nbsp&nbsp
								<a href="/travelin/register">Chưa có tài khoản?</a>
							</fieldset>
							<button title="Close (Esc)" type="button" class="mfp-close">×</button>
						</form>
					</div>
				</div>

				<!-- <button class="w3-btn w3-red" id="signup_btn">ĐĂNG KÝ</button> -->

			</c:if>

			<c:if test="${currentAccount.email != null}">
				<span style="display:none" id="ijklmn">${currentAccount.id}</span>
				<div id="noti_Container" class="dropdown">
					<a href="/travelin/journals/new" style="text-decoration:none">
						<img style="vertical-align: middle; display: inline-block; margin-left: 30%; margin-top: -13px;" src="<c:url value="/resources/libs/travelin/img/scroll.png"/>" width="30" height="30">
						<div class="noti_bubble" id="journal-bubble" <c:if test="${fn:length(currentPlaces) == 0}">style="display:none;"</c:if>>${fn:length(currentPlaces)}</div>
					</a>
					<a href="/travelin/messages" style="text-decoration:none">
						<img style="vertical-align: middle; display: inline-block; margin-left:10%; margin-top: -13px;" src="<c:url value="/resources/libs/travelin/img/message.png"/>" width="30" height="30">
						<div class="noti_bubble" id="message-bubble" style="display: none;">0</div>
					</a>
					<a id="usercontrol" href="">
						<img style="vertical-align: middle; display: inline-block; margin-left: 10%; margin-top: -13px;" src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>" class="circled" width="50" height="50">
						<div class="noti_bubble" id="account-bubble" style="display: none;">0</div>
					</a>
				</div>
				<div id="dropmenu">
					<ul>
						<a href="/travelin/dashboard"><li>Bảng tin</li></a>
						<div class="seperate"></div>
						<a href="/travelin/profile"><li>Hồ sơ</li></a>
						<div class="seperate"></div>
						<a href="/travelin/list-friends"><li>Bạn bè</li></a>
						<div class="seperate"></div>
						<a href="/travelin/logout"><li>Đăng xuất</li></a>
					</ul>
				</div>
				<!-- <a href="/travelin/logout" class="w3-btn w3-red" style="margin-top:-40px;">ĐĂNG XUẤT</a> -->
			</c:if>
		</div>

		<div class="w3-col l3 logo">
			<a href="/travelin/"><img
				src="<c:url value="/resources/libs/travelin/img/logo.png"/>"
				align="middle"></a>
		</div>
		<div class="w3-col l6 menu">
			<a class href="/travelin/articles?type=last">Bài viết</a> 
			<a class href="/travelin/places">Địa điểm</a> 
			<a class href="/travelin/journals?type=last">Chuyến đi</a>
		</div>

	</div>