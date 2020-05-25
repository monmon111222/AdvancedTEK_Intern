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
		shopview();
		sidemenu();
	};
	function shopview(){
   	    $('body').css('background-image', 'linear-gradient(to right, rgba(38, 63, 110, 0.7),rgba(38, 63, 110, 0.7)),url("images/about-video.jpg")');
        $('body').css('background-size','100% 100%,100% 100%');
		var doID ="${doID}"
		var BS ="${BS}"
		var shopsellerID ="${shopsellerID}"
		if(BS=='S'){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/IDSearchServelt",
				datatype:"json",
				async: false,
				//contentType:"false",
				data:{
					tablename:"Shop",
					id:doID
				},
				success:function(result){
					if(submit_info(result)){
						$('#updateshop').remove();
					}else{
						$('#insertshop').remove();
						$.ajax({
							type:"post",
							url:"${pageContext.request.contextPath}/IDSearchServelt",
							datatype:"json",
							//async: false,
							//contentType:"false",
							data:{
								tablename:"ShopProduct",
								id:doID
							},
							success:function(result){
								console.log(result)
								if(result=='[]'){
									$('#subtitle').text('您的商店為上架任何商品，故您的商店不會出現在商店頁面')
									
								}
							},
							error:function(xhr,ajaxOptions,thrownError){
								alert("");
								alert(xhr.status);
								alert(thrownError);
							}
						});
					}
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
			
			$('#updateshop').on("click",function(){
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/IDSearchServelt",
					datatype:"json",
					//async: false,
					//contentType:"false",
					data:{
						tablename:"Shop",
						id:doID
					},
					success:function(result){
						var obj = JSON.parse(result);
						console.log(typeof(obj));
						action_page("update",obj);
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
					return false;
		 		});
			$('#insertshop').on("click",function(){
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/IDSearchServelt",
					datatype:"json",
					data:{
						tablename:"Shop",
						id:doID
					},
					success:function(result){
						var obj = JSON.parse(result);
						console.log(typeof(obj));
						action_page("insert",obj);
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
							tablename:"Shop",
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
		}else{
			$('#insertshop').remove();
			$('#updateshop').remove();
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/IDSearchServelt",
				datatype:"json",
				//async: false,
				//contentType:"false",
				data:{
					tablename:"Shop",
					id:shopsellerID
				},
				success:function(result){
					console.log(result)
					if(result=='[]'){
						$('#subtitle').text('您的商店為上架任何商品，故您的商店不會出現在商店頁面')
					}else{
						submit_info(result);
					}
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
		}
		
	}
			function submit_info(shop_info){
				var emp=false
				var obj = JSON.parse(shop_info);
				var info;
				if(obj.length==0){
					emp=true
			info='<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 50px;color:#ef9a9a;">您尚未建立商店</span>'		
				}else{
			info='<div style="float: left;width: 60%;"><div class="profile-user-info profile-user-info-striped">'+ 
				        '<div class="profile-info-row">'+ 
				        '<div class="profile-info-name"  style="color: #c0c5ce;">商店名稱:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Shop_Name+'</div>'+ 
				      '</div>'+ 
				    '</div>'+ 
				    '<div class="profile-user-info profile-user-info-striped">'+  
				      '<div class="profile-info-row">'+ 
				        '<div class="profile-info-name"  style="color: #c0c5ce;">關於商店:</div>'+ 
				        '<div class="profile-info-value" style="white-space: pre-wrap;">'+obj[0].Shop_Detail+'</div>'+ 
				      '</div>'+
				    '</div><div class="profile-user-info profile-user-info-striped">'+  
				      '<div class="profile-info-row">'+ 
				        '<div class="profile-info-name" style="color: #c0c5ce;">免運門檻:</div>'+ 
				        '<div class="profile-info-value">'+obj[0].Shop_ShipFee+'</div>'+ 
				      '</div>'+
				      '</div><div class="profile-user-info profile-user-info-striped">'+  
				      '<div class="profile-info-row">'+ 
				        '<div class="profile-info-name" style="color: #c0c5ce;">商店類型:</div>'+ 
				        '<div class="profile-info-value">'+GetColVal('ShopType','ShopType_ID','ShopType_Detail',obj[0].Shop_Type)+'</div>'+ 
				      '</div>'+
				    '</div></div>'+
				    '<div style="float: right;width: 300px;height: 300px;">'+
				    '<img src="${pageContext.request.contextPath}/upload/Shop/'+obj[0].Shop_SellerID+'/'+obj[0].Shop_CoverFileName+'" style="width: auto;height: auto;max-width: 100%;max-height: 100%;">'+
				    '</div>'
				}
				console.log(info)
			$('#shop_info').html(info);
			return emp	
			}
			function getradiovalue(rdname){
				var val=0;
//				$("input:radio[name='"+rdname+"']").change(function(){
					$("input:radio[name='"+rdname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
							}
						});
//					});	
				console.log(val);
			 return val;	
			}
			//製作radio
			function submit_radio(result,idname){
//				console.log(result);

				var radioData="";
				$.each(result, function(index, value) {
					radioData+='<input type="radio" id="'+idname+index+'" name="'+idname+'"value="'+index+'" style="margin: 1%;">'+value;
				});
	    		radioData+='<br>'+'<span class="red error" style="color: red;"></span>'
	    		$("#typeradio").html(radioData);//運用html方法將拼接的table新增到tbody中return;
			}
			function GetColVal(tablename,colname1,colname2,ind){
				var findvalue=0;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/GetColValSearchServelt",
		            dataType:"json",
		            async: false,
		            data: {
		            	tablename : tablename,
		            	colname1:colname1,
		            	colname2:colname2	
		            	},
		            //<%-- 回傳成功 --%>
		            success: function(result){
		            	if(ind===null){
		            		findvalue=result[0];
		            	}else{
		            		$.each(result[0], function(index, value) {
		            			if(ind===index){
		            				findvalue=value;}
		            		}); 
	            		    
		            	}
		            },
		            //<%-- 回傳失敗 --%>
		            error:
		                function(xhr, ajaxOptions, thrownError){
		                    alert(xhr.status+"\n"+thrownError);
		                }
				});
				return findvalue;
			}
			//執行對話框內的動作
			function action(action_url,type_,form_data) {
				var shop_detail=$("#shop_detail").val()
					shop_detail=shop_detail.replace(/(?:\r\n|\r|\n)/g, '+');
				var doID ="${doID}"
					var formData = new FormData(form_shop);
					formData.append("doID", doID);
					formData.append("type", type_);			
					formData.append("tablename", "Shop");
					formData.append("shop_detail", shop_detail);
				 if(type_=="update"){//修改
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/InsShopServelt",
						datatype:"text",
						processData: false,
						contentType:false,
						cache : false,
						data:formData,
						async: false,
						success:function(result){
								alert('變更成功')
							location.reload();
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}else if(type_=="insert"){
					var doID ="${doID}"
						var formData = new FormData(form_shop);
						formData.append("doID", doID);
						formData.append("type", type_);			
						formData.append("tablename", "Shop");
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/InsShopServelt",
						datatype:"text",
						processData: false,
						contentType:false,
						cache : false,
						data:formData,
						async: false,
						success:function(result){
							alert("您的商店已創立成功!");
							location.reload();
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}	
			}
			//設計對話框樣式
			function action_page(type_,shop_info){
				//var shop_info;
				if(type_ == 'update'){
					shop_info=shop_info[0];
					action_url = "${pageContext.request.contextPath}/InsShopServelt";
				}else if(type_ == 'insert'){
					action_url = "${pageContext.request.contextPath}/InsShopServelt";
				}
				<%-- 按鈕圖示 --%>
				var button_action_icon = 
					(type_ != 'delete') ? 'check' : 
					(product_info.Product_Vaild == 1) ? 'thumbs-down' : 'thumbs-up';
				<%-- 按鈕文字 --%>
				var button_action_text = 
					(type_ == 'delete') ? (product_info.Product_Vaild == 1) ? '下架' : '重新上架' : 
					(type_ == 'update') ? '修改' : '新增';
				
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
					
					bootbox_buttons.save = {
						label: '<i class="fa fa-'+button_action_icon+' fa-2x"></i> ' + button_action_text,
						className: 'btn btn-sm btn-primary',
						callback:function(result){

							//<%-- 欄位驗證 --%>
							//if(validate(type_)){
								//<%-- 設計傳送資料 --%>
								var form_data = {};
								
									//<%-- 新增 與 修改 只差在 key 值，所以寫在一起 --%>
									form_data.shop_key = (type_ == "update") ?  shop_info.Shop_ID : 0;
									form_data.shop_name = $("#shop_name").val();
									form_data.shop_detail = $("#shop_detail").val();
									form_data.shop_shipfee = $("shop_shipfee").val();
									form_data.shop_type = getradiovalue('typename');
								form_data.type = type_;
								//<%-- 執行 --%>
								action(action_url,type_,form_data);
							//}
							//<%-- 在驗證沒過的時候，需保留麵給使用者 --%>
							event.preventDefault();
							return false;
						
						
					}
				}
					bootbox_buttons.cancel = {
							label: '<i class="fa fa-times fa-2x"></i> 關閉',
							className: 'btn btn-sm btn-danger',
							callback:function(){
							}
					}
					//設定標題
					var bootbox_title;
					if(type_== "update"){
						bootbox_title="修改商店資訊"
					}else {
						bootbox_title="建立商店"
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
					submit_radio(GetColVal("ShopType","ShopType_ID","ShopType_Detail",null),"shop_type");
					if(type_ == "update"){
						$("#shop_name").val(shop_info.Shop_Name);//產品名稱
						$("#shop_detail").val(shop_info.Shop_Detail);//細節說明
						$("#shop_shipfee").val(shop_info.Shop_ShipFee);//細節說明
						//$("#shop_type").val(shop_info.Shop_Type);
						$("input[name='shop_type']").each(function(){
							var type=$(this).attr('value')
							console.log(type)
							if(shop_info.Shop_Type.indexOf(type)>=0){
								$(this).attr('checked',true)}
							});
						
						}
					}
			
			//製作對話框內容
			function get_bootbox_message(type_,shop_info){
				
				//<%-- 對話框內容 --%>
				var message = "";
				//<%-- 刪除 --%>
				if(type_ == "delete"){
					message = '<span class="note"> ' + ' [ <span class="bold"> '+ shop_info.Shop_Name +' </span> ]  </span>';
				//<%-- 操作紀錄 --%>
				}else if(type_ == "log"){
					//<%-- class="pre-scrollable" 會顯示 Y 軸的卷軸 --%>
					message = '<div>';
					if(shop_info.length==0){
						alert(shop_info.length)
						message += '<h6> 尚未有任何變更紀錄 </h6>';
					}else{
						for(var key in shop_info){
							message+='<h6> ● ' +shop_info[key].ProductLog_Time.substring(0,16)+ shop_info[key].ProductLog_Event + '</h6>';
							}
					}
					message += '</div>';
					
				//<%-- 詳細資料 --%>
				}else if(type_ == "detail"){
					message = '<div id="testinfo" style="float: left;width: 400px;">'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商店名稱:</div>' +
										'<div class="profile-info-value">' + shop_info.Shop_Name + '</div>' +
									'</div>' +
								'</div>'+
							'</div>';
				}else{
					message = 	'<form id="form_shop" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商店名稱 :</div>' +
										'<div class="profile-info-value">' + 
										'<input type="text" class="form-control" id="shop_name" name="input_shop_name" placeholder="請輸入名稱" />' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">細節說明 :</div>' +
										'<div class="profile-info-value">' +
											'<textarea class="form-control" id="shop_detail" name="input_shop_detail" placeholder="請輸入細節說明" style="height: 100px;white-space: pre-wrap;"/>' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">免運門檻 :</div>' +
										'<div class="profile-info-value">' +
											'<input class="form-control" id="shop_shipfee" name="input_shop_shipfee" placeholder="請輸入您想設定的免運門檻" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
									'<div class="profile-info-name">商店類型 :</div>' +
									'<div class="profile-info-value" id="typeradio">'+
										'<span class="red error" style="color: red;"></span>' +
									'</div>' +
								'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">上傳商店封面 :</div>' +
										'<div class="profile-info-name" style="color:#ee6c4d;">建議封面照使用300px*300px的圖片，如超過可能會導致壓縮過度，如小於則不會放大填滿</div>' +
										'<div class="profile-info-value">' +
											'<input type="file" class="form-control" id="shop_photo" name="input_shop_photo"/>' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
								'</div>' +
							'</form>'; 
				}
				return message;
			}
			function check_repeat(account_user){
				return_check = false;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/SearchServelt",
		            dataType:"json",
		            async: false,
		            data: {
		            	//<%-- 使用者帳號 --%>
		            	user : account_user,
		            },
		            success: function(result){
		            	if(result.length === 0){
		            		return_check = true;}
		            },
		            error:
		                function(xhr, ajaxOptions, thrownError){
		                    alert(xhr.status+"\n"+thrownError);
		                }
				});
				return return_check;
			}
			function validate(type_){
				//<%-- 驗證規則(正則表達式) --%>
				var rule = /^.+$/;
				//<%-- 回傳boolean參數，預設為true --%>
				var return_boolean = true;
				//<%-- shop_name 物件 --%>
				var shop_name = $("#shop_name");
				//<%-- product_price 物件 --%>
				//<%-- shop_detail 物件 --%>
				var shop_detail = $("#shop_detail");
				
				//<%-- 此處會有三種 type 新增、修改、刪除，刪除只需要執行再次確認的畫面即可，所以不需要執行欄位驗證 --%>
				switch (type_){
					case "delete":
						return true;
						break;
					//<%-- 新增(insert)不使用 break 中斷 switch 流程，是因為 修改(update)與 新增(insert)有共同驗證的欄位--%>
					case "insert":
						//<%-- 因為 新增(insert)時，password 是必填欄位，在 修改(update)為非必填欄位--%>
						if(rule.test(product_name.val())){
							product_name.siblings('.error').text('');
						}else{
							product_name.siblings('.error').text('請輸入產品名稱');
							return_boolean = false;
						}
						if(rule.test(product_price.val())){
							product_price.siblings('.error').text('');
						}else{
							product_price.siblings('.error').text('請輸入產品價格');
							return_boolean = false;
						}
						if(product_detail.val()==""){
							if (confirm("未輸入商品細節說明，如要返回輸入則按「取消」")){
							}else{return false;}   　　　
						}
						break;
					case "update":
						if(rule.test(product_name.val())){
							product_name.siblings('.error').text('');
						}else{
							account_password1.siblings('.error').text('請輸入產品名稱');
							//account_password1.siblings('.error').append('請輸入密碼append');
							return_boolean = false;
						}
						if(rule.test(product_price.val())){
							product_price.siblings('.error').text('');
						}else{
							product_price.siblings('.error').text('請輸入產品價格');
							return_boolean = false;
						}
						if(product_detail.val()==""){
							if (confirm("未輸入商品細節說明，如要返回輸入則按「取消」")){
							}else{return false;}   　　　
						}
						break;
				}
				return return_boolean;
			
			}
</script>

<meta charset="UTF-8">
<title>User View</title>


</head>
<body>
<jsp:include page="../slidemenu.jsp"/>
		<div class="wrap-login100">
				<form class="login100-form validate-form" method="post">
					<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 70px;">
						商店資訊
					</span>	
					<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 50px;color:#ef9a9a;" id="subtitle"></span>
					<div class="wrap-login100" id="shop_info"style="color: white;position: relative;left: 50%;transform: translate(-50%,10px);font-size: x-large;padding: 10px;"></div>
					<button class="login100-form-btn" id="updateshop" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">修改</button>
					<button class="login100-form-btn" id="insertshop" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">建立</button>
					
				</form>
			</div>

</body>


</html>