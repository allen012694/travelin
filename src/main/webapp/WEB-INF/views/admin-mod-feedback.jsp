<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='form-panel'>
			<c:if test="${curFb!=null}">
			<form:form class="form-horizontal style-form"
					action="/travelin/feedbacks/update" method="POST"
					modelAttribute="curFb" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			<h4 class="mb">
						<i class="fa fa-angle-right"></i> Nội dung góp ý
					</h4>
				<div class="form-group">
                              <label class="col-lg-2 col-sm-2 control-label">Nội dung</label>
                              <div class="col-lg-10">
                                  <p class="form-control-static">${curFb.content}</p>
                              </div>
                          </div>
                          <form:input path="id" type="hidden" />
                          <form:input path="account.id" type="hidden" />
                          <form:input path="updatedaccount.id" type="hidden" value="${currentAccount.id}"/>
                          <form:input path="content" type="hidden"/>
					<input type="hidden" name="curfunc" value="admin/feedbacks"/>
					<input type="hidden" name="cururl" value="admin"/>
					<input type="submit" class="btn btn-default" value="Duyệt góp ý">
                         </form:form>
			</c:if>
			
		</div>
	</div>
</div>
<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>"
	language="javascript"></script>
<script type="text/javascript" language="javascript">
</script>
</body>
</html>