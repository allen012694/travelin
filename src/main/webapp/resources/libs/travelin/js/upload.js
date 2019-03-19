'use strict';

var isAdvancedUpload = function() {
  var div = document.createElement('div');
  return (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div)) && 'FormData' in window && 'FileReader' in window;
};
	
var createUploadBox = function(upform, opt) {
	var input = upform.find('input.box__file');
	var label = upform.find('label.box__label');

	if (opt !== undefined) {
		if (opt.height !== undefined) {
			upform.css('height', opt.height);
		}
		if (opt.width !== undefined) {
			upform.css('width', opt.width);
		}
	}

	var showFiles = function(files) {
		if (!files) return false;
		// label.text(files.length > 1 ? (input.attr('data-multiple-caption') || '').replace( '{count}', files.length ) : files[ 0 ].name);
		label.text((input.attr('data-multiple-caption') || '').replace( '{count}', files.length ))
	};

	if (isAdvancedUpload) {
	    upform.addClass('has-advanced-upload'); 

	    var droppedFiles = false;
	    var upFiles = false;
	    upform.on('drag dragstart dragend dragover dragenter dragleave drop', function(e) {
	        e.preventDefault();
	        e.stopPropagation();
	    }).on('dragover dragenter', function() {
	        upform.addClass('is-dragover');
	    }).on('dragleave dragend drop', function() {
	        upform.removeClass('is-dragover');
	    })
	}

	input.on('change', function(e) {
		// droppedFiles = e.originalEvent.dataTransfer.files; // the files that were dropped
	 //    $.each( droppedFiles, function(i, file) {
		// 	if (!file.type.match('image.*')) {
		// 		droppedFiles = false;
		// 		alert('Có vẻ như bạn không định up ẢNH thì phải. :D');
		// 		return false;
		// 	}
		// });
		upFiles = e.target.files;
		$.each( upFiles, function(i, file) {
			if (!file.type.match('image.*')) {
				upFiles = false;
				alert('Có vẻ như bạn không định up ẢNH thì phải. :D');
				return false;
			}
		});
	    showFiles(upFiles);

	});

	upform.on('drop', function(e) {
	    droppedFiles = e.originalEvent.dataTransfer.files; // the files that were dropped
	    $.each( droppedFiles, function(i, file) {
			if (!file.type.match('image.*')) {
				droppedFiles = false;
				alert('Có vẻ như bạn không định up ẢNH thì phải. :D');
				return false;
			}
		});
	    showFiles( droppedFiles );
	});

	upform.on('submit', function(e) {
		// console.log(e.target.files);
		if (droppedFiles === false && upFiles === false) return false;

	    if (upform.hasClass('is-uploading')) return false;

	    upform.addClass('is-uploading').removeClass('is-error');

	    if (isAdvancedUpload) {
	        // ajax for modern browsers
	        e.preventDefault();

	        var ajaxData = new FormData(upform.get(0));
	        // console.log(upform.get(0));
	        // var ajaxData = new FormData();
	        // return false;
	        if (droppedFiles) {
	            $.each( droppedFiles, function(i, file) {
	                ajaxData.append( input.attr('name'), file );
	            });
	        } else {
	        	// do nothing
	        }

	        $.ajax({
	            url: upform.attr('action'),
	            type: upform.attr('method'),
	            data: ajaxData,
	            dataType: 'json',
	            cache: false,
	            contentType: false,
	            processData: false,
	            complete: function() {
	                upform.removeClass('is-uploading');
	            },
	            success: function(data) {
	                // upform.addClass( data.success == true ? 'is-success' : 'is-error' );
	                // if (!data.success) $errorMsg.text(data.error);
	                if (data.success == true) alert("Thành công!");
	                else alert("Thất bại!");
	                location.reload();
	            },
	            error: function() {
	              // Log the error, show an alert, whatever works for you
	            }
	        });
	    } else {
	        // ajax for legacy browsers
	        var iframeName  = 'uploadiframe' + new Date().getTime();
	        $iframe   = $('<iframe name="' + iframeName + '" style="display: none;"></iframe>');

	        $('body').append($iframe);
	        upform.attr('target', iframeName);

	        $iframe.one('load', function() {
	            var data = JSON.parse($iframe.contents().find('body').text());
	            upform.removeClass('is-uploading').addClass(data.success == true ? 'is-success' : 'is-error').removeAttr('target');
	            if (!data.success) $errorMsg.text(data.error);
	            upform.removeAttr('target');
	            $iframe.remove();
	        });
	    }
	});	
}