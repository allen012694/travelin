<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<c:if test="${curArea!=null}">
		<form:form action="/travelin/updateArea" method="POST" modelAttribute="curArea" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			
		Tên khu vực: <form:input path="name" value="${curArea.name }" />
			<br>
		Ảnh bìa: <input type="file" name="image" value="${curArea.id}.jpg" />
			<br>
		Tỉnh thành: <select name="city"></select> (chọn nếu khu vực là quận/huyện)<br>
		Nội dung: <form:textarea path="description" value="${curArea.description }" id="description" />
			<br>
			<form:input path="id" type="hidden" value="${curArea.id}" />
			<input type="submit" value="Lưu cập nhật">
		</form:form>
	</c:if>
	<c:if test="${newArea!=null}">
		<form:form action="/travelin/areas/new" method="POST" modelAttribute="newArea" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			Tên khu vực: <form:input path="name" />
			<br>
			Ảnh bìa: <input type="file" name="image">
			<br>
			Tỉnh thành: <select name="city"></select> (chọn nếu khu vực là quận/huyện)<br>
			Nội dung: <form:textarea path="description" id="description" />
			<br>
			<input type="submit" value="Tạo khu vực">
		</form:form>
	</c:if>
	
	<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>" language="javascript"></script>
	<script type="text/javascript" language="javascript">
		var ckedit = CKEDITOR.replace('description', {
			autoParagraph : false,
			resize_enabled : true,
			skin: 'minimalist',
			height : 250 + 'px',
			enterMode : CKEDITOR.ENTER_BR,
			shiftEnterMode : CKEDITOR.ENTER_P,
			toolbar : [ [ 'Source', 'NewPage', 'Preview', '-', 'Templates', '-' ,
					 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord',
							'-', 'Undo', 'Redo' ,'-' ,
					 'Bold', 'Italic', 'Underline', 'Strike', '-',
							'RemoveFormat' ,'-' ,
					 'Maximize' ,'-',
					 'JustifyLeft', 'JustifyCenter', 'JustifyRight', '-',
							'JustifyBlock', '-',
					 'NumberedList', 'BulletedList', 'Indent', 'Outdent', '-',
							'Table', 'Blockquote', 'CreateDiv' ,'-',
					 'base64image', 'Link', 'Iframe', 'EqnEditor',
							'-', 'TextColor', 'BGColor', 'HorizontalRule' ,
					 'Font', 'FontSize' ] ]
			});
	</script>
</body>
</html>