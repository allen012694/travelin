<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
		<thead>
			<tr>
				<th>Id</th>
				<th>Name</th>
				<th>Description</th>
				<th>Priority</th>
				<th></th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${not empty areas }">
				<c:forEach items="${areas }" var="area">
					<tr data-id="${area.id }">
						<td>${area.id }</td>
						<td><img style="width: 80px; height: 60px;" src="<c:url value="/resources/images/areas/${area.id }.jpg"  />" ></td>
						<td><a href="/travelin/areas/${area.id }">${area.name}</a></td>
						<td><a href="/travelin/areas/update?k=${area.id}">Edit</a></td>
						<td><button class="btn-delete">Delete</button></td>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
	</table>
	<a href="/travelin/areas/new">Create area</a>

	<script src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('.btn-delete').on('click', function() {
				var aId = $(this).parent().parent().attr('data-id');
				$.ajax({
					url : "/travelin/areas/del",
					type : "POST",
					data : {
						"id" : aId
					},
					// dataType : 'json',
				}).success(function() {
					$('tr[data-id="' + aId + '"]').remove();
				});
			})
		});
	</script>
</body>
</html>