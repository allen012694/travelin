<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:if test="${not empty places }">
					<c:forEach items="${places }" var="place">
						<a href="/travelin/places/${place.place.id}">
						<div class="block hidden" id="placesitem" style="border-radius: 6px;">
						<img style="border-radius: 6px 6px 0 0;" src="<c:url value="/resources/images/places/${place.place.id }/theme.jpg"  />"
									alt="${place.place.name }">
							<div class="w3-row" id="name">${place.place.name }</div>
							<div id="seperate"></div>
							<div class="w3-row" id="address">${place.place.address }</div>
							<div id="seperate"></div>

							<div class="w3-row" id="icons"><i class='fa fa-heart' style="color:#d54859"><span style="padding-left:10%">${place.favCount }</span></i><i class='fa fa-thumbs-o-up' style="color:#2e2e2e"><span style="padding-left:10%">${place.recommendCount }</span></i><i class='fa fa-thumbs-down' syle="color:#2e2e2e"><span style="padding-left:10%">${place.notRecommendCount }</span></i></div>

						</div>
						</a>
					</c:forEach>
				</c:if>

<script type="text/javascript">
var positioned = 0;
    
function positionBlocks() {
    isActive = true;
 	$('.hidden').each(function(){
 	   $(this).find("img").one("load", function() {
 	      // do stuff
 	      var min = Array.min(blocks);
 	 		
 	 		var index = $.inArray(min, blocks);
 	 		
 	 		//console.log("margin"+ index +":" + min);
 	 		var leftPos = $('#places').position().left+(index*(colWidth+margin));
 	 		//console.log("leftPos:" + leftPos);
 	 		$(this).parent().css({
 	 			'left':(leftPos+spaceLeft)+'px',
 	 			'top':min+$('#banner').position().top+$('#banner').height()+20+'px'
 	 		});
 	 		//console.log("left:" + $(this).position().left);
 	 		
 	 		blocks[index] = min+$(this).parent().height()+margin;
 	 		$(this).parent().removeClass("hidden");
 	 		botPos = Array.min(blocks);
 	 		
 	  }).error(function(){
 	     var min = Array.min(blocks);
	 		
	 		var index = $.inArray(min, blocks);
	 		
	 		//console.log("margin"+ index +":" + min);
	 		var leftPos = $('#places').position().left+(index*(colWidth+margin));
	 		//console.log("leftPos:" + leftPos);
	 		$(this).parent().css({
	 			'left':(leftPos+spaceLeft)+'px',
	 			'top':min+$('#banner').position().top+$('#banner').height()+20+'px'
	 		});
	 		//console.log("left:" + $(this).position().left);
	 		
	 		blocks[index] = min+$(this).parent().height()+margin;
	 		$(this).parent().removeClass("hidden");
	 		botPos = Array.min(blocks);
 	  })
 		
 		
 	   
 	  
 	   /* $('img', this).css({
 	      "max-width": "100%", "min-width": "100%","height": "auto"
 	   }) */
 	  positioned++;
 	  
 	  });
 	
 	if(positioned == 10) isActive = false;
 		
 	
 }
 
$(document).ready(function() {
    
    positionBlocks(); 
    
})
</script>


