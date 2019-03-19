<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("currentYear", java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/tageditor/jquery.tag-editor.css" />">
	
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='form-panel'>
			<c:if test="${curAcc!=null}">
				<form:form class="form-horizontal style-form" action="/travelin/accounts/update" method="POST" modelAttribute="curAcc" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Chỉnh sửa tài khoản
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Email: </label>
						<div class="col-sm-10">
							<span>${curAcc.email}</span>
						</div>
					</div>
					
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên đại diện: </label>
						<div class="col-sm-10">
							<span>${curAcc.username}</span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên: </label>
						<div class="col-sm-10">
							<span>${curAcc.firstname}</span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Họ: </label>
						<div class="col-sm-10">
							<span>${curAcc.lastname}</span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Giới tính: </label>
						<div class="col-sm-10">
							<c:choose>
								<c:when test="${currentAccount.gender==0}">Không xác định</c:when>
								<c:when test="${currentAccount.gender==1}">Nam</c:when>
								<c:when test="${currentAccount.gender==2}">Nữ</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
							</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ngày sinh: </label>
						<div class="col-sm-10">
							<span><fmt:formatDate type="both" dateStyle="short"
											timeStyle="short" value="${currentAccount.birthdate }"
											pattern="dd/MM/yyyy"/></span>
						</div>
					</div>
					<c:if test="${currentAccount.role == 3 && curAcc.role != 3}">
						<div class="form-group">
							<label class="col-sm-2 col-sm-2 control-label">Quyền thành viên: </label>
							<div class="col-sm-2">
								<form:select class="form-control" path="role">
									<form:option value="0">Người dùng</form:option>
									<form:option value="1">Cộng tác viên</form:option>
									<form:option value="2">Biên tập viên</form:option>
									<form:option value="3">Quản trị viên</form:option>
								</form:select>
							</div>
						</div>
					<input type="submit" class="btn btn-default" value="Lưu cập nhật">
					</c:if>
					<c:if test="${curAcc.role == 3}">
						<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Quyền thành viên: </label>
						<div class="col-sm-10">Quản trị viên</div>
						</div>
					</c:if>
					<form:input path="id" type="hidden" value="${curAcc.id}" />
					<input type="hidden" name="curfunc" value="admin/accounts"/>
					<input type="hidden" name="cururl" value="admin"/>
					
				</form:form>
			</c:if>










			<c:if test="${newAcc!=null}">
				<form:form class="form-horizontal style-form" action="/travelin/accounts/new" method="POST" modelAttribute="newAcc" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Thêm tài khoản
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Email: </label>
						<div class="col-sm-10">
							<form:input class="form-control" type="email" path="email" required="true" />
								 <p>${errEmail}</p>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Mật khẩu: </label>
						<div class="col-sm-10">
							<form:input type="password" class="form-control" path="password" required="true" pattern=".{6,32}" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên đại diện: </label>
						<div class="col-sm-10">
							<form:input type="text" class="form-control" path="username" required="true" pattern="[a-zA-Z0-9 ]{4,50}" />
								 <p id="errUsername">${errUsername}</p>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên: </label>
						<div class="col-sm-10">
							<form:input type="text" class="form-control" path="firstname" pattern=".{1,32}" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Họ: </label>
						<div class="col-sm-10">
							<form:input type="text" class="form-control" path="lastname" pattern=".{1,32}" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Giới tính: </label>
						<div class="col-sm-10">
							<form:select class="w3-select w3-col l9" path="gender">
								<form:option value="0">Không xác định</form:option>
								<form:option value="1">Nam</form:option>
								<form:option value="2">Nữ</form:option>
							</form:select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ngày sinh: </label>
						<div class="col-sm-10">
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
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Quyền thành viên: </label>
						<div class="col-sm-2">
							<form:select path="role">
								<form:option value="0">Người dùng</form:option>
								<form:option value="1">Cộng tác viên</form:option>
								<form:option value="2">Biên tập viên</form:option>
								<form:option value="3">Quản trị viên</form:option>
							</form:select>
						</div>
					</div>
					<input type="hidden" name="curfunc" value="admin/accounts"/>
					<input type="hidden" name="cururl" value="admin"/>
					<button type="button" onclick="createAdminAcc(event)" class="btn btn-default">Tạo tài khoản</button>
					<input type="submit" id="caacc" style="display:none;" value="Tạo tài khoản">
				</form:form>

			</c:if>
		</div>
	</div>

</div>

<script
	src="<c:url value="/resources/libs/tageditor/jquery.tag-editor.min.js"/>"
	language="javascript"></script>

<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>"
	language="javascript"></script>
<script type="text/javascript">
	$(document).ready(function() {
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
	});
	var createAdminAcc = function(e) {
		var reg = /^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$/g;
		 var dateStr = $('input[name="birthdate"]').val();
		 if (dateStr.length > 0 && !reg.test(dateStr)) {
    	 	// alert('wrong');
    	 	return false;
    	 } else {
		 	$('#caacc').trigger('click');
		 }
	};
</script>