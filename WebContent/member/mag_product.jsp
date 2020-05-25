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
		productview();
		sidemenu();
	};
	function productview(){
		var doID ="${doID}"
		    $.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/ProductSearchServelt",
				datatype:"json",
				//contentType:"false",
				data:{
					tablename:"Product",
					user:$('#prdnameinput').val(),
					name:$('#prdnameinput').val(),//getParameter(xx)
					doID:doID
				},
				success:function(result){
//					console.log(targets);
	            	submit_table(result,"Product");
					
					$('#tbody').DataTable({
				    	searching: false, //關閉搜尋功能
			            oLanguage: {    // 中文化  
			                "sLengthMenu": "每頁顯示 _MENU_筆",
			                "sZeroRecords": "沒有找到符合條件的資料",
			                "sProcessing": "載入中...",
			                "sInfo": "當前第 _START_ - _END_ 筆　共計 _TOTAL_ 筆",
			                "sInfoEmpty": "沒有記錄",
			                "sInfoFiltered": "(從 _MAX_ 條記錄中過濾)",
			                "sSearch": "搜尋：",
			                "oPaginate": {
			                    "sFirst": "首頁",
			                    "sPrevious": "前一頁",
			                    "sNext": "後一頁",
			                    "sLast": "尾頁"
			                }
			            },
			            iDisplayLength: 5,// 每頁顯示筆數 
			            bSort: true,// 排序
			            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
			            columnDefs: [{
			            	//3瀏覽  4歷程 5修改 6刪除
			                targets: [5,6,7,8], //設定第n欄不進行排序功能
			                orderable: false,
			            }],
			            "drawCallback":action_function()  
					});
					
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
				
		    return false;  
		}
			
			function action_function(){
				
					//<%-- 實作 HTML 物件 class 屬性有 account_aciont 的功能 --%>
					/*<%-- 注意事項  
					 		所以 新增的功能才必須抽離製作，否則在每次執行時都需要重設，物件的onclick功能，否則重複執行該物件會有重複執行的狀況發生 --%>*/
					$('.account_action').on('click',function(){
						//<%-- 執行的按鈕類型 --%>
						var type_ = $(this).data('type');
						//<%-- 執行的 key --%>
						var key_ = $(this).data('account_id');
						var url = "${pageContext.request.contextPath}/IDSearchServelt";
						//<%-- 取得此次操作的相關資料 --%>
						action_windows(key_,url,type_);
					});	
				}
			//製作DataTable
			function submit_table(result,tablename){
				var tableData="<table id='tbody'><thead><tr>";
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/ShowColServelt",
		            dataType:"json",
		            async: false,
		            data: {
		            	tablename : tablename
		            	},
		            //<%-- 回傳成功 --%>
		            success: function(colnames){
		            	var colr=[];
		            	for(var i=0;i<colnames.length;i++){
		        			if(colnames[i].ShowCol_E.indexOf('Product')==0){
			            		tableData+="<th>"+colnames[i].ShowCol_C+"</th>";
			            		colr.push(colnames[i].ShowCol_E);
			            		}
		        			
		                }
		            	tableData+="<th>瀏覽</th>"
		            	tableData+="<th>歷程</th>"
		            	tableData+="<th>修改</th>"
		            	tableData+="<th>刪除</th>"
						tableData+="</tr></thead><tbody>";
		            },
		            //<%-- 回傳失敗 --%>
		            error:
		                function(xhr, ajaxOptions, thrownError){
		                    alert(xhr.status+"\n"+thrownError);
		                }
				});
				
				var obj = JSON.parse(result);//解析json字串為json物件形式
				for(var i=0;i<obj.length;i++){
				tableData+="<tr>"
					tableData+="<td>"+obj[i].Product_ID+"</td>"
					tableData+="<td>"+obj[i].Product_Name+"</td>"
					tableData+="<td>"+obj[i].Product_Price+"</td>"
					tableData+="<td>"+obj[i].Product_Detail+"</td>"
					tableData+="<td>"+obj[i].Product_Quanity+"</td>"
					tableData+="<td>"+'<a title="查詢" class="account_action" data-account_id="' + obj[i].Product_ID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="歷程" class="account_action" data-account_id="' + obj[i].Product_ID + '" data-type="log">' + 
					'<i class="fa fa-history fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="修改" class="account_action" data-account_id="' + obj[i].Product_ID + '" data-type="update">' + 
					'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="刪除" class="account_action" data-account_id="' + obj[i].Product_ID + '" data-type="delete">' + 
					'<i class="fa fa-trash fa-2x"></i></a>'+"</td>"
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv").html(tableData);//運用html方法將拼接的table新增到tbody中return;
//				document.getElementById("insertuser").style.display = "block";
	    		}
			
			//找出欄位的值  ind=已有的vaule
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
			
			//判斷開啟哪種對話框
			function action_windows(key_,url,type_){
				var tablename;
				if(type_=="log"){
					tablename="ProductLog"
				}else{
					tablename="Product";
				}
				$.ajax({
					type:"post", 
					url: url,
					dataType:"json",
					data: {
						type:type_,
						tablename:tablename,
						id : key_
					},
					success: function(result){
						console.log(result);
						
						if($('.bootbox').length == 0){
							//<%-- 開啟對話框 --%>						
							action_page(type_,result);
						}
					},
					error: function(xhr, ajaxOptions, thrownError){
						alert(xhr.status+"\n"+thrownError);
					}
				});
			}
			//執行對話框內的動作
			function action(action_url,type_,form_data) {
				var doID ="${doID}"
				if(type_=="update"||type_=="delete"){//修改
					$.ajax({
						type:"post",
						url:action_url,
						datatype:"text",
						//contentType:"false",
						data:{
							tablename:"Product",
							type:type_,
							id:form_data.product_key,
							name:form_data.product_name,//getParameter(xx)
							price:form_data.product_price,
							detail:form_data.product_detail,
							quanity:form_data.product_quanity,
							vaild:form_data.product_vaild
						},
						success:function(result){
							if(result==1){
								alert('變更成功')
							}
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
			function action_page(type_,product_info){
				//<%-- 按鈕執行所照訪網址 --%>
				//<%-- 除了 log 以外的資料，不可能會有複數 --%>
				if(type_ != 'log'){
					//修改、刪除(DBUpdateServelt)
					product_info = product_info[0];
					action_url = "${pageContext.request.contextPath}/DBUpdateServelt";
				}else if(type_=='log'){
					product_info=product_info;

				}

				//<%-- 標題文字1 --%>
				var title_text = 
					(type_ == 'detail') ? '查詢 '+product_info.Product_Name+' ' : 
					(type_ == 'log') ? product_info.Product_Name+' 的更改記錄' : 
					(type_ == 'delete') ? (product_info.Product_Vaild == 1) ? '下架' : '重新上架' : 
					(type_ == 'update') ? '修改 '+product_info.Product_Name: '新增';
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
				if(type_ == 'delete' || type_ == 'update' || type_ == 'insert' || type_ == 'insert2'|| type_ == 'insertphs'){
					
					bootbox_buttons.save = {
						label: '<i class="fa fa-'+button_action_icon+' fa-2x"></i> ' + button_action_text,
						className: 'btn btn-sm btn-primary',
						callback:function(result){

							//<%-- 欄位驗證 --%>
							if(validate(type_)){
								//<%-- 設計傳送資料 --%>
								var form_data = {};
								if(type_ == "delete"){
									form_data.product_key = product_info.Product_ID;
									form_data.product_vaild = product_info.Product_Vaild;
								}else if(type_=="insert"||type_=='update'){
									//<%-- 新增 與 修改 只差在 key 值，所以寫在一起 --%>
									form_data.product_key = (type_ == "update") ?  product_info.Product_ID : 0;
									form_data.product_name = $("#product_name").val();
									form_data.product_price = $("#product_price").val();
									form_data.product_detail = $("#product_detail").val();
									form_data.product_quanity = $("#product_quanity").val();
									form_data.product_vaild = product_info.Product_Vaild;
								}
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
					var bootbox_title;
					if(type_== "detail"){
						bootbox_title="瀏覽商品資訊"
					}else if(type_== "update"){
						bootbox_title="修改商品資訊"
					}else if(type_== "delete"){
						bootbox_title="重新上架/下架商品"
					}else if(type_== "log"){
						bootbox_title="商品更改紀錄"
					}

					var message = get_bootbox_message(type_ , product_info);
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
					
					//alert(product_info)
					if(type_ == "update"){
						$("#product_name").val(product_info.Product_Name);//產品名稱
						$("#product_price").val(product_info.Product_Price); //產品$$
						$("#product_detail").val(product_info.Product_Detail);//細節說明
						$("#product_quanity").val(product_info.Product_Quanity);//細節說明
				}
			}
			//製作對話框內容
			function get_bootbox_message(type_,product_info){
				
				//<%-- 對話框內容 --%>
				var message = "";
				//<%-- 刪除 --%>
				if(type_ == "delete"){
					message = '<span class="note"> ' + ' [ <span class="bold"> '+ product_info.Product_Name +' </span> ]  </span>';
				//<%-- 操作紀錄 --%>
				}else if(type_ == "log"){
					//<%-- class="pre-scrollable" 會顯示 Y 軸的卷軸 --%>
					message = '<div>';
					if(product_info.length==0){
						alert(product_info.length)
						message += '<h6> 尚未有任何變更紀錄 </h6>';
					}else{
						for(var key in product_info){
							message+='<h6> ● ' +product_info[key].ProductLog_Time.substring(0,16)+ product_info[key].ProductLog_Event + '</h6>';
							}
					}
					message += '</div>';
					
				//<%-- 詳細資料 --%>
				}else if(type_ == "detail"){
					message = '<div id="testinfo" style="float: left;width: 400px;">'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">產品名稱:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Name + '</div>' +
									'</div>' +
								'</div>'+	
								'<div class="profile-user-info profile-user-info-striped">' +	
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">產品價錢:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Price + '</div>' +
									'</div>' +
								'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">細節說明:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Detail+ '</div>' +
									'</div>' +
								'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品數量:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Quanity+ '</div>' +
									'</div>' +
								'</div>' +
							'</div>'+
							'<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel"style="width: 300px; height: 300px;float: right;">'+show_phs(product_info.Product_ID,product_info.Product_SellerID)+'</div>';
							
				//<%-- csv --%>
				}else{
					message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">產品名稱 :</div>' +
										'<div class="profile-info-value">' + 
										'<input type="text" class="form-control" id="product_name" name="input_product_name" placeholder="請輸入名稱" />' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">產品價錢 :</div>' +
										'<div class="profile-info-value">' +
											'<input type="text" class="form-control" id="product_price" name="input_product_price" placeholder="請輸入價錢" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">細節說明 :</div>' +
										'<div class="profile-info-value">' +
											'<textarea class="form-control" id="product_detail" name="input_product_detail" placeholder="請輸入細節說明" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">數量:</div>' +
										'<div class="profile-info-value">' +
											'<input type="text" class="form-control" id="product_quanity" name="input_product_quanity" placeholder="請輸入數量" />' +
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
				//<%-- product_name 物件 --%>
				var product_name = $("#product_name");
				//<%-- product_price 物件 --%>
				var product_price = $("#product_price");
				//<%-- product_detail 物件 --%>
				var product_detail = $("#product_detail");
				
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
			function show_phs(prdID,sellerID){//取得該產品的照片檔名
				var doID="${doID}";
				var carousel_data;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/GetPrdPhsServlet",
		            dataType:"json",
		            async: false,
		            data: {
		            	prdID:prdID,
		            	doID:doID,
		            	sellerID:sellerID,
		            	tablename : 'Product',
		            	},
		            //<%-- 回傳成功 --%>
		            success: function(result){
		            	var doID="${doID}";
						var i;
						var storepath='${pageContext.servletContext}/upload/Product/';
						
						carousel_data='<ol class="carousel-indicators" ><li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>';
						for(i=0;i<result.length-1;i++){
						carousel_data+='<li data-target="#carouselExampleIndicators" data-slide-to="'+(i+1)+'"></li>'
					        };
					    carousel_data+= '</ol><div class="carousel-inner">'    
					    for(i=0;i<1;i++){
								$.each(result[i], function(index, value) {
									carousel_data+='<div class="carousel-item active">'+
								      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+doID+'/'+value+'"alt="First slide">'+
								    '</div>'
						    });    
					    }
						for(i=1;i<result.length;i++){
							$.each(result[i], function(index, value) {
								carousel_data+= '<div class="carousel-item">'+
							      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+doID+'/'+value+'"alt="First slide">'+
							    '</div>'
					        });
						}
						carousel_data+= '</div>'+
									  '<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">'+
									    '<span class="carousel-control-prev-icon" aria-hidden="true" style="background-image:url(images/icons/back.png);">'+'</span>'+
									    '<span class="sr-only">'+'</span>'+
									  '</a>'+
									  '<a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">'+
									    '<span class="carousel-control-next-icon" aria-hidden="true" style="background-image:url(images/icons/next.png);">'+'</span>'+
									    '<span class="sr-only">'+'</span>'+
									  '</a>'
								 $("#carouselExampleIndicators").html(carousel_data);
		            },
		            //<%-- 回傳失敗 --%>
		            error:
		                function(xhr, ajaxOptions, thrownError){
		                    alert(xhr.status+"\n"+thrownError);
		                }
				});
				return carousel_data;
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
						商品管理
					</span>
					
					<div class="wrap-input100 validate-input"  style="float: left; position: relative;left: 50%; transform: translate(-50%,0px); width: auto !important;">
						<input class="input100" id="prdnameinput" type="text" name="user" placeholder="商品名稱">
						<span class="focus-input100" id="prdfocus" data-placeholder="&#xf207;"></span>
						<span id="prdnameempty" style="color: red;top: 50px;position: absolute;"></span>

					</div>
					<button class="login100-form-btn" id="searchname" style="position: relative;left: 50%; transform: translate(-50%,0px);font-family:HanyiSentyGarden;">搜尋</button>
				</form>
			</div>
			<div id="testdiv" style="margin-left: 20px;"></div>	  

</body>


</html>