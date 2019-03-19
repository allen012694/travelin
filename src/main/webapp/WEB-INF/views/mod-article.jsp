<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/tageditor/jquery.tag-editor.css" />">
</head>
<body>
	<c:if test="${curArt!=null}">
		<form:form action="/travelin/updateArticle" method="POST" modelAttribute="curArt" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			
		Tiêu đề: <form:input path="title" value="${curArt.title }" />
			<br>
		Ảnh bìa: <input type="file" name="image" value="${curArt.id}.jpg" />
			<br>
		Tags: <input type="text" name="tags" id="tags" value="${curTags}"/>
			<br>
		Nội dung: <form:textarea path="content" value="${curArt.content }" id="contents" />

			<br>
			<form:input path="id" type="hidden" value="${curArt.id}" />
			<input type="submit" value="Lưu cập nhật">
		</form:form>

	</c:if>
	<c:if test="${newArt!=null}">
		<form:form action="/travelin/articles/new" method="POST" modelAttribute="newArt" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			Tiêu đề: <form:input path="title" />
			<br>
			Ảnh bìa: <input type="file" name="image">
			<br>
			Tags: <input type="text" name="tags" id="tags"/>
			<br>
			Nội dung: <form:textarea path="content" id="contents" />
			<br>
			<input type="submit" value="Đăng bài viết">
		</form:form>

	</c:if>
	
	<script src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script src="<c:url value="/resources/libs/tageditor/jquery.tag-editor.min.js"/>" language="javascript"></script>
	<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>" language="javascript"></script>
	<script type="text/javascript" language="javascript">
		$(document).ready(function() {
			var ckedit = CKEDITOR.replace('contents', {
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

			var tagProps = {
				delimiter: ',; ',
				placeholder: 'Gắn thẻ...',
				forceLowercase: true,
				removeDuplicates: true,
				maxLength: 100,
			};

			if ($('input[name="id"]').val() !== undefined) {
				var tString = $('#tags').val();
				tagProps.initialTags = tString.split(",");
				// console.log(tString);
				// console.log(tagProps.initialTags);
			}
			
			$('#tags').tagEditor(tagProps);		
		});
		
	</script>
</body>
</html>