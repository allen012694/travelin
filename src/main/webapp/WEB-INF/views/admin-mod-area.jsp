<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='form-panel'>
			<c:if test="${curArea!=null}">
				<form:form class="form-horizontal style-form"
					action="/travelin/areas/update" method="POST"
					modelAttribute="curArea" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Chỉnh sửa khu vực
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên khu
							vực: </label>
						<div class="col-sm-10">
							<form:input type="text" class="form-control" path="name" required="true" pattern=".{1,150}"/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ảnh bìa: </label>
						<div class="col-sm-10">
						<span style="float:left; width: 10%;; margin-right: 1%;"><img src="<c:url value="/resources/images/areas/${curArea.id}.jpg"/>" style="width: 100%;"></span>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<span class="btn btn-default btn-file"><span>Choose
										file</span><input type="file" name="image" onchange="previewFile(this)" /></span> <span
									class="fileinput-filename"></span><span class="fileinput-new">No
									file chosen</span> <span class="help-block">Choose a cover
									image</span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ưu tiên: </label>
						<div class="col-sm-10">
							<form:select path="priority">
								<form:option value="0">0</form:option>
								<form:option value="1">1</form:option>
								<form:option value="2">2</form:option>
								<form:option value="3">3</form:option>
								<form:option value="4">4</form:option>
								<form:option value="5">5</form:option>
							</form:select>
						</div>
					</div>
					<%--<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Thuộc tỉnh/tp: </label>
						<div class="col-sm-10">
							<form:select path="parentarea.id">
								<form:option value="-1">- Chọn tỉnh/tp -</form:option>
								<c:forEach items="${cities}" var="city">
									<form:option value="${city.id}">${city.name}</form:option>
								</c:forEach>
							</form:select>
						</div>
					</div>--%>

					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Mô tả: </label>
						<div class="col-sm-10">
							<form:textarea type="text" id="description" class="form-control"
								path="description"/>
						</div>
					</div>
					<form:input path="id" type="hidden" value="${curArea.id}" />
					<input type="hidden" name="curfunc" value="admin/areas"/>
					<input type="hidden" name="cururl" value="admin"/>
					<form:input type="hidden" path="createdaccount.id" />
					<input type="submit"class="btn btn-default" value="Lưu cập nhật">
				</form:form>
			</c:if>







			<c:if test="${newArea!=null}">
				<form:form class="form-horizontal style-form"
					action="/travelin/areas/new" method="POST" modelAttribute="newArea"
					enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Tạo khu vực mới
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên khu
							vực: </label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="name" required pattern=".{1,150}"/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ảnh bìa: </label>
						<div class="col-sm-10">
						<span style="float:left; width: 10%;; margin-right: 1%;"></span>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<span class="btn btn-default btn-file"><span>Choose file</span>
								<input type="file" name="image" onchange="previewFile(this)"/></span> 
								<span class="fileinput-filename"></span><span class="fileinput-new">No
									file chosen</span> <span class="help-block">Choose a cover
									image</span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ưu tiên: </label>
						<div class="col-sm-10">
							<form:select path="priority">
								<form:option value="0">0</form:option>
								<form:option value="1">1</form:option>
								<form:option value="2">2</form:option>
								<form:option value="3">3</form:option>
								<form:option value="4">4</form:option>
								<form:option value="5">5</form:option>
							</form:select>
						</div>
					</div>
					<%-- <div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Thuộc tỉnh/tp: </label>
						<div class="col-sm-10">
							<form:select path="parentarea.id">
								<form:option value="-1">- Chọn tỉnh/tp -</form:option>
								<c:forEach items="${cities}" var="city">
									<form:option value="${city.id}">${city.name}</form:option>
								</c:forEach>
							</form:select>					
						</div>
					</div> --%>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Mô tả: </label>
						<div class="col-sm-10">
							<form:textarea type="text" id="description" class="form-control"
								path="description"/>
						</div>
					</div>
					<input type="hidden" name="curfunc" value="admin/areas"/>
					<input type="hidden" name="cururl" value="admin"/>
					<input type="submit" class="btn btn-default" value="Tạo khu vực">
				</form:form>
			</c:if>
		</div>
	</div>
</div>
<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>"
	language="javascript"></script>
<script type="text/javascript" language="javascript">
	var previewFile = function(input) {
		var file = input.files;
		if (input.files.length >0 && input.files[0].type.match('image.*')) {
			var reader = new FileReader();
			reader.onload = function(e) {
				// $("#journalBlur").css("background-image", "url("+e.target.result+")");
				$(input).parent().parent().prev().html('<img src="'+e.target.result+'" style="width: 100%;">');
			}
			reader.readAsDataURL(input.files[0]);
		} else {
			input.files = [];
		}
	};
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
