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
<!--===============================================================================================-->
<!--	 <script src="js/jquery.js"></script> 
		<script src="js/datatables.min.js"></script>-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script src="js/bootbox.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/jquery.dataTables.bootstrap.js"></script>
	<script type="text/javascript">
	window.onload=function(){
		memberview();
		sidemenu();
	};
	function memberview(){
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
			        	  $('body').css('background-image', 'linear-gradient(to right, rgba(27, 60, 121, 0.7),rgba(27, 60, 121, 0.7)),url("images/about-video.jpg")');
			              $('body').css('background-size','100% 100%,100% 100%');
		            }
		         }else{//訪客  $('body').css('background-image', 'linear-gradient(to right, rgba(41, 28, 10, 0.65),rgba(41, 28, 10, 0.65)),url("images/about-video.jpg")');        	   
		             $('body').css('background-image', 'linear-gradient(to right, rgba(25, 40, 103, 0.65),rgba(25, 40, 103, 0.65)),url("images/about-video.jpg")');
		      	   $('body').css('background-size','100% 100%,100% 100%');
		         }
		$('#updatemember').on("click",function(){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/IDSearchServelt",
				datatype:"json",
				//async: false,
				//contentType:"false",
				data:{
					tablename:"Account",
					id:doID
				},
				success:function(result){
					var obj = JSON.parse(result);
					action_page("user_update",obj);
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
				return false;
	 	});
		$('#searchlog').on("click",function(){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/IDSearchServelt",
				datatype:"json",
				//async: false,
				//contentType:"false",
				data:{
					type:'log',
					tablename:"AccountLog",
					id:doID
				},
				success:function(result){
					console.log(result)
					var obj = JSON.parse(result);
					action_page("user_log",obj);
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
				return false;
	 	});
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/IDSearchServelt",
					datatype:"json",
					async: false,
					//contentType:"false",
					data:{
						tablename:"Account",
						id:doID
					},
					success:function(result){
						submit_info(result);
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
		}
			function submit_info(shop_info){
				var obj = JSON.parse(shop_info);
				console.log(obj)
				var info;
			info='<div><div class="profile-user-info profile-user-info-striped"style="float: left;">'+ 
				        '<div class="profile-info-row">'+ 
				        '<div class="profile-info-name">中文姓名:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Account_Name+'</div>'+ 
				        '<div class="profile-info-name">英文姓名:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Account_EName+'</div>'+ 
				        '<div class="profile-info-name">電子郵件:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Account_Email+'</div>'+
				        '<div class="profile-info-name">手機號碼:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Account_Phone +'</div>'+ 
				        '<div class="profile-info-name">地址:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Account_Address +'</div>'+
				      '</div>'+ 
				    '</div>'+ 
				    '<div style="float: left;width: 300px;height: 500px;">'
				    if(obj[0].Account_PhotoName==''){
				    	info+=  '<img src="${pageContext.request.contextPath}/upload/Account/default_user.png" style="width: auto;height: auto;max-width: 100%;max-height: 100%;">'+
					    '</div>'
				    }else{
				    	info+=  '<img src="${pageContext.request.contextPath}/upload/Account/'+obj[0].Account_PhotoName+'" style="width: auto;height: auto;max-width: 100%;max-height: 100%;">'+
					    '</div>'	
				    }
			
			$("#memberinfo").html(info);	
			}
			//執行對話框內的動作
			function action(action_url,type_,form_data) {
				var doID ="${doID}"
					$.ajax({
						type:"post",
						url:action_url,
						datatype:"text",
						//contentType:"false",
						data:{
							tablename:"Account",
							type:type_,
							id:form_data.account_key,
							name:form_data.account_name,
							password:form_data.account_password,
							ename:form_data.account_ename,
							phone:form_data.account_phone,
							email:form_data.account_email,
							address:form_data.account_address,
							vaild:1
						},
						success:function(result){
							if($("#account_photo").val()!=''){
								Accountupload(form_data.account_key,"user_update");
							}else{
								if(result=='1'){
									alert('修改成功')
									location.reload();
								}else if(result=='2'){
									alert('資料與先前相同')
									location.reload();
								}else{
									alert('修改失敗')
									location.reload();
								}
							}
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}	
			function Accountupload(userID,type_){
				//上傳照片到server 和 DB
				var doID ="${doID}"
				var formData = new FormData(form_account);
				formData.append("userID", userID);
				formData.append("doID", doID);
				formData.append("type", 'update');			
				formData.append("tablename", "Account");
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/AccountUploadServlet",
					datatype:"text",
					processData: false,
					contentType:false,
					cache : false,
					data:formData,
					async: false,
					success:function(result){
						if(result=='1'){
							bootbox.alert({
							    message: "修改成功",
							    callback: function () {
							    	location.reload();
							    }
							})
						}else{
							bootbox.alert({
							    message: "修改失敗",
							    callback: function () {
							    	location.reload();
							    }
							})
						}
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
			}
		
			//設計對話框樣式
			function action_page(type_,shop_info){
				if(type_=='user_update'){
					shop_info=shop_info[0]
					action_url = "${pageContext.request.contextPath}/DBUpdateServelt";
				}else{
					shop_info=shop_info
				}
				
				
				<%-- 按鈕圖示 --%>
				var button_action_icon = 'check';
				<%-- 按鈕文字 --%>
				var button_action_text = '修改' ;
				
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
				if(type_ == 'user_update'){
					
					bootbox_buttons.save = {
						label: '<i class="fa fa-'+button_action_icon+' fa-2x"></i> ' + button_action_text,
						className: 'btn btn-sm btn-primary',
						callback:function(result){

							//<%-- 欄位驗證 --%>
							if(validate()){
								//<%-- 設計傳送資料 --%>
								var form_data = {};
									form_data.account_key = shop_info.Account_ID;
									form_data.account_password = $("#account_password1").val();								
									form_data.account_name = $("#account_name").val();
									form_data.account_ename = $("#account_ename").val();
									form_data.account_phone = $("#account_phone").val();
									form_data.account_email = $("#account_email").val();
									form_data.account_address = $("#account_address").val();
								form_data.type = type_;
								//<%-- 執行 --%>
								action(action_url,type_,form_data);
							}
							//<%-- 在驗證沒過的時候，需保留麵給使用者 --%>
							event.preventDefault();
							return false;
						}
						
					}
				}
					bootbox_buttons.cancel = {
							label: '<i class="fa fa-times fa-2x"></i> 關閉',
							className: 'btn btn-sm btn-danger',
							callback:function(){
							}
					}
					//設定標題
					var bootbox_title=""
					if(type_=='user_update'){
						bootbox_title="修改會員資訊"
					}else{
						bootbox_title="修改紀錄"
					}
					var message = get_bootbox_message(type_ ,shop_info);
					bootbox.dialog({
						<%-- 對話框大小 --%>
						size: 'large',
						<%-- 對話框標題 --%>
						title: '<h3 class="smaller lighter no-margin blue">'+bootbox_title+'</h3>',
						<%-- 對話框內容 --%>
						message:message,
						<%-- 對話框按鈕 --%>
						buttons: bootbox_buttons,
						<%-- 是否顯示關閉按鈕(右上角的X) --%>
						closeButton: false
					});
						$("#account_user").val(shop_info.Account_UserName);//帳號
						$("#account_name").val(shop_info.Account_Name);
						$("#account_ename").val(shop_info.Account_EName); 
						$("#account_email").val(shop_info.Account_Email);
						$("#account_phone").val(shop_info.Account_Phone);
						$("#account_address").val(shop_info.Account_Address);
					}
			
			//製作對話框內容
			function get_bootbox_message(type_,shop_info){
				var message=""
				if(type_=='user_update'){
					//<%-- 對話框內容 --%>
					message = '<form id="form_account" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
									'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">帳號 :</div>' +
										'<div class="profile-info-value">' +
											'<input type="text" class="form-control" id="account_user" name="input_account_user" disabled placeholder="請輸入帳號" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">密碼 :</div>' +
										'<div class="profile-info-value">' +
											'<input type="password" class="form-control" id="account_password1" name="input_account_password1" placeholder="不變更密碼則不用輸入" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">再次輸入密碼 :</div>' +
										'<div class="profile-info-value">' +
											'<input type="password" class="form-control" id="account_password2" name="input_account_password2" placeholder="不變更密碼則不用輸入" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">中文姓名 :</div>' +
											'<div class="profile-info-value">' + 
											'<input type="text" class="form-control" id="account_name" name="input_account_name" placeholder="請輸入名稱" />' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">英文姓名:</div>' +
											'<div class="profile-info-value">' +
												'<input type="text" class="form-control" id="account_ename" name="input_account_ename" placeholder="請輸入英文姓名"/>' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">電子郵件 :</div>' +
											'<div class="profile-info-value">' + 
											'<input type="text" class="form-control" id="account_email" name="input_account_email" placeholder="請輸入電子郵件" />' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">手機號碼:</div>' +
											'<div class="profile-info-value">' +
												'<input type="text" class="form-control" id="account_phone" name="input_account_phone" placeholder="請輸入手機號碼"/>' +
												'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">地址 :(預設為無 本欄位為選填)</div>' +
										'<div class="profile-info-value">' + 
										'<input type="text" class="form-control" id="account_address" name="input_account_address" placeholder="請輸入地址" />' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">上傳頭像 :</div>' +
										'<div class="profile-info-value">' +
											'<input type="file" class="form-control" id="account_photo" name="input_account_photo"/>' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
									'</div>' +
								'</form>'; 
				}else{
					message = '<div>';
					if(shop_info.length==0){
						message += '<h6> 尚未有任何變更紀錄 </h6>';
					}else{
						for(var key in shop_info){
							message+='<h6> ● ' +shop_info[key].AccountLog_Time.substring(0,16)+ shop_info[key].AccountLog_Event + '</h6>';
							}
					}
					message += '</div>';
				}
				return message;
			}
			
			
			function validate(){
				//<%-- 驗證規則(正則表達式) --%>
				var rule = /^.+$/;
				var return_boolean = true;
				var account_user = $("#account_user");
				var account_name = $("#account_name");
				var account_ename = $("#account_ename");
				var account_password1 = $("#account_password1");
				var account_password2 = $("#account_password2");
				var account_email=$('#account_email');
				var account_phone=$('#account_phone');
				
							if(rule.test(account_name.val())){
								account_name.siblings('.error').text('');
							}else{
								account_name.siblings('.error').text('請輸入中文名稱');
								return_boolean = false;
							}
							if(rule.test(account_ename.val())){
								account_ename.siblings('.error').text('');
							}else{
								account_ename.siblings('.error').text('請輸入英文名稱');
								return_boolean = false;
							}
							
							if(rule.test(account_email.val())){
								account_email.siblings('.error').text('');
							}else{
								account_email.siblings('.error').text('請輸入Email');
								return_boolean = false;
							}
							alert(account_phone.val().length)
							if(rule.test(account_phone.val())){
								if(account_phone.val().length<10){
									account_phone.siblings('.error').text('請輸入正確格式');
									return_boolean = false;	
								}else{
									account_phone.siblings('.error').text('');
								}
							}else{
									account_phone.siblings('.error').text('請輸入手機號碼');
									return_boolean = false;	
							}						
							if(rule.test(account_password1.val()) || rule.test(account_password2.val())){
								if(account_password1.val() == account_password2.val()){
									account_password1.siblings('span').text('');
									account_password2.siblings('span').text('');
									
								}else{
									account_password1.siblings('span').text('輸入的密碼不同');
									account_password2.siblings('span').text('輸入的密碼不同');
									
									return_boolean = false;
								}
							}
				return return_boolean;
			}
</script>

<meta charset="UTF-8">
<title>User View</title>


</head>
<body style="background-image: url('images/bgblack.png');">
<jsp:include page="../slidemenu.jsp"/>
		<div class="wrap-login100">
				<form class="login100-form validate-form" method="post">
					<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 70px;">
						會員資料
					</span>	
					<div id="memberinfo"style="color: white;position: relative;left: 50%;transform: translate(-50%,10px);font-size: x-large;padding: 10px;width: fit-content;">
            </div>
					<button class="login100-form-btn" id="updatemember" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">修改</button>
					<button class="login100-form-btn" id="searchlog" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">查看修改紀錄</button>
				</form>
			</div>

</body>


</html>