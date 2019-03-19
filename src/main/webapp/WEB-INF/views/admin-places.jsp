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
				<i class='fa fa-location-arrow'></i> Danh sách địa điểm
			</h4>
			<div class ='col-lg-2' style="padding-bottom: 10px;float:right">
			<input type="button" class="btn btn-default" onclick="javascript:createPlace()" value="+ Tạo địa điểm mới"></button>
			</div>
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed' id="datatable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Tên</th>
							<th>Phân loại</th>
							<th>Khu vực</th>
							<th>Địa chỉ</th>
							<th>Ngày tạo</th>
							<th>Ngày sửa</th>
							<th>Người tạo</th>
							<th>Trạng thái</th>
							<!-- <th>Ưu tiên</th> -->
						</tr>
					</thead>
					<tbody id="placelist">
						<c:if test="${not empty places }">
							<c:forEach items="${places }" var="place">
								<tr onclick="javascript:getPlace(${place.id })"  data-id="${place.id }">
									<td>${place.id }</td>
									<td>${place.name}</td>
									<td>
										<c:choose>
											<c:when test="${place.type==1}">Ăn uống</c:when>
											<c:when test="${place.type==2}">Du lịch</c:when>
											<c:when test="${place.type==3}">Sức khỏe</c:when>
											<c:when test="${place.type==4}">Giải trí</c:when>
											<c:when test="${place.type==5}">Mua sắm</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>	
									</td>
									<td>${place.area.name }</td>
									<td>${place.address }</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${place.createddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${place.updateddate}"
												pattern="yyyy/MM/dd" />
									</td>
									
									<td data-id="${place.createdaccount.id}">${place.createdaccount.username}</td>
									
									<td data-id="${place.datastatus}">
										<c:choose>
											<c:when test="${place.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${place.datastatus==0}">Chưa kích hoạt</c:when>
											<c:when test="${place.datastatus==1}">Đang hoạt động</c:when>
											<c:otherwise></c:otherwise>
										</c:choose>
									</td>
									<%--<td>${place.priority}</td>--%>
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
        selector: '#placelist tr',
        build: function($trigger, e){return{
            items: {
    			item1: {
    		            name: "Xóa",
    		        	 visible: function(){ 
                            if ($('#ijklmn').attr('data-role') > 1) return true;
                            if ($($trigger[0].children[7]).attr('data-id') != $('#ijklmn').text()) return false;
    		                if(-1 == $($trigger[0].children[8]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/places/del",
    							type : "POST",
    							data : {
    								"pid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[9]).text("Đã xóa"); */
    						    $($trigger[0].children[8]).attr("data-id", -1);
                                $($trigger[0].children[8]).text("Đã xóa");
    						});
    		            }
    	       		},
    	       		item2: {
    		            name: "Đánh dấu chưa duyệt",
    		            visible: function(key, opt){ 
                            if ($('#ijklmn').attr('data-role') > 1) return true;
                            if ($($trigger[0].children[7]).attr('data-id') != $('#ijklmn').text()) return false;
    		                if(0 == $($trigger[0].children[8]).attr("data-id"))
    		                    return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/places/unverify",
    							type : "POST",
    							data : {
    								"pid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[9]).text("Đã vô hiệu hóa"); */
    						    $($trigger[0].children[8]).attr("data-id", 0);
                                $($trigger[0].children[8]).text("Chưa kích hoạt");
    						});
    		            }
    	       		},
    	       		item3: {
    		            name: function(){
    		                if(-1 == $($trigger[0].children[8]).attr("data-id"))
    		              return "Khôi phục";
    		                else
    				              return "Duyệt";
    		            },
    		            visible: function(key, opt){ 
    		                if(1 == $($trigger[0].children[8]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt) {
    		                
    						$.ajax({
    							url : "/travelin/places/verify",
    							type : "POST",
    							data : {
    								"pid" : $trigger.attr("data-id"),
                                    "kid" : $('#ijklmn').text()
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[9]).text("Đang hoạt động"); */
    						    $($trigger[0].children[8]).attr("data-id", 1);
                                $($trigger[0].children[8]).text("Đang hoạt động");
    						});
    		            }
    	       		},
       		}
        }}
    	
    }); 
});
	function getPlace(id){
	    window.location.href="/travelin/admin/places?a=update&t="+id;
	    // $("#main-content .wrapper").load("admin/places/update?id="+id);
	}
function createPlace(){
	    window.location.href="/travelin/admin/places?a=new";	    
	    // $("#main-content .wrapper").load("admin/places/new");
	}
</script>


