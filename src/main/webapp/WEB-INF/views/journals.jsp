<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- <%@ include file="header.jsp" %> --%>
<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Chuyến đi" name="headtitle" />
</jsp:include>
</head>
<body style="overflow-y: scroll;">
	<input type="hidden" id="maxPage" value="${count }" />
	
    <div class="content"
		style="-webkit-box-shadow: none;
	-moz-box-shadow: none;
	-o-box-shadow: none;
	box-shadow: none;width:100%;margin-left:0px;margin-right:0">
		<div class="w3-row scroll" id="journals">
			<div id="banner">DANH SÁCH CHUYẾN ĐI</div>
			<div id="journalsblocks">
				<div id="blockend"></div>
			</div>
		</div>

	</div>
    




	<script
		src="<c:url value="/resources/libs/esimakin-twbs-pagination/jquery.twbsPagination.js" />"></script>
	<script
		src="<c:url value="/resources/libs/admin/js/bootstrap.min.js" />"></script>
	<%-- <%@ include file="footer.jsp"% --%>

	<script
		src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script type="text/javascript">
        var curPage = 0;
        var isActive = false;

        function loadMoreContent() {

            var r = $.Deferred();

            $.get('/travelin/journalsbypage?page=' + (curPage + 1), function(data) {
                if (data != '') {
                    $('#blockend').before(data);
                }
            });

            curPage = curPage + 1;
            return r;
        };

        var colCount = 0;
        var colWidth = 239.8;
        var margin = 12.5;
        var spaceLeft = 0;
        var windowWidth = 0;
        var blocks = [];
        var botPos =0;

        function setupBlocks() {
            windowWidth = $(window).width();
            console.log(windowWidth);
            //console.log("windowWidth1:" + windowWidth);
            //console.log("window:" + $(window).width());
            blocks = [];

            // Calculate the margin so the blocks are evenly spaced within the window
            colCount = Math.floor(windowWidth / (colWidth + margin * 2));
            console.log(colCount);
            spaceLeft = (windowWidth - ((colWidth * colCount) + (margin * (colCount - 1)))) / 2;
            console.log(spaceLeft);
            for (var i = 0; i < colCount; i++) {
                //console.log("margin"+ i +":" + margin);
                blocks.push(margin);

            }

        }
        function positionAllBlocks() {

            $('.block').each(function() {

                var min = Array.min(blocks);

                var index = $.inArray(min, blocks);

                //console.log("margin"+ index +":" + min);
                var leftPos = $('#journals').position().left + (index * (colWidth + margin));
                //console.log("leftPos:" + leftPos);
                $(this).css({
                    'left' : (leftPos + spaceLeft) + 'px',
                    'top' : min + $('#banner').position().top + $('#banner').height() + 20 + 'px'
                });
                //console.log("left:" + $(this).position().left);
                blocks[index] = min + $(this).height() + margin;
                botPos = Array.min(blocks);

            });

        }

        // Function to get the Min value in Array
        Array.min = function(array) {

            return Math.min.apply(Math, array);

        };
        Array.max = function(array) {

            return Math.max.apply(Math, array);

        };

        $(document).ready(function() {

            setupBlocks();
            loadMoreContent();

        });

        $(window).resize(function() {
            setupBlocks();
            positionAllBlocks();
        })

        setInterval(function() {
            // Modify to adjust trigger point. You may want to add content
            // a little before the end of the page is reached. You may also want
            // to make sure you can't retrigger the end of page condition while
            // content is still loading.
            if ((!isActive && curPage < $('#maxPage').val()) && $(window).scrollTop() + $(window).height() >= botPos) {

                loadMoreContent();

            }
        }, 1000);
    </script>