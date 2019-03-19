<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<div class='row mt'>
	<div class='col-lg-12'>
		<div class='content-panel'>
			<h4>
				<i class='fa fa-user'></i> Danh sách tài khoản
			</h4>
			<div class='col-lg-2' style="padding-bottom: 10px; float: right">
				<input type="button" class="btn btn-default" onclick="javascript:createAccount()" value="+ Tạo tài khoản mới">
			</div>
			<section id='unseen'>
				<table class='table table-bordered table-striped table-condensed' id="datatable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Email</th>
							<th>Tên</th>
							<th>Họ</th>
							<th>Tên đại diện</th>
							<th>Ngày tạo</th>
							<th>Ngày sửa</th>
							<th>Trạng thái</th>
							<th>Quyền</th>
						</tr>
					</thead>
					<tbody id="accountlist">
						<c:if test="${not empty accounts }">
							<c:forEach items="${accounts }" var="account">
								<tr onclick="javascript:getAccount(${account.id })"
									id="${account.id }">
									<td>${account.id }</td>
									<td>${account.email}</td>
									<td>${account.firstname }</td>
									<td>${account.lastname }</td>
									<td>${account.username }</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${account.createddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td>
									<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${account.updateddate}"
												pattern="yyyy/MM/dd" />
									</td>
									<td data-id="${account.datastatus}"><c:choose>
											<c:when test="${account.datastatus==-1}">Đã xóa</c:when>
											<c:when test="${account.datastatus==0}">Chưa kích hoạt</c:when>
											<c:when test="${account.datastatus==1}">Đang hoạt động</c:when>
											<c:when test="${account.datastatus==2}">Đã vô hiệu hóa</c:when>
											<c:otherwise></c:otherwise>
										</c:choose></td>
									<td data-id="${account.role}"><c:choose>
											<c:when test="${account.role==0}">Người dùng</c:when>
											<c:when test="${account.role==1}">Cộng tác viên</c:when>
											<c:when test="${account.role==2}">Biên tập viên</c:when>
											<c:when test="${account.role==3}">Quản trị viên</c:when>
											<c:otherwise></c:otherwise>
										</c:choose></td>
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
        // Datastatus of Account: -1 deleted, 0: inactive, 1 active, 2 banned
        selector: '#accountlist tr',
        build: function($trigger, e){return $($trigger[0].children[8]).attr('data-id') != 3 ? {
            items: {
                item1: {
                    name: "Vô hiệu hóa",
                    visible: function(key, opt){ 
                        if ($($trigger[0].children[8]).attr('data-id') == 3) return false;
                        if(2 == $($trigger[0].children[7]).attr("data-id")) return false; 
                        return true;
                        },
                    callback: function(key, opt){
                        
                        $.ajax({
                            url : "/travelin/accounts/deactivate",
                            type : "POST",
                            data : {
                                "id" : $trigger.attr("id")
                            },
                        }).success(function() {
                            /* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã vô hiệu hóa"); */
                            // $("#main-content .wrapper").load("admin/accounts");
                           $($trigger[0].children[7]).attr("data-id", 2);
                           $($trigger[0].children[7]).text("Đã vô hiệu hóa"); 
                        });
                    }
                },
                item2: {
                    name: function() {
                        if(-1 == $($trigger[0].children[7]).attr("data-id")) return "Khôi phục";
                        return "Kích hoạt";
                    },
                    visible: function(key, opt){ 
                        if ($($trigger[0].children[8]).attr('data-id') == 3) return false;
                        if(1 == $($trigger[0].children[7]).attr("data-id")) return false; 
                        return true;
                        },
                    callback: function(key, opt){
                        
                        $.ajax({
                            url : "/travelin/accounts/activate",
                            type : "POST",
                            data : {
                                "id" : $trigger.attr("id")
                            },
                        }).success(function() {
                            
                            /* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đang hoạt động"); */
                            // $("#main-content .wrapper").load("admin/accounts");
                            $($trigger[0].children[7]).attr("data-id", 1);
                           $($trigger[0].children[7]).text("Đang hoạt động");
                        });
                    }
                },
                item3: {
                    name: "Xóa",
                    visible: function(key, opt){ 
                        if ($($trigger[0].children[8]).attr('data-id') == 3) return false;
                        if(-1 == $($trigger[0].children[7]).attr("data-id")) return false; 
                        return true;
                        },
                    callback: function(key, opt){
                        
                        $.ajax({
                            url : "/travelin/accounts/del",
                            type : "POST",
                            data : {
                                "id" : $trigger.attr("id")
                            },
                        }).success(function() {
                            
                            /* $($('tr[id="' + opt.$trigger.attr("id") + '"] td')[7]).text("Đã xóa"); */
                            // $("#main-content .wrapper").load("admin/accounts");
                            $($trigger[0].children[7]).attr("data-id", -1);
                           $($trigger[0].children[7]).text("Đã xóa");
                        });
                    }
                },
       		}
        } : false;
    }
    }); 
});
	function getAccount(id){
	    
	    // $("#main-content .wrapper").load("admin/accounts/update?id="+id);
        window.location.href="/travelin/admin/accounts?a=update&t="+id;
	}
function createAccount(){
	    
	    // $("#main-content .wrapper").load("admin/accounts/new");
        window.location.href="/travelin/admin/accounts?a=new";
	}
</script>
