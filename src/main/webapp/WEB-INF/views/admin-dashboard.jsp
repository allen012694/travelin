<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<div class='row mt'>
	<div class='col-lg-12'>
		<div class="row mtbox">
                  		<div class="col-md-2 col-sm-2 col-md-offset-1 box0">
                  		
                  			<div class="box1">
					  			<span class="fa fa-user"></span>
					  			<h3>${accounts}</h3>
                  			</div>
					  			<p>${accounts} tài khoản đã được đăng ký sử dụng.</p>
                  		</div></a>
                  		<div class="col-md-2 col-sm-2 box0">
                  			<div class="box1">
					  			<span class="fa fa-map"></span>
					  			<h3>${areas}</h3>
                  			</div>
					  			<p>Hỗ trợ tất cả ${areas} tỉnh thành trên khắp cả nước.</p>
                  		</div></a>
                  		<div class="col-md-2 col-sm-2 box0">
                  			<div class="box1">
					  			<span class="fa fa-newspaper-o"></span>
					  			<h3>${articles}</h3>
                  			</div>
					  			<p>Có tới tận ${articles} bài viết giúp bạn biết mọi điều cần thiết.</p>
                  		</div></a>
                  		<div class="col-md-2 col-sm-2 box0">
                  			<div class="box1">
					  			<span class="fa fa-location-arrow"></span>
					  			<h3>${places}</h3>
                  			</div>
					  			<p>Cung cấp chi tiết ${places} địa điểm đủ loại.</p>
                  		</div></a>
                  		
                  		<div class="col-md-2 col-sm-2 box0">
                  			<div class="box1">
					  			<span class="fa fa-cab"></span>
					  			<h3>${journals}</h3>
                  			</div>
					  			<p>${journals} chuyến đi - ${journals} trải nghiệm thú vị .</p>
                  		</div></a>
                  	
                  	</div><!-- /row mt -->	
                  	<c:if test="${currentAccount.role > 1}">
                  	<div class='row mt'>
                  		<div class='col-lg-12'>
                  			<div class='content-panel'>
                  				<h4>
                  					<i class='fa fa-comments'></i> Danh sách góp ý chưa được duyệt
                  				</h4>

                  				<section id='unseen'>
                  					<table class='table table-bordered table-striped table-condensed' id="datatable1">
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
          </c:if>
          <div class='row mt'>
          	<div class='col-lg-12'>
          		<div class='content-panel'>
          			<h4>
          				<i class='fa fa-comments'></i> Danh sách địa điểm tạm thời đang sử dụng
          			</h4>

          			<section id='unseen'>
          				<table class='table table-bordered table-striped table-condensed' id="datatable2">
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
          					<tbody id="tempplacelist">
          						<c:if test="${not empty tempplaces }">
          						<c:forEach items="${tempplaces }" var="place">
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

          						<td>${place.createdaccount.username}</td>

          						<td data-id="${place.datastatus}">
          							<c:choose>
          							<c:when test="${place.datastatus==0}">Chờ duyệt</c:when>
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
	</div>
</div>


	
<script type="text/javascript" language="javascript">
$(document).ready(function(){
    $("#datatable1").DataTable();
    $("#datatable2").DataTable();
    $.contextMenu({
        selector: '#feedbacklist tr',
        build: function($trigger, e){return{
            items: {
    			item1: {
    		            name: "Xóa",
    		        	 visible: function(){ 
    		                if(-1 == $($trigger[0].children[4]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/feedbacks/del",
    							type : "POST",
    							data : {
    								"fid" : $trigger.attr("data-id")
    							},
    						}).success(function() {
    						    $trigger.remove();
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã xóa"); */
    						    // $($trigger[0].children[4]).attr("data-id", -1);
    						    // $($trigger[0].children[4]).text("Đã xóa")
    						});
    		            }
    	       		},
    	     //   		item2: {
    		    //         name: function(){
    		    //             if(-1 == $($trigger[0].children[4]).attr("data-id"))
    		    //           return "Khôi phục";
    		    //             else
    				  //             return "Đánh dấu chưa duyệt";
    		    //         },
    		    //         visible: function(key, opt){ 
    		    //             if(1 == $($trigger[0].children[4]).attr("data-id"))
    		    //                 return false; 
    		    //             else return true;
    		    //             },
    		    //         callback: function(key, opt){
    		                
    						// $.ajax({
    						// 	url : "/travelin/feedbacks/unverify",
    						// 	type : "POST",
    						// 	data : {
    						// 		"fid" : $trigger.attr("id")
    						// 	},
    						// }).success(function() {
    						// 	/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã vô hiệu hóa"); */
    						// 	$($trigger[0].children[4]).attr("data-id", 1);
    						//     $($trigger[0].children[4]).text("Chưa duyệt")
    						// });
    		    //         }
    	     //   		},
    	       		item2: {
    	       		 name: "Duyệt",
    		            visible: function(key, opt){ 
    		                if(2 == $($trigger[0].children[4]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/feedbacks/verify",
    							type : "POST",
    							data : {
    								"fid" : $trigger.attr("id")
    							},
    						}).success(function() {
    						    
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đang hoạt động"); */
    							// $($trigger[0].children[4]).attr("data-id", 2);
    						 //    $($trigger[0].children[4]).text("Đã duyệt")
    						 	$trigger.remove();
    						});
    		            }
    	       		},
       		}
        }}
    	
    }); 
     $.contextMenu({
        selector: '#tempplacelist tr',
        build: function($trigger, e){return{
            items: {
    			// item1: {
    		 //            name: "Xóa",
    		 //        	 visible: function(){ 
    		 //                if(-1 == $($trigger[0].children[4]).attr("data-id"))
    		 //                return false; 
    		 //                else return true;
    		 //                },
    		 //            callback: function(key, opt){
    		                
    			// 			$.ajax({
    			// 				url : "/travelin/feedbacks/del",
    			// 				type : "POST",
    			// 				data : {
    			// 					"fid" : $trigger.attr("id")
    			// 				},
    			// 			}).success(function() {
    						    
    			// 				/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã xóa"); */
    			// 			    $($trigger[0].children[4]).attr("data-id", -1);
    			// 			    $($trigger[0].children[4]).text("Đã xóa")
    			// 			});
    		 //            }
    	  //      		},
    	     //   		item2: {
    		    //         name: function(){
    		    //             if(-1 == $($trigger[0].children[4]).attr("data-id"))
    		    //           return "Khôi phục";
    		    //             else
    				  //             return "Đánh dấu chưa duyệt";
    		    //         },
    		    //         visible: function(key, opt){ 
    		    //             if(1 == $($trigger[0].children[4]).attr("data-id"))
    		    //                 return false; 
    		    //             else return true;
    		    //             },
    		    //         callback: function(key, opt){
    		                
    						// $.ajax({
    						// 	url : "/travelin/feedbacks/unverify",
    						// 	type : "POST",
    						// 	data : {
    						// 		"fid" : $trigger.attr("id")
    						// 	},
    						// }).success(function() {
    						// 	/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã vô hiệu hóa"); */
    						// 	$($trigger[0].children[4]).attr("data-id", 1);
    						//     $($trigger[0].children[4]).text("Chưa duyệt")
    						// });
    		    //         }
    	     //   		},
    	       		item1: {
    	       		 name: "Duyệt",
    		            visible: function(key, opt){ 
    		                if(2 == $($trigger[0].children[4]).attr("data-id"))
    		                return false; 
    		                else return true;
    		                },
    		            callback: function(key, opt){
    		                
    						$.ajax({
    							url : "/travelin/places/verify",
    							type : "POST",
    							data : {
    								"pid" : $trigger.attr("data-id"),
                    "kid" : $('#ijklmn').text()
    							},
    						}).success(function() {
    						    $trigger.remove();
    							/* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đang hoạt động"); */
    							// $($trigger[0].children[4]).attr("data-id", 2);
    						 //    $($trigger[0].children[4]).text("Đã duyệt")
    						});
    		            }
    	       		},
       		}
        }}
    	
    }); 
});
</script>