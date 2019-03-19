<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("currentYear", java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Hồ sơ" name="headtitle" />
</jsp:include>


<div id="profilecontainer">

	<div class="w3-col " style="width: 24%; margin-right: 1%">
		<div class="panel">
			<div class="media media-photo-block">
				<div>
				<c:if test="${currentAccount.id == accountProfile.id}">
					<button type="button" onclick="$('#file-avatar').trigger('click');" style="position: absolute; top: 300px;"><i class="fa fa-pencil"></i></button>
				</c:if>
				<img src="<c:url value="/resources/images/accounts/${accountProfile.id}/avatar.jpg"/>" style="width: 100%; height: 220px;" class="img-responsive">
				<c:if test="${currentAccount.id == accountProfile.id}">
					<form action="/travelin/changeavatar" method="POST" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
						<input type="file" name="image" style="display:none;" id="file-avatar">
						<input type="submit" name="action" style="display: none;">
					</form>
				</c:if>
				</div>
			</div>
			<div class="panel-body">
				<h2 class="text-center" style="margin-top: 0;">${accountProfile.username}</h2>
				<ul class="list-unstyled text-center text-bold"
					style="margin-bottom: 0;">
					<!-- <li><a href="/travelin/profile?k=${accountProfile.id}" class="link-styled">Xem hồ sơ</a></li> -->
					<c:if test="${currentAccount.email != null && currentAccount.id != accountProfile.id}">
						<li><c:if test="${fs == null}">
								<button class="w3-btn w3-red" onclick="sendFriendReq(event)">Kết
									bạn</button>
							</c:if> <c:if test="${fs != null && fs.status == 0 }">
								<button class="w3-btn w3-white" disabled>Chờ xác nhận</button>
							</c:if> <c:if test="${fs != null && fs.status == 1 }">
								<button class="w3-btn w3-white" disabled>Bạn bè</button>
							</c:if></li>
						<input type="hidden" value="${accountProfile.id}" name="tarid">
						<li><a href="/travelin/message?t=${accountProfile.id}" class="w3-btn w3-red" >Gửi tin nhắn</a></li>
					</c:if>
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
				Hồ sơ người dùng
				<c:if test="${currentAccount.id == accountProfile.id}">
				<button id="changeProfile"
					style="border: none; background: transparent">
					<i class="fa fa-pencil"></i>
				</button>
				</c:if>
			</div>
			<div class="panel-body" id="profile">
				<div id="editprofile" style="display:none;">
					<form:form action="/travelin/up-prof" method="POST" modelAttribute="accountProfile" onkeypress="return event.keyCode != 13;">
						<div class="w3-row">
							<label class="w3-col l2">Email:</label> <span id="email"
								class="w3-input w3-col l10" style="border: none" type="text">${accountProfile.email }</span>
						</div>
						<div class="w3-row">
							<label class="w3-col l2">Tên đại diện:</label><span id="username"
								class="w3-input w3-col l10" style="border: none"
								type="text">${accountProfile.username }</span>
						</div>
						<div class="w3-row">
							<label class="w3-col l2">Tên:</label>
							<input type="text" name="firstname" class="w3-input w3-col l10" value="${accountProfile.firstname}">
						</div>
						<div class="w3-row">
							<label class="w3-col l2">Họ:</label>
							<input type="text" name="lastname" class="w3-input w3-col l10" value="${accountProfile.lastname}">
						</div>
						<div class="w3-row">
							<label class="w3-col l2">Giới tính:</label>
							<select class="w3-input w3-col l10" name="gender">
								<option value='0' <c:if test="${accountProfile.gender == 0}">selected</c:if>>Không xác định</option>
								<option value='1' <c:if test="${accountProfile.gender == 1}">selected</c:if>>Nam</option>
								<option value='2' <c:if test="${accountProfile.gender == 2}">selected</c:if>>Nữ</option>
							</select>
						</div>
						<div class="w3-row">
							<label class="w3-col l2">Ngày sinh:</label>
							<fmt:formatDate type="both" dateStyle="short" timeStyle="short" value="${accountProfile.birthdate }" pattern="dd/MM/yyyy" var="birthStr"/>
							<input name="birthdate" type="hidden" value="${birthStr}">
							<select class="w3-select w3-quarter" name="day">
							  	<option value="-1">-Ngày-</option>
								<c:forEach begin="1" end="31" step="1" varStatus="i">
									<option value="<fmt:formatNumber type="number" minIntegerDigits="2" value="${i.index }" />" <c:if test="${i.index == fn:split(birthStr,'/')[0]}">selected</c:if>>${i.index }</option>
								</c:forEach>
							</select>
							<select class="w3-select w3-quarter" name="month">
								<option value="-1">-Tháng-</option>
								<c:forEach begin="1" end="12" step="1" varStatus="i">
									<option value="<fmt:formatNumber type="number" minIntegerDigits="2" value="${i.index }" />" <c:if test="${i.index == fn:split(birthStr,'/')[1]}">selected</c:if>>${i.index }</option>
								</c:forEach>
							</select>
							<select class="w3-select w3-quarter" name="year">
								<option value="-1">-Năm-</option>
								<c:forEach begin="${currentYear - 100}" end="${currentYear}" step="1" varStatus="i">
									<option value="<fmt:formatNumber type="number" pattern="0000" value="${i.index }" />" <c:if test="${i.index == fn:split(birthStr,'/')[2]}">selected</c:if>>${i.index }</option>
								</c:forEach>
							</select>
						</div>
						<!-- <input class="w3-btn" id="changeProfileSubmit" type="submit" value="Thay đổi thông tin cá nhân"> -->
						<button type="button" class="w3-btn" onclick="onSubmit(event)">Thay đổi thông tin cá nhân</button>
					</form:form>
				</div>
				<div id="showprofile">
					<div class="w3-row">
						<label class="w3-col l2">Email:</label> <span id="email"
							class="w3-input w3-col l10" style="border: none" type="text">${accountProfile.email }</span>
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Tên đại diện:</label><span id="username"
							class="w3-input w3-col l10" style="border: none"
							type="text">${accountProfile.username }</span>
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Tên:</label><span id="firstname"
							class="w3-input w3-col l10" style="border: none"
							type="text">${accountProfile.firstname }</span>
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Họ:</label><span id="lastname"
							class="w3-input w3-col l10" style="border: none"
							type="text">${accountProfile.lastname }</span>
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Giới tính:</label><span id="gender"
							class="w3-input w3-col l10" style="border: none"
							type="text" data-value="${accountProfile.gender}">
								<c:choose>
									<c:when test="${accountProfile.gender==0}">Không xác định</c:when>
									<c:when test="${accountProfile.gender==1}">Nam</c:when>
									<c:when test="${accountProfile.gender==2}">Nữ</c:when>
									<c:otherwise></c:otherwise>
								</c:choose>
							</span>
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Ngày sinh:</label><span id="birthdate"
							class="switchToInput w3-input w3-col l10" style="border: none"
							type="text"><fmt:formatDate type="both" dateStyle="short"
											timeStyle="short" value="${accountProfile.birthdate }"
											pattern="dd/MM/yyyy"/></span>
					</div>
				</div>
				
			</div>
		</div>
		<c:if test="${currentAccount.id == accountProfile.id}">
		<div class="panel" id="passwordpanel" style="margin-top: 20px">
			<div class="panel-header">Mật khẩu</div>
			<div class="panel-body" id="profile">
				<div class="panel-message"></div>
				<form action="/travelin/changePassword" method="POST" autocomplete="off">
					<div class="w3-row">
						<label class="w3-col l2">Mật khẩu cũ:</label> <input
							class="w3-input w3-col l10" name="oldpassword" type="password" />
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Mật khẩu mới:</label> <input
							class="w3-input w3-col l10" id="newpassword" name="newpassword"
							type="password" />
					</div>
					<div class="w3-row">
						<label class="w3-col l2">Xác nhận:</label> <input
							class="w3-input w3-col l10" id="renewpassword"
							name="renewpassword" type="password" />
					</div>
					<input class="w3-btn" id="changePassword" type="submit"
						value="Thay đổi mật khẩu">
				</form>
			</div>
		</div>
		</c:if>
	</div>
</div>
<jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript">
    var sendFriendReq = function(e) {
        var btn = $(e.target);
        $.ajax({
            url : "/travelin/make-friend",
            type : "POST",
            data : {
                'targetAccountId' : $('input[name="tarid"]').val()
            },
            dataType : 'json'
        }).success(function(res) {
            if (res.statusCode == 2)
                alert('Đã kết bạn rồi');
            else if (res.statusCode == 1) {
                btn.parent().html('<button class="w3-btn w3-white" disabled>Chờ xác nhận</button>')
            } else {
                alert("Mã xác nhận không hợp lệ.");
            }
        }).fail(function() {
            alert("Thất bại");
        });
    };
    
    var switchToInput = function() {
        $('#showprofile').toggle();
        $('#editprofile').toggle();
    };

    var onSubmit = function(e) {
    	var reg = /^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$/g;
		 var dateStr = $('input[name="birthdate"]').val();
		 if (dateStr.length > 0 && !reg.test(dateStr)) {
    	 	// alert('wrong');
    	 	return false;
    	 } else {
		 	$(e.target).parent().submit();
		 }
    };

    $(document).ready(function() {
    	$(document).keypress(function(event) {
	        if (event.which == '13') {
	            event.preventDefault();
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

	    $("#changeProfile").on("click", switchToInput);
	    $("#changePassword").on("click", function(e) {
            if ($("#renewpassword").val() != $("#newpassword").val()) {
                e.preventDefault();
                $("#passwordpanel .panel-message").html("<h6 style='color: #d54859'>Mật khẩu xác nhận không trùng khớp !</h6>");
            }
        });
        $('#file-avatar').on('change', function(e) {
        	$(this).next().trigger('click');
        })
    });
    $("#renewpassword").blur(function() {
        if ($(this).val() != $("#newpassword").val()) {
            $("#renewmessage").html("<h6 style='color: #d54859'>Mật khẩu xác nhận không trùng khớp !</h6>");
        } else {
            $("#renewmessage").html("");
        }
    });

    
</script>