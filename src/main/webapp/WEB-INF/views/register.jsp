<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% pageContext.setAttribute("currentYear", java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Đăng ký" name="headtitle" />
</jsp:include>
<div class="content">
	<div class="w3-row" id="register">
		<div id="banner">ĐĂNG KÝ</div>
		<form:form id="registerform" action="/travelin/register" method="post"
			modelAttribute="accountForm" onkeypress="return event.keyCode != 13;">

			<div class="w3-row">
				<label class="w3-col l3">Email*:</label> 
				<form:input class="w3-input w3-col l9" path="email" type="email"
					placeholder="Email" required="true" />
					<!-- <p id="validmess"></p> -->
					<p id="errEmail">${errEmail}</p>
					
			</div>
			<div class="w3-row">
				<label class="w3-col l3">Tên đại diện*:</label> 
				<form:input class="w3-input w3-col l9" path="username" type="text"
					placeholder="Tên đại diện" required="true" pattern="[a-zA-Z0-9 ]{4,50}" />
					<!-- <p id="validmess1"></p> -->
					<p id="errUsername">${errUsername}</p>
			</div>
			<div class="w3-row">
				<label class="w3-col l3">Mật khẩu*:</label> 
				<form:input class="w3-input w3-col l9" id="newpassword" path="password"
					type="password" placeholder="Mật khẩu" required="true" pattern=".{6,32}" />
			</div>
			<div class="w3-row">
				<label class="w3-col l3">Xác Nhận Mật khẩu*:</label> 
				<input class="w3-input w3-col l9" id="renewpassword" type="password"
					placeholder="Xác Nhận Mật khẩu" required pattern=".{6,32}" />

			</div>
			<div id="renewmessage"></div>

			<div class="w3-row">
				<label class="w3-col l3">Họ:</label> 
				<form:input class="w3-input w3-col l9" path="lastname" type="text"
					placeholder="Họ" pattern=".{1,32}" />
			</div>
			<div class="w3-row">
				<label class="w3-col l3">Tên:</label> 
				<form:input class="w3-input w3-col l9" path="firstname" type="text"
					placeholder="Tên" pattern=".{1,32}" />
			</div>
			<div class="w3-row">
				<label class="w3-col l3">Giới tính:</label> 
				<form:select class="w3-select w3-col l9" path="gender">
					<form:option value="0">Không xác định</form:option>
					<form:option value="1">Nam</form:option>
					<form:option value="2">Nữ</form:option>
				</form:select>
			</div>
			<div class="w3-row">
				<label class="w3-col l3">Ngày sinh:</label> 
				<select class="w3-select w3-quarter" name="day">
					<option value="-1">-Ngày-</option>
					<c:forEach begin="1" end="31" step="1" varStatus="i">
						<option value="<fmt:formatNumber type="number" minIntegerDigits="2" value="${i.index }" />">${i.index }</option>
					</c:forEach>
				</select>
				<select class="w3-select w3-quarter" name="month">
					<option value="-1">-Tháng-</option>
					<c:forEach begin="1" end="12" step="1" varStatus="i">
						<option value="<fmt:formatNumber type="number" minIntegerDigits="2" value="${i.index }" />">${i.index }</option>
					</c:forEach>
				</select>
				<select class="w3-select w3-quarter" name="year">
					<option value="-1">-Năm-</option>
					<c:forEach begin="${currentYear - 100}" end="${currentYear}" step="1" varStatus="i">
						<option value="<fmt:formatNumber type="number" pattern="0000" value="${i.index }" />">${i.index }</option>
					</c:forEach>
				</select>
				<form:input path="birthdate" type="hidden"/>
			</div>
			<input id="subbtn" type="submit" value="Đăng Ký" style="display:none">
			<button type="button" class="w3-btn" onclick="onSubmit(event)">Đăng ký</button>
			<input class="w3-btn" type="reset" value="Nhập lại">
		</form:form>
	</div>
</div>
<script type="text/javascript">
    $('#registerform input[name="email"]').blur(function() {
        var email = $(this).val();
        if (email.length > 0) { 
	        $.ajax({
	            url : "/travelin/checkEmailExists",
	            type : "POST",
	            data : {
	                email : email
	            },
	            dataType: 'JSON'
	        }).success(function(data) {
	            if (data.status == 2) {
	            	$('#errEmail').html("<span style='color: #d54859'>Email đã tồn tại!!!</span>");
	            } else if (data.status == -1) {
	            	$('#errEmail').html("<span style='color: #d54859'>Email không hợp lệ!!!</span>");
	            }else if (data.status == 1) {
	            	$('#errEmail').empty();
	            } else {
	            	alert("Có lỗi xảy ra, xin thử lại sau");
	            }
	            // if(data==true)
	            // $('#validmess').html("Email đã tồn tại!!!");
	            // else if(data==false)
	            //     $('#validmess').html("");
	        });
		}
    });
    
    $('#registerform input[name="username"]').blur(function() {
        var username = $(this).val();
        if (username.length > 0) {
	        $.ajax({
	            url : "/travelin/checkUsernameExists",
	            type : "POST",
	            data : {
	                username : username
	            },
	            dataType: 'JSON'
	        }).success(function(data) {
	            if (data.status == 2) {
	            	$('#errUsername').html("<span style='color: #d54859'>Username đã tồn tại!!!</span>");
	            } else if (data.status == 1) {
	            	$('#errUsername').empty();
	            } else {
	            	alert("Có lỗi xảy ra, xin thử lại sau");
	            }
	            // if(data==true)
	            // $('#validmess1').html("Tên đại diện đã tồn tại!!!");
	            // else if(data==false)
	            //     $('#validmess1').html("");
	        });
		}	
    });

    $("#renewpassword").blur(function() {
        if ($(this).val() != $("#newpassword").val()) {
            $("#renewmessage").html("<span style='color: #d54859'>Mật khẩu xác nhận không trùng khớp !</span>");
        } else {
            $("#renewmessage").html("");
        }
    });

    $('select[name="day"]').on('change', function() {
    	var day = $('select[name="day"]').val() == -1 ? '' : $('select[name="day"]').val();
    	var month = $('select[name="month"]').val() == -1 ? '' : $('select[name="month"]').val();
    	var year = $('select[name="year"]').val() == -1 ? '' : $('select[name="year"]').val();
    	var dateofbirth = day + "/" + month + "/" + year; 
    	$('input[name="birthdate"]').val(dateofbirth);
    });
    $('select[name="month"]').on('change', function() {
    	var day = $('select[name="day"]').val() == -1 ? '' : $('select[name="day"]').val();
    	var month = $('select[name="month"]').val() == -1 ? '' : $('select[name="month"]').val();
    	var year = $('select[name="year"]').val() == -1 ? '' : $('select[name="year"]').val();
    	var dateofbirth = day + "/" + month + "/" + year; 
    	$('input[name="birthdate"]').val(dateofbirth);
    });
    $('select[name="year"]').on('change', function() {
    	var day = $('select[name="day"]').val() == -1 ? '' : $('select[name="day"]').val();
    	var month = $('select[name="month"]').val() == -1 ? '' : $('select[name="month"]').val();
    	var year = $('select[name="year"]').val() == -1 ? '' : $('select[name="year"]').val();
    	var dateofbirth = day + "/" + month + "/" + year; 
    	$('input[name="birthdate"]').val(dateofbirth);
    });

    var onSubmit = function(e) {
    	 var reg = /^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$/g;
    	 var dateStr = $('input[name="birthdate"]').val();
    	 if (dateStr.length > 0 && !reg.test(dateStr)) {
    	 	// alert('wrong');
    	 	return false;
    	 } else {
    	 	$('#subbtn').trigger('click');
    	 	// $(e.target).parent().submit();
    	 }
    };
</script>
<%@ include file="footer.jsp"%>