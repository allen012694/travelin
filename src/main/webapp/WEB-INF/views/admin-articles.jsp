<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='content-panel'>
			<h4>
				<i class='fa fa-newspaper-o'></i> Danh sách bài viết
			</h4>
			<div class ='col-lg-2' style="padding-bottom: 10px;float:right">
			<input type="button" class="btn btn-default" onclick="javascript:createArticle()" value="+ Tạo bài viết mới"></button>
			</div>
			
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed' id="datatable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Tiêu Đề</th>
							<th>Ngày tạo</th>
							<th>Ngày sửa</th>
							<th>Tác giả</th>
							<th>Trạng thái</th>
							<!-- <th>Ưu tiên</th> -->
						</tr>
					</thead>
					<tbody id="articlelist">
					<c:if test="${not empty articles }">
							<c:forEach items="${articles }" var="article">
								<tr onclick="javascript:getArticle(${article.id })"  data-id="${article.id }">
									<td>${article.id }</td>
									<td>${article.title}</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${article.createddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${article.updateddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td data-id="${article.author.id}">${article.author.username}</td>
									<td data-id="${article.datastatus}">
										<c:choose>
											<c:when test="${article.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${article.datastatus==0}">Chưa kích hoạt</c:when>
											<c:when test="${article.datastatus==1}">Đang hoạt động</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>
									</td>
									<%--<td>${article.priority}</td>--%>
								</tr>
								
							</c:forEach>
						</c:if>
					</tbody>
				</table>
			</section>
	
		</div>
	</div>
</div>

<script type="text/javascript" language="javascript">
$(document).ready(function(){
    $("#datatable").DataTable(); 
    $.contextMenu( {
        selector: '#articlelist tr',
        build: function($trigger, e){return{
            items: {
    			item1: {
    		            name: "Xóa",
    		        	 visible: function(){ 
                            if ($('#ijklmn').attr('data-role') > 2) return true;
                            if ($($trigger[0].children[4]).attr('data-id') != $('#ijklmn').text()) return false;
    		                if(-1 == $($trigger[0].children[5]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/articles/del",
    							type : "POST",
    							data : {
    								"aid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[5]).text("Đã xóa"); */
    						    $($trigger[0].children[5]).attr("data-id", -1);
    						    $($trigger[0].children[5]).text("Đã xóa");
    						});
    		            }
    	       		},
    	     //   		item2: {
    		    //         name: "Đánh dấu chưa duyệt",
    		    //         visible: function(key, opt){ 
    		    //             if(0 == $($trigger[0].children[5]).attr("data-id"))
    		    //                 return false; 
    		    //             else return true;
    		    //             },
    		    //         callback: function(key, opt){
    		                
    						// $.ajax({
    						// 	url : "/travelin/articles/unverify",
    						// 	type : "POST",
    						// 	data : {
    						// 		"id" : $trigger.attr("id")
    						// 	},
    						// }).success(function() {
    						// 	/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[5]).text("Đã vô hiệu hóa"); */
    						//     $($trigger[0].children[5]).attr("data-id", 0);
    						//     $($trigger[0].children[5]).text("Chưa kích hoạt");
    						// });
    		    //         }
    	     //   		},
    	       		item3: {
    		            name: function(){
    		                if(-1 == $($trigger[0].children[5]).attr("data-id"))
    		              return "Khôi phục";
    		                else
    				              return "Duyệt";
    		            },
    		            visible: function(key, opt){ 
                            if ($('#ijklmn').attr('data-role') > 2) return true;
                            if ($($trigger[0].children[4]).attr('data-id') != $('#ijklmn').text()) return false;
    		                if(1 == $($trigger[0].children[5]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/articles/verify",
    							type : "POST",
    							data : {
    								"aid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[5]).text("Đang hoạt động"); */
    						    $($trigger[0].children[5]).attr("data-id", 1);
    						    $($trigger[0].children[5]).text("Đang hoạt động");
    						});
    		            }
    	       		},
       		}
        }}
    	
    }); 
});
	function getArticle(id){
	    
	    // $("#main-content .wrapper").load("admin/articles/update?id="+id);
        window.location.href="/travelin/admin/articles?a=update&t="+id;
	}
function createArticle(){
        window.location.href="/travelin/admin/articles?a=new";
	    
	    // $("#main-content .wrapper").load("admin/articles/new");
	}
</script>