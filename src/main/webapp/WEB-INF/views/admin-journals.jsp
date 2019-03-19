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
				<i class='fa fa-newspaper-o'></i> Danh sách chuyến đi
			</h4>

			
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed' id="datatable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Tên chuyến đi</th>
							<th>Ngày tạo</th>
							<th>Ngày sửa</th>
							<th>Tác giả</th>
							<th>Trạng thái</th>
							<!-- <th>Ưu tiên</th> -->
						</tr>
					</thead>
					<tbody id="journallist">
					<c:if test="${not empty journals }">
							<c:forEach items="${journals }" var="journal">
								<tr onclick="javascript:getJournal(${journal.id })" data-id="${journal.id }">
									<td>${journal.id }</td>
									<td>${journal.title}</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short" timeStyle="short" value="${journal.createddate}" pattern="yyyy/MM/dd" />
									</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${journal.updateddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>${journal.author.username}</td>
									<td data-id="${journal.datastatus}">
										<c:choose>
											<c:when test="${journal.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${journal.datastatus==0}">Chưa kích hoạt</c:when>
											<c:when test="${journal.datastatus==1}">Đang hoạt động</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>
									</td>
									<!-- <td>${journal.priority}</td> -->
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
        selector: '#journallist tr',
        build: function($trigger, e){return{
            items: {
    			item1: {
    		            name: "Xóa",
    		        	 visible: function(){ 
    		                if(-1 == $($trigger[0].children[5]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/journals/del",
    							type : "POST",
    							data : {
    								"jid" : $trigger.attr("data-id")
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
    						// 	url : "/travelin/journals/unverify",
    						// 	type : "POST",
    						// 	data : {
    						// 		"id" : $trigger.attr("id")
    						// 	},
    						// }).success(function() {
    						// 	/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[5]).text("Đã vô hiệu hóa"); */
    						//     $($trigger[0].children[5]).attr("data-id", 0);
          //                       $($trigger[0].children[5]).text("Chưa kích hoạt");
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
    		                if(1 == $($trigger[0].children[5]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/journals/verify",
    							type : "POST",
    							data : {
    								"jid" : $trigger.attr("data-id")
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
function getJournal(id){
    window.location.href="/travelin/admin/journals?a=show&t="+id;
// window.location.href="/travelin/admin/areas?a=new";     
    // $("#main-content .wrapper").load("admin/journals/"+id);
}
</script>