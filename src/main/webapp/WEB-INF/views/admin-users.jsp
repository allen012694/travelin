<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='content-panel'>
			<h4>
				<i class='fa fa-user'></i> User List
			</h4>
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed'>
					<thead>
						<tr>
							<th>ID</th>
							<th>Email</th>
							<th>Mật khẩu</th>
							<th>Tên</th>
							<th>Họ</th>
							<th>Tên đăng nhập</th>
							<th>Ngày khởi tạo</th>
							<th>Chỉnh sửa cuối</th>
							<th>Trạng thái</th>
							<th>Quyền</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty accounts }">
							<c:forEach items="${accounts }" var="account">
								<tr data-id="${account.id }">
									<td>${account.id }</td>
									<td><a href="/travelin/places/${account.id }">${account.email}</a></td>
									<td>${account.password }</td>
									<td>${account.firstname }</td>
									<td>${account.lastname }</td>
									<td>${account.username }</td>
									<td>${account.createddate}</td>
									<td>${account.updateddate}</td>
									<td>
										<c:choose>
											<c:when test="${account.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${account.datastatus==0}">Chưa kích hoạt</c:when>
											<c:when test="${account.datastatus==1}">Đang hoạt động</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${account.role==0}">Thành viên</c:when>
											<c:when test="${account.role==1}">Cộng tác viên</c:when>
											<c:when test="${account.role==2}">Biên tập viên</c:when>
											<c:when test="${account.role==3}">Quản trị viên</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>
									</td>
									<%-- <td><a href="/travelin/places/update?id=${place.id}">Edit</a></td>
									<td><button class="btn-delete">Delete</button></td> --%>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
			</section>
		</div>
	</div>
</div>

