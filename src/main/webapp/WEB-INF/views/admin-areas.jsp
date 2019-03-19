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
				<i class='fa fa-map'></i> Danh sách khu vực
			</h4>
			<div class='col-lg-2' style="padding-bottom: 10px; float: right">
				<input type="button" class="btn btn-default"
					onclick="javascript:createArea()" value="+ Tạo khu vực mới">
				</button>
			</div>
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed' id="datatable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Tên</th>
							<th>Thuộc khu vực</th>
							<th>Ngày tạo</th>
							<th>Ngày sửa</th>
							<th>Người tạo</th>
							<th>Người sửa</th>
							<th>Trạng thái</th>
							<th>Ưu tiên</th>
						</tr>
					</thead>
					<tbody id="arealist">
						<c:if test="${not empty areas }">
							<c:forEach items="${areas }" var="area">
								<tr onclick="javascript:getArea(${area.id })" id="${area.id }">
									<td>${area.id }</td>
									<td>${area.name}</td>
									<td>${area.parentarea.name}</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${area.createddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${area.updateddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>${area.createdaccount.username}</td>
									<td>${area.updatedaccount.username}</td>
									<td data-id="${area.datastatus}"><c:choose>
											<c:when test="${area.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${area.datastatus==0}">Chưa duyệt</c:when>
											<c:when test="${area.datastatus==1}">Đang hoạt động</c:when>
											<c:otherwise></c:otherwise>
										</c:choose></td>
									<td>${area.priority}</td>
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
        selector: '#arealist tr',
        build: function($trigger, e){return{
            items: {
    			item1: {
    		            name: "Xóa",
    		        	 visible: function(){ 
    		                if(-1 == $($trigger[0].children[7]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/areas/del",
    							type : "POST",
    							data : {
    								"id" : $trigger.attr("id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã xóa"); */
    						    $($trigger[0].children[7]).attr("data-id", -1);
    						    $($trigger[0].children[7]).text("Đã xóa");
    						});
    		            }
    	       		},
    	       		item2: {
    		            name: "Đánh dấu chưa duyệt",
    		            visible: function(key, opt){ 
    		                if(0 == $($trigger[0].children[7]).attr("data-id"))
    		                    return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/areas/unverify",
    							type : "POST",
    							data : {
    								"id" : $trigger.attr("id")
    							},
    						}).success(function() {
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã vô hiệu hóa"); */
    						    $($trigger[0].children[7]).attr("data-id", 0);
    						    $($trigger[0].children[7]).text("Chưa duyệt");
    						});
    		            }
    	       		},
    	       		item3: {
    		            name: function(){
    		                if(-1 == $($trigger[0].children[7]).attr("data-id"))
    		              return "Khôi phục";
    		                else
    				              return "Duyệt";
    		            },
    		            visible: function(key, opt){ 
    		                if(1 == $($trigger[0].children[7]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/areas/verify",
    							type : "POST",
    							data : {
    								"id" : $trigger.attr("id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đang hoạt động"); */
    						    $($trigger[0].children[7]).attr("data-id", 1);
    						    $($trigger[0].children[7]).text("Đang hoạt động");
    						});
    		            }
    	       		},
       		}
        }}
    	
    }); 
});
	function getArea(id){
	    
	    // $("#main-content .wrapper").load("admin/areas/update?id="+id);
        window.location.href="/travelin/admin/areas?a=update&t="+id;

	}
    function createArea(){
        window.location.href="/travelin/admin/areas?a=new";	    
	    // $("#main-content .wrapper").load("admin/areas/new");
	}
</script>
