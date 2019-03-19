<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/tageditor/jquery.tag-editor.css" />">
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='form-panel'>
			<c:if test="${newArt!=null}">
				<form:form action="/travelin/articles/new" method="POST" class="form-horizontal style-form"
					modelAttribute="newArt" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i>Thêm bài viết
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tiêu đề: </label>
						<div class="col-sm-10">
							<form:input type="text" class="form-control" path="title" required="true" pattern=".{1,255}"/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ảnh bìa: </label>
						<div class="col-sm-10">
							<span style="float:left; width: 10%;; margin-right: 1%;"></span>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<span class="btn btn-default btn-file"><span>Choose
										file</span> <input type="file" name="image" onchange="previewFile(this)"/></span> <span
									class="fileinput-filename"></span><span class="fileinput-new">No
									file chosen</span> <span class="help-block">Choose a cover
									image</span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Giới thiệu: </label>
						<div class="col-sm-10">
							<form:textarea type="text" class="form-control"
								path="description" maxlength="300" style="height:90px; resize:none;"/>
						</div>
					</div>
					<%--<div class="form-group">
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
					</div>--%>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tags: </label>
						<div class="col-sm-10">
							<input type="text" name="tags" id="tags" value="${curTags}" class="form-control" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Nội dung: </label>
						<div class="col-sm-10">
							<form:textarea type="text" id="contents" class="form-control"
								path="content"/>
						</div>
					</div>
					<input type="hidden" name="curfunc" value="admin/articles"/>
					<input type="hidden" name="cururl" value="admin"/>
					<input type="submit" class="btn btn-default" value="Tạo bài viết" />
				</form:form>
			</c:if>











			<c:if test="${curArt!=null}">
				<form:form class="form-horizontal style-form"
					action="/travelin/articles/update" method="POST"
					modelAttribute="curArt" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Chỉnh sửa bài viết
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tiêu đề: </label>
						<div class="col-sm-10">
							<c:if test="${curArt.author.id  == currentAccount.id || currentAccount.role > 2}">
								<form:input type="text" class="form-control" path="title" required="true" pattern=".{1,255}"/>
							</c:if>
							<c:if test="${curArt.author.id  != currentAccount.id && currentAccount.role <= 2}">
								${curArt.title}
							</c:if>
							
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ảnh bìa: </label>
						<div class="col-sm-10">
							<span style="float:left; width: 10%;; margin-right: 1%;"><img src="<c:url value="/resources/images/articles/${curArt.id}.jpg"/>" style="width: 100%;"></span>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<c:if test="${curArt.author.id  == currentAccount.id || currentAccount.role > 2}">
								<span class="btn btn-default btn-file"><span>Choose
										file</span><input type="file" name="image" onchange="previewFile(this)"/></span> <span
									class="fileinput-filename"></span><span class="fileinput-new">No
									file chosen</span> <span class="help-block">Choose a cover
									image</span>
								</c:if>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Giới thiệu: </label>
						<div class="col-sm-10">
							<c:if test="${curArt.author.id  == currentAccount.id || currentAccount.role > 2}">
								<form:textarea type="text" class="form-control" path="description" maxlength="300" style="height:90px; resize:none;"/>
							</c:if>
							<c:if test="${curArt.author.id != currentAccount.id && currentAccount.role <= 2}">
								${curArt.description}
							</c:if>
						</div>
					</div>
					<%--<div class="form-group">
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
					</div>--%>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tags: </label>
						<div class="col-sm-10">
							<c:if test="${curArt.author.id  == currentAccount.id || currentAccount.role > 2}">
								<input type="text" name="tags" id="tags" value ="${curTags}" class="form-control" />
							</c:if>
							<c:if test="${curArt.author.id  != currentAccount.id && currentAccount.role <= 2}">
								${curTags}
							</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Nội dung: </label>
						<div class="col-sm-10">
							<c:if test="${curArt.author.id  == currentAccount.id || currentAccount.role > 2}">
								<form:textarea type="text" id="contents" class="form-control" path="content"/>
							</c:if>
							<c:if test="${curArt.author.id  != currentAccount.id && currentAccount.role <= 2}">
								${curArt.content}
							</c:if>
						</div>
					</div>
					<form:input path="id" type="hidden" value="${curArt.id}" />
					<span id="authorid" style="display:none;">${curArt.author.id}</span>
					<c:if test="${curArt.author.id  == currentAccount.id || currentAccount.role > 2}">
						<form:input type="hidden" path="author.id" />
						<input type="hidden" name="curfunc" value="admin/articles"/>
						<input type="hidden" name="cururl" value="admin"/>
						<input type="submit" class="btn btn-default" value="Lưu cập nhật">
					</c:if>
				</form:form>
			</c:if>
		</div>
	</div>
</div>

<script src="<c:url value="/resources/libs/tageditor/jquery.tag-editor.min.js"/>" language="javascript"></script>
<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>" language="javascript"></script>
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
    $(document).ready(function() {
    	var curaccid = $('#ijklmn').text();
    	var createdaccid = $('#authorid').text();
    	if (createdaccid === undefined || curaccid == createdaccid || $('#ijklmn').attr('data-role') > 2) {
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
	            delimiter : ',; ',
	            placeholder : 'Gắn thẻ...',
	            forceLowercase : true,
	            removeDuplicates : true,
	            maxLength : 100,
	        };

	        if ($('input[name="id"]').length > 0) {
	            var tString = $('#tags').val();
	            tagProps.initialTags = tString.split(",");
	            // console.log(tString);
	            // console.log(tagProps.initialTags);
	        }

	        $('#tags').tagEditor(tagProps);
    	}
    });
</script>