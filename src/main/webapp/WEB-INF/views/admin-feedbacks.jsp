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
				<i class='fa fa-comments'></i> Danh sách góp ý
			</h4>
		
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed' id="datatable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Người gửi</th>
							<th>Ngày tạo</th>
							<th>Ngày sửa</th>
							<th>Trạng thái</th>
						</tr>
					</thead>
					<tbody id="feedbacklist">
					<c:if test="${not empty feedbacks }">
							<c:forEach items="${feedbacks }" var="feedback">
								<tr onclick="javascript:getFeedback(${feedback.id })" data-id="${feedback.id }">
									<td>${feedback.id }</td>
									<td>${feedback.account.username}</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${feedback.createddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${feedback.updateddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td data-id="${feedback.datastatus}">
										<c:choose>
											<c:when test="${feedback.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${feedback.datastatus==1}">Chưa duyệt</c:when>
											<c:when test="${feedback.datastatus==2}">Đã duyệt</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>
									</td>
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
        selector: '#feedbacklist tr',
        build: function($trigger, e){return{
            items: {
                // feedback datastatus: -1 deleted, 1 active, 2 verified
    			item1: {
    		            name: "Xóa",
    		        	 visible: function(){ 
    		                if(-1 == $($trigger[0].children[4]).attr("data-id")) return false; 
    		                return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/feedbacks/del",
    							type : "POST",
    							data : {
    								"fid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã xóa"); */
    						    // $("#main-content .wrapper").load("admin/feedbacks");
                                $($trigger[0].children[4]).attr("data-id", -1);
                                $($trigger[0].children[4]).text("Đã xóa");
    						});
    		            }
    	       		},
    	       		item2: {
    		            name: function(){
    		                if(-1 == $($trigger[0].children[4]).attr("data-id"))
    		              return "Khôi phục";
    		                else
    				              return "Đánh dấu chưa duyệt";
    		            },
    		            visible: function(key, opt){ 
    		                if(1 == $($trigger[0].children[4]).attr("data-id")) return false; 
    		                return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/feedbacks/unverify",
    							type : "POST",
    							data : {
    								"fid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã vô hiệu hóa"); */
    							// $("#main-content .wrapper").load("admin/feedbacks");
                                $($trigger[0].children[4]).attr("data-id", 1);
                                $($trigger[0].children[4]).text("Chưa duyệt");
    						});
    		            }
    	       		},
    	       		item3: {
    	       		 name: "Duyệt",
    		            visible: function(key, opt){ 
    		                if(2 == $($trigger[0].children[4]).attr("data-id")) return false; 
    		                return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/feedbacks/verify",
    							type : "POST",
    							data : {
    								"fid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đang hoạt động"); */
    							$($trigger[0].children[4]).attr("data-id", 2);
                                $($trigger[0].children[4]).text("Đã duyệt");
    						});
    		            }
    	       		},
       		}
        }}
    	
    }); 

});
function getFeedback(id){
    
    // $("#main-content .wrapper").load("admin/feedbacks/update?id="+id);
    window.location.href="/travelin/admin/feedbacks?a=update&t="+id;
}
</script>