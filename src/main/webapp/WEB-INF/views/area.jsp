<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="header.jsp" %>
		<div class="content">
			<div class="area">
				<div id="areaName">${curArea.name }</div>

				<div id="areaBody">
					<div id="areaImg">
						<center><img style="width: 70%; height: 70%;"
							src="<c:url value="/resources/images/areas/${curArea.id }.jpg"  />"
							alt="${curArea.name }"></center>
					</div>
					<div id="areaContent">${curArea.description }</div>
				</div>
				
			</div>
		</div>
<%@ include file="footer.jsp" %>
	<script type="text/javascript">
        $(document).ready(function() {
            $('.btn-update').hide();

            $('.btn-delete').on('click', function() {
                var aId = $(this).parent().parent().attr('data-id');
                $.ajax({
                    url : "/travelin/comments/del",
                    type : "POST",
                    data : {
                        "id" : aId
                    },
                    // dataType : 'json',
                }).success(function() {
                    $('tr[data-id="' + aId + '"]').remove();
                });
            });

            //*****************************8
            $('.btn-edit').on('click', function() {
                var p = $(this).parent().prev();
                var t = p.text().replace("\n", "").replace(/\s{2,}/g, "").trim();
                p.replaceWith("<td><textarea class='edit'>" + t + "</textarea></td>");
                $(this).hide();
                $(this).parent().next().find('.btn-delete').hide();
                $(this).parent().find('.btn-update').show();

                $('.btn-update').unbind().on('click', function() {
                    var btnedittd = $(this).parent();
                    var q = btnedittd.prev().find("textarea.edit").val();
                    var id = btnedittd.parent().attr("data-id");
                    $.ajax({
                        url : "/travelin/updateComment",
                        type : "POST",
                        contentType : 'application/json',
                        data : JSON.stringify({
                            id : id,
                            content : q
                        }),
                        dataType : 'json'
                    }).success(function(comment) {
                        btnedittd.prev().find("textarea.edit").replaceWith("<td class='contents'>" + comment.content + "</td>");
                        btnedittd.find('.btn-update').hide();
                        btnedittd.find('.btn-edit').show();
                        btnedittd.next().find('.btn-delete').show();

                    });
                });

            })
        });
   </script>

