<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div class="footer">
			<div class="w3-row">
				<div class="w3-col w3-container l3">
					<h3>TRỢ GIÚP</h3>
					<ul class="practical">
						<li><a class="" href="/terms/">Điều khoản sử dụng</a></li>
						<li><a class="" href="/privacy/">Quyền riêng tư</a></li>
					</ul>
				</div>
				<div class="w3-col w3-container l3">
					<h3>LIÊN HỆ</h3>
					<ul class="social">
						<li><a href="/support/">Liên lạc</a></li>
						<li><a href="/travelin/feedback">Góp Ý</a></li>
					</ul>
				</div>
				<div class="w3-col w3-container l3">
					<h3>CỘNG ĐỒNG</h3>
					<ul class="social">
						<li><a class="facebook" href="https://www.facebook.com/" target="_blank">Facebook</a></li>
						<li><a class="twitter" href="http://twitter.com/" target="_blank">Twitter</a></li>
						<li><a class="pinterest" href="https://www.pinterest.com/" target="_blank">Pinterest</a></li>
						<li><a class="instagram" href="https://instagram.com/" target="_blank">Instagram</a></li>
					</ul>
				</div>
				<div class="w3-col w3-container l3">
					<h3>THEO DÕI</h3>

					<div id="mc_embed_signup">
						<!-- <form action="/travelin/subscribe" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" -->
							<!-- target="_blank" novalidate=""> -->
							<div id="mc_embed_signup_scroll">
								<div class="mc-field-group">
									<label for="mce-EMAIL" class="visually-hidden"></label> <input class="w3-input" type="email"
										value="" name="email" class="required email" id="mce-email" placeholder="Địa chỉ Email">
								</div>
								<!-- <input class="w3-btn w3-red" type="submit" value="THEO DÕI" name="subscribe" id="mc-embedded-subscribe"> -->
								<button type="button" class="w3-btn w3-red" id="mc-embedded-subscribe" onclick="subscr(event)">THEO DÕI</button>
							</div>
						<!-- </form> -->
					</div>
					<!--End mc_embed_signup-->

				</div>
			</div>
			<p>TravelIn © 2016</p>
			
		</div>
	</div>
	<script type="text/javascript">
		var subscr = function(e) {
			$.ajax({
				url: "/travelin/subscribe",
				data: {"em": $("#mce-email").val()},
				type: "POST",
				dataType:"JSON"
			}).success(function(data) {
				if (data.status == 1) alert("Đã đăng ký nhận tin thành công!");
				else if (data.status == 2) alert("Email này đã được đăng ký rồi!");
				else if (data.status == -1) alert("Email này không hợp lệ");
				else alert("Đã có lỗi xảy ra, xin thử lại sau!");
			});
		};
	</script>
	</body>
</html>