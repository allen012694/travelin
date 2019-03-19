<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
<div class="w3-row" id="search">
			<form method="GET" action="/travelin/search">
				<input class="w3-input w3-border" id="search_input" type="text" placeholder="Nhập tên một địa điểm" name="k" />
				<input type="submit" value="Search" style="display: none">
				<select  name ="aid" id="areaid" style="width:30%;margin-top:10px;margin-left:25%" class="chosen-select" >
				<option value="-1">Tất cả</option>
					<c:if test="${not empty cities}">
						<c:forEach items="${cities }" var="city">
							<option value="${city.id }">${city.name}</option>
						</c:forEach>
					</c:if>
				</select>
				</form>
			</div>
				
			<script type="text/javascript">
			$(document).ready(function() {

			    $('.chosen-select').chosen({
					
			        search_contains : true,
			        placeholder_text_single: "Chọn 1 tỉnh thành",
			    });

			    var xhr;
			    $('input[name="k"]').autoComplete({
			        minChars:3,
			        cache: false,
			        source: function(term, suggest){
				        try { xhr.abort(); } catch(e){}
				       	xhr = $.ajax({
				        	type: 'POST',
				        	url:'/travelin/autocomplete',
				        	data: {
				        		'k': term,
				        		'aid': $('#areaid').val()
				        	},
				        	dataType: 'JSON',
				        	success: function(data) {
				        		data[0].unshift("places");
				        		data[1].unshift("articles");
				        		data[2].unshift("journals");
				        		data[3].unshift("accounts");
				        		suggest(data); 
				        	}
				        });
				    },
				        renderItem: function (item, search){
				            var sum = '';
				            if (item[0] === "places") {
				            	sum+= "<div style='padding: 5px 0.5%;font-weight:bold;'>  Địa Điểm   </div>";
				            	for (var i = 1; i < item.length; i++) {
				            		sum += '<div class="autocomplete-suggestion" style="cursor:pointer" skey="'+search+'" data-id="'+item[i].id+'" data-type="places"><img style ="float:left;margin-top:5px; margin-right:5px;" width="35" height="35" src="resources/images/places/'
				            				+item[i].id+'/theme.jpg "><span style="font-weight: 550">'+item[i].name+'</span></br><span style="color: gray">'+ item[i].address+'</span></div>';
				            	}
				            } else if (item[0] === "articles") {
				            		sum+= "<div style='padding: 5px 0.5%;font-weight:bold;'> Bài Viết </div> ";
				            		for (var i = 1; i < item.length; i++) {
				            			sum += '<div class="autocomplete-suggestion"  style="cursor:pointer" skey="'+search+'" data-id="'+item[i].id+'" data-type="articles"> <img style="float:left;margin-top:5px; margin-right:5px;" width="35" height="35" src="resources/images/articles/'
				            				+item[i].id+'.jpg "><span>'+item[i].title+'</span></div>';
				            		}

				            }
				            
				            else if (item[0] === "journals") {
			            		sum+= "<div style='padding: 5px 0.5%;font-weight:bold;'> Chuyến Đi </div> ";
			            		for (var i = 1; i < item.length; i++) {
			            			sum+= '<div class="autocomplete-suggestion"  style="cursor:pointer" skey="'+search+'" data-id="'+item[i].id+'" data-type="journals"> <img style ="float:left;margin-top:5px; margin-right:5px;" width="35" height="35" src="resources/images/journals/'
			            				+item[i].id+'/theme.jpg "><span>'+item[i].title+'</span></div>';
			            		}
				            }
				            
				            else if (item[0] === "accounts") {
			            		sum+= "<div style='padding: 5px 0.5%;font-weight: bold;'> Thành Viên </div> ";
			            		for (var i = 1; i < item.length; i++) {
			            			sum+= '<div class="autocomplete-suggestion"  style="cursor:pointer" skey="'+search+'" data-id="'+item[i].id+'" data-type="accounts"> <img class="circled" style ="float:left;margin-top:5px; margin-right:5px;" width="35" height="35" src="/travelin/resources/images/accounts/'
			            				+item[i].id+'/avatar.jpg "><span>'+item[i].username+'</span></div>';
			            		}
				            }

				           
				                       // return '<div class="autocomplete-suggestion"  skey="'+search+'" data-id="'+item.id+'"><img style =" width: 32px;height : 32px;" src="resources/images/places/'
				            // +item.id+'.jpg ">'+item.name+'</br> <span style="color: gray">'+ item.address+'</span></div>';
				            return sum;
				        },
				        onSelect: function(e, search, item){
				            
				           if ($(item).attr('data-type') === "places") {
				               window.location.href = "/travelin/places/"+$(item).attr("data-id")+"";
			                
			            } else if($(item).attr('data-type') === "articles"){
			                window.location.href = "/travelin/articles/"+$(item).attr("data-id")+"";
			            }	
			            else if($(item).attr('data-type') === "journals"){
			                window.location.href = "/travelin/journals/"+$(item).attr("data-id")+"";
			            }	
			            else if($(item).attr('data-type') === "accounts"){
			                window.location.href = "/travelin/profile?k="+$(item).attr("data-id")+"";
			            }
		            
		            
		           
			           
			         }
			    });
			});
			
			</script>