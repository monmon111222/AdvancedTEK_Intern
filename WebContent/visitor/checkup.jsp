<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/userview.css">
	<link rel="stylesheet" type="text/css" href="css/datatables.min.css">	
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
	<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
	window.onload=function(){
		checkup();
		sidemenu();
	};
	function checkup(){
		var total ="${total}"
		var prdID ="${prdID}"
		var doID ="${doID}"
		var dolevel ="${level}"
				if(doID){
		            if(dolevel.indexOf('1')===0){//管理員
		          	  $('body').css('background-image', 'linear-gradient(to right, rgba(10, 16, 41, 0.65),rgba(10, 16, 41, 0.65)),url("images/about-video.jpg")');
			              $('body').css('background-size','100% 100%,100% 100%');
		            }else if(dolevel.indexOf('3')===0){//買家
		          	  $('body').css('background-image', 'linear-gradient(to right, rgba(25, 40, 103, 0.65),rgba(25, 40, 103, 0.65)),url("images/about-video.jpg")');
			              $('body').css('background-size','100% 100%,100% 100%');
		            }else{//買賣家  
			        	  $('body').css('background-image', 'linear-gradient(to right, rgba(38, 63, 110, 0.7),rgba(38, 63, 110, 0.7)),url("images/about-video.jpg")');
			              $('body').css('background-size','100% 100%,100% 100%');
		            }
		         }else{//訪客  $('body').css('background-image', 'linear-gradient(to right, rgba(41, 28, 10, 0.65),rgba(41, 28, 10, 0.65)),url("images/about-video.jpg")');        	   
		             $('body').css('background-image', 'linear-gradient(to right, rgba(25, 40, 103, 0.65),rgba(25, 40, 103, 0.65)),url("images/about-video.jpg")');
		      	   $('body').css('background-size','100% 100%,100% 100%');
		         }
		var return_data="";
			if(doID){
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/IDSearchServelt",
					datatype:"json",
					async: false,
					//contentType:"false",
					data:{
						id:doID,
						tablename:"Account"
					},
					success:function(result){
						var obj = JSON.parse(result);
						console.log(obj)
				return_data='<div style="font-family: HonyaJi-Re;font-size: xx-large;color: white;">收件人資訊</div>'+
								'<div class="same-check" style="float:right;width: 50%">'+
								    '<input type="checkbox" class="form-check-input" id="same-guy">'+
								    '<label class="same-guy-label" for="same-guy"style="font-family: HonyaJi-Re;font-size: x-large;color:#cfd8dc;">收件人與會員資訊相同</label>'+
								'</div>'+
							'<form id="form_account" class="form-horizontal" method="post" style="padding-left: 10%;padding-right: 10%;margin-top: 2%;"accept-charset="utf-8">' +
										'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">姓名 :</div>' +
											'<div class="profile-info-value">' + 
											'<input type="text" class="form-control" id="account_name" name="input_account_name" placeholder="請輸入姓名" />' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">地址 :</div>' +
											'<div class="profile-info-value">' +
												'<input type="text" class="form-control" id="account_address" name="input_account_user" placeholder="請輸入地址" />' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">Email:</div>' +
											'<div class="profile-info-value">' +
												'<input type="email" class="form-control" id="account_email" name="input_account_email" placeholder="請輸入Email" />' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">手機號碼 :</div>' +
											'<div class="profile-info-value">' +
												'<input type="email" class="form-control" id="account_phone" name="input_account_phone" placeholder="請輸入手機號碼" />' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
									'</div>' +
								'</form>'+
								'<button class="login100-form-btn" id="order" style="float: right;margin-top: 2%;font-family:HanyiSentyGarden;">下單</button>';
				 
						$("#buyer-info").html(return_data);
						$("#same-guy").change(function() {
						      if(this.checked) {
									$('#account_name').val(obj[0].Account_Name);
									$('#account_address').val(obj[0].Account_Address);
									$('#account_email').val(obj[0].Account_Email);
									$('#account_phone').val(obj[0].Account_Phone);
						    	  }else{
						    		$('#account_name').val('');
									$('#account_address').val('');
									$('#account_email').val('');
									$('#account_phone').val('');
						    	  }
						});
						
								    
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
    		}else{
    			return_data='<div style="font-family: HonyaJi-Re;font-size: xx-large;color: white;">收件人資訊</div>'+
    						'<div style="font-family: HonyaJi-Re;font-size:x-large;color: white;">提醒:以訪客身分結帳 無法進行訂單內商品的修改或訂單的取消 因此建議'+
    						'<a style="font-family: HonyaJi-Re;font-size:x-large;color: #ef9a9a !important;" href=${pageContext.request.contextPath}/OpenSinguppageServlet>註冊會員</a></div>'+
							'<form id="form_account" class="form-horizontal" method="post" style="padding-left: 10%;padding-right: 10%;"accept-charset="utf-8">' +
										'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">姓名 :</div>' +
											'<div class="profile-info-value">' + 
											'<input type="text" class="form-control" id="account_name" name="input_account_name" placeholder="請輸入姓名" />' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">地址 :</div>' +
											'<div class="profile-info-value">' +
												'<input type="text" class="form-control" id="account_address" name="input_account_user" placeholder="請輸入地址" />' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">Email:</div>' +
											'<div class="profile-info-value">' +
												'<input type="email" class="form-control" id="account_email" name="input_account_email" placeholder="請輸入Email" />' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">手機號碼 :</div>' +
											'<div class="profile-info-value">' +
												'<input type="email" class="form-control" id="account_phone" name="input_account_phone" placeholder="請輸入手機號碼" />' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
									'</div>' +
								'</form>'+
								'<button class="login100-form-btn" id="order" style="float: right;margin-top: 2%;font-family:HanyiSentyGarden;">結帳</button>';
				$("#buyer-info").html(return_data);
    		}
			$('#order').on("click",function(){
				order()
	 		});
			
	}
	function order(){
		var total ="${total}"
		var doID ="${doID}"
		if(doID){
		}else{
			doID=0;
		}
		var shopsellerID="${shopsellerID}"
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/OrderServlet",
			datatype:"text",
			async: false,
			//contentType:"false",
			data:{
				shopsellerID:shopsellerID,
				buyerID:doID,
				totalprice:total,
				name: $("#account_name").val(),
				address:$("#account_address").val(),
				email:$("#account_email").val(),
				phone:$("#account_phone").val()
			},
			success:function(result){
				if(result=='1'){
					alert('已成功送出訂單')
					location.href = '${pageContext.request.contextPath}/HomeServlet'
				}else{
					alert('送出訂單過程出錯，購物車尚未清空請再次下單')
					location.href = '${pageContext.request.contextPath}/HomeServlet'
				}
				
			},
			error:function(xhr,ajaxOptions,thrownError){
				alert("");
				alert(xhr.status);
				alert(thrownError);
			}
		});
	}
	</script>
<style>
/* *{border:1px solid #000;} */
.profile-info-name{
	color:white;
}

</style>
</head>
<body>
<jsp:include page="../slidemenu.jsp"/>
<div id="buyer-info" style="width: 50%;position: relative;top: 10%;transform: translate(-50%, 10px);left: 50%;">

</div>


</body>
</html>