<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>

<head>
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/userview.css">
	<link rel="stylesheet" type="text/css" href="css/datatables.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
	<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<!--===============================================================================================-->
<!--	 <script src="js/jquery.js"></script> 
		<script src="js/datatables.min.js"></script>-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="js/jquery.ui.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script src="js/bootbox.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
	<script type="text/javascript">
	window.onload=function(){
		orderview();
		sidemenu();
	};
	function orderview(){
		var dolevel ="${level}"
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
			         
		
		var startdate=""
		var enddate=""
		var doID ="${doID}"
		$('input[name="datefilter"]').daterangepicker({
		      autoUpdateInput: false,
		      locale: {
		    	  applyLabel: '確認',
		          cancelLabel: '清空'
		      }
		  });
		
		  $('input[name="datefilter"]').on('apply.daterangepicker', function(ev, picker) {
		      $(this).val(picker.startDate.format('YYYY-MM-DD') + '-' + picker.endDate.format('YYYY-MM-DD'));
		    startdate=picker.startDate.format('YYYY-MM-DD');
		  	enddate=picker.endDate.format('YYYY-MM-DD');
		  });

		  $('input[name="datefilter"]').on('cancel.daterangepicker', function(ev, picker) {
		      $(this).val('');
		    startdate="";
		  	enddate="";
		  });
		  
			$('#searchname').on("click",function(){
		    $.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/OrderListSearchServelt",
				datatype:"json",
				//contentType:"false",
				data:{
					startdate:startdate,
					enddate:enddate,
					doID:doID,
					level:'search'
				},
				success:function(result){
//					console.log(targets);
	            	submit_table(result,"OrderList");
					
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
			                targets: [4,5,6,7], //設定第n欄不進行排序功能
			                orderable: false,
			            }],
			            "drawCallback":action_function(startdate,enddate)  
					});
					
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
				
		    return false;  
		});
		}
			
			function action_function(startdate,enddate){
					$('.order_action').on('click',function(){
						var type_ = $(this).data('type');
						var key_ = $(this).data('orderlist_id');
						var url = "${pageContext.request.contextPath}/OrderItemSearchServelt";
						action_windows(key_,url,type_,startdate,enddate);
					});	
				}
			//製作DataTable
			function submit_table(result,tablename){
				var colnum=0;
				var colr=[];
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
		            	
		        		for(var i=0;i<colnames.length;i++){
		        			if(colnames[i].ShowCol_E.indexOf('OrderList_')==0&&colnames[i].ShowCol_E!='OrderList_ComID'){
			            		tableData+="<th>"+colnames[i].ShowCol_C+"</th>";
			            		colr.push(colnames[i].ShowCol_E);
			            		}
		        			
		                }
						
		            	//tableData+="<th>OrderList_TotalPrice</th>"
		            	//tableData+="<th>OrderList_State</th>"
		            	tableData+="<th>瀏覽</th>"
		            	tableData+="<th>歷程</th>"
		            	tableData+="<th>提出修改訂單要求</th>"
		            	tableData+="<th>提出取消訂單要求</th>"
						tableData+="</tr></thead><tbody>";
						//make_table(result,tableData,colr)
		            },
		            //<%-- 回傳失敗 --%>
		            error:
		                function(xhr, ajaxOptions, thrownError){
		                    alert(xhr.status+"\n"+thrownError);
		                }
				});
			

//				const tt = obj.map(item => Object.values(item)[1]);
//				console.log(tt)
				var jsonObj = JSON.parse(result);//解析json字串為json物件形式
				var obj = Object.keys(jsonObj).map(function(_) { return jsonObj[_]; });
				var arr=Object.values(jsonObj);
				const idList = arr.map(item => Object.keys(item)[0]);
				//console.log(arr)
				for(var i=0;i<=colr.length;i++){
        			for(var j=0;j<arr.length;j++){
        				const idList = arr.map(item => Object.keys(item)[i]);
	                }
        			
                }
				for(var i=0;i<=arr.length;i++){
        			const idList = arr.map(item => Object.keys(item)[i]);
        			for(var j=0;j<colr.length;j++){
	                }
        			
                }
				console.log(obj)
				for(var i=0;i<obj.length;i++){
				tableData+="<tr>"
					tableData+="<td>"+obj[i].OrderList_ShopName+"</td>"
					tableData+="<td>"+obj[i].OrderList_OrderDate+"</td>"
					tableData+="<td>"+obj[i].OrderList_TotalPrice+"</td>"
					tableData+="<td>"+GetColVal("OrderState","OrderState_Value","OrderState_Detail",obj[i].OrderList_State)+"</td>"
					tableData+="<td>"+'<a title="查詢" class="order_action" data-orderlist_id="' + obj[i].OrderList_ID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="歷程" class="order_action" data-orderlist_id="' + obj[i].OrderList_ID + '" data-type="log">' + 
					'<i class="fa fa-history fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="修改" class="order_action" data-orderlist_id="' + obj[i].OrderList_ID + '" data-type="update">' + 
					'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="刪除" class="order_action" data-orderlist_id="' + obj[i].OrderList_ID + '" data-type="delete">' + 
					'<i class="fa fa-trash fa-2x"></i></a>'+"</td>"
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv").html(tableData);//運用html方法將拼接的table新增到tbody中return;
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
			function action_windows(key_,url,type_,startdate,enddate){
				var tablename;
				if(type_=="log"){
					tablename="OrderListLog"
					url = "${pageContext.request.contextPath}/IDSearchServelt";
				}else{
					tablename="OrderList";
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
						if($('.bootbox').length == 0){
							//<%-- 開啟對話框 --%>
							if(open_bootbox(type_,result)){
							action_page(type_,result,startdate,enddate)}
						}
					},
					error: function(xhr, ajaxOptions, thrownError){
						alert(xhr.status+"\n"+thrownError);
					}
				});
			}
			//執行對話框內的動作
			function action(action_url,type_,orderlist_info,startdate,enddate) {
				var doID ="${doID}"
				if(type_=='update'){
					var formData = new FormData(form_orderlist);
					formData.append("doID", doID);
					formData.append("OID", orderlist_info[0].OrderList_ID);
					formData.append("type", type_);
					formData.append("startdate", startdate);
					formData.append("enddate", enddate);
					for(var i=0;i<orderlist_info.length;i++){
						formData.append("PID", orderlist_info[i].OrderItem_PID);
					}
					for(var i=0;i<orderlist_info.length;i++){
						if(orderlist_info[i].ProductStyle_Vaule=='F'){
							formData.append("SID", orderlist_info[i].ProductStyle_ID);

						}else{
							formData.append("SID", getradiovalue('radio_'+orderlist_info[i].ProductStyle_PID));

						}
					}
					for(var i=0;i<orderlist_info.length;i++){
						formData.append("SVAL", orderlist_info[i].ProductStyle_Vaule);
					}
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/OrderListUpdateServelt",
						datatype:"text",
						processData: false,
						contentType:false,
						cache : false,
						data:formData,
						async: false,
						success:function(result){
							if(result=='1'){
								bootbox.alert({
								    message: "已送出請求",
								    callback: function () {
								    	location.reload();
								    }
								})
							}else if(result=='-1'){
								bootbox.alert({
								    message: "請您直接提出刪除訂單需求",
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
				}else{
					var formData2 = new FormData();
					formData2.append("doID", doID);
					formData2.append("ComID", orderlist_info[0].OrderList_ComID);
					formData2.append("OID", orderlist_info[0].OrderList_ID);
					formData2.append("type", type_);
					formData2.append("cancel_detail", $("#cancel_detail").val());
					formData.append("startdate", startdate);
					formData.append("enddate", enddate);
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/OrderListUpdateServelt",
						datatype:"text",
						processData: false,
						contentType:false,
						cache : false,
						data:formData2,
						async: false,
						success:function(result){
							if(result==1){
								bootbox.alert({
								    message: "已送出請求",
								    callback: function () {
								    	location.reload();
								    }
								})
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
			function open_bootbox(type_,orderlist_info){
				var pass=true;
				if(type_=='update'||type_=='delete'){
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/IDSearchServelt",
						datatype:"json",
						async: false,
						data:{
							id:orderlist_info[0].OrderList_ID,
							tablename:'OrderListUpdateDESC'
						},
						success:function(result){
							var obj = JSON.parse(result);
							console.log('open_bootbox')
							if(obj[0].OrderListUpdate_State==0){
								pass=false;
								bootbox.alert({
								    message: "您先前提出的申請上尚未被賣家裁決，請等待賣家回復再提出其他變更申請",
								    callback: function () {
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
				
			return pass;
			}
			//設計對話框樣式
			function action_page(type_,orderlist_info,startdate,enddate){
				
				orderlist_info=orderlist_info;
				if(type_ == 'delete'||type_ == 'update'){
					action_url = "${pageContext.request.contextPath}/OrderListUpdateServelt";
				}else if(type_=='log'){
				}
				console.log(orderlist_info)
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
				if(type_ == 'delete' || type_ == 'update'){
					
					bootbox_buttons.save = {
						label: '<i class="fa fa-check fa-2x"></i>送出',
						className: 'btn btn-sm btn-primary',
						callback:function(result){
							if(validate(type_)){
								//<%-- 設計傳送資料 --%>
								var form_data = {};
								if(type_ == "delete"){
									form_data.orderlist_key = orderlist_info.OrderList_ID;
								}else{
									//<%-- 新增 與 修改 只差在 key 值，所以寫在一起 --%>
									form_data.orderlist_key = orderlist_info.OrderList_ID;
									form_data.orderlist_prdname = $("#orderlist_prdname");
									form_data.orderlist_quanity = $("#quanity").val();
									form_data.orderlist_vaild = orderlist_info.OrderList_Vaild;
								}
								form_data.type = type_;
								//<%-- 執行 --%>
								action(action_url,type_,orderlist_info,startdate,enddate);
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
						bootbox_title="瀏覽訂單資訊"
					}else if(type_== "update"){
						bootbox_title="填寫修改內容"
					}else if(type_== "delete"){
						bootbox_title="填寫取消訂單原因"
					}else if(type_== "log"){
						bootbox_title="訂單修改紀錄"
					}
						var message = get_bootbox_message(type_ , orderlist_info);
						bootbox.dialog({
							className: "medium",
							title: '<h3 class="smaller lighter no-margin blue">'+bootbox_title+'</h3>',
							message:message,
							buttons: bootbox_buttons,
							closeButton: false
						});
					
					var ori_q=$('#quanity').val();
					
					$("input[name='delete_prd']").change(function() {
					      if(this.checked) {
					    	  var id=$(this).attr('id').substring($(this).attr('id').indexOf('d_')+2)
					    	  var name=$('#orderlist_prdname_'+id).text()
					    	  $('#orderlist_prdname_'+id).html(name+'<br>原數量'+$('#quanity_'+id).val())
					    	  $('#quanity_'+id).attr('disabled',false)
					    	  }
					});
					for(var i=0;i<orderlist_info.length;i++){
						$("input[name*='radio_']").each(function(){
							var sid=$(this).attr('value')
							if(orderlist_info[i].ProductStyle_ID==sid){
								console.log(orderlist_info[i].ProductStyle_ID)
								$(this).attr('checked',true)}
							});
					}
					//alert(orderlist_info)
					if(type_ == "update"){
						$("#orderlist_name").val(orderlist_info.Orderlist_Name);//產品名稱
						$("#orderlist_price").val(orderlist_info.Product_Price); //產品$$
						$("#orderlist_detail").val(orderlist_info.Product_Detail);//細節說明
						$("#orderlist_quanity").val(orderlist_info.Product_Quanity);//細節說明
					}
					
			}
			function getradiovalue(rdname){
				console.log(rdname);
				var val=0;
					$("input:radio[name='"+rdname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
							val=$(this).attr('value')
							}
						});
				console.log(val);
			 return val;	
			}
			
			//製作對話框內容
			function get_bootbox_message(type_,orderlist_info){
				
				//<%-- 對話框內容 --%>
				var message = "";
				 if(type_ == "log"){
					//<%-- class="pre-scrollable" 會顯示 Y 軸的卷軸 --%>
					message = '<div>';
					if(orderlist_info.length==0){
						message += '<h6> 尚未有任何變更紀錄 </h6>';
					}else{
						for(var key in orderlist_info){
							message+='<h6 style="white-space: pre-line;"> ● ' +orderlist_info[key].OrderListLog_Time.substring(0,16)+ orderlist_info[key].OrderListLog_Event + '</h6>';
							}
					}
					message += '</div>';
					
				//<%-- 詳細資料 --%>
				}else if(type_ == "detail"){
					console.log(orderlist_info)
					if(orderlist_info.length>1){
					message += '<div id="testinfo" style="float: left;width: 400px;">'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">下單日期:</div>' +
										'<div class="profile-info-value">' + orderlist_info[0].OrderList_OrderDate + '</div>' +
									'</div>' +
								'</div>'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">收件人姓名:</div>' +
										'<div class="profile-info-value">' + orderlist_info[0].OrderList_UName + '</div>' +
									'</div>' +
								'</div>'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">收件地址:</div>' +
										'<div class="profile-info-value">' + orderlist_info[0].OrderList_UAddress + '</div>' +
									'</div>' +
								'</div>'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">手機號碼:</div>' +
										'<div class="profile-info-value">' + orderlist_info[0].OrderList_UPhone + '</div>' +
									'</div>' +
								'</div>'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">電子郵件:</div>' +
										'<div class="profile-info-value">' + orderlist_info[0].OrderList_UEmail + '</div>' +
									'</div>' +
								'</div>'+
								'<div class="profile-user-info profile-user-info-striped">' +	
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">訂單金額:</div>' +
										'<div class="profile-info-value">' + orderlist_info[0].OrderList_TotalPrice + '</div>' +
									'</div>' +
									'<div class="profile-info-name">購買商品 :</div>'
					for(var i=0;i<orderlist_info.length;i++){
						message +='<div class="profile-info-value">' + orderlist_info[i].Product_Name +' 款式 '+orderlist_info[i].ProductStyle_Vaule +'×'+ orderlist_info[i].OrderItem_Quanity +'</div>'
					}				
						message +='</div>'
					}else{
						message = '<div id="testinfo" style="float: left;width: 400px;">'+
						'<div class="profile-user-info profile-user-info-striped">' +
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">下單日期:' + orderlist_info[0].OrderList_OrderDate + '</div>' +
							'</div>' +
						'</div>'+
							'<div class="profile-user-info profile-user-info-striped">' +
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">收件人姓名:' + orderlist_info[0].OrderList_UName + '</div>' +
							'</div>' +
						'</div>'+
						'<div class="profile-user-info profile-user-info-striped">' +
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">收件地址:' + orderlist_info[0].OrderList_UAddress + '</div>' +
							'</div>' +
						'</div>'+
						'<div class="profile-user-info profile-user-info-striped">' +
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">手機號碼:' + orderlist_info[0].OrderList_UPhone + '</div>' +
							'</div>' +
						'</div>'+
						'<div class="profile-user-info profile-user-info-striped">' +
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">電子郵件:' + orderlist_info[0].OrderList_UEmail + '</div>' +
							'</div>' +
						'</div>'+
						'<div class="profile-user-info profile-user-info-striped">' +	
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">訂單金額:' + orderlist_info[0].OrderList_TotalPrice + '</div>' +
							'</div>' +
						'<div class="profile-user-info profile-user-info-striped">' +
							'<div class="profile-info-row">' +
								'<div class="profile-info-name">購買商品 :</div>'+
								'<div class="profile-info-value">' + orderlist_info[0].Product_Name +'×'+orderlist_info[0].OrderItem_Quanity +  '</div>' +
							'</div>' +
						'</div>'	
					}
				}else if(type_ == "update"){
					message = 	'<form id="form_orderlist" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">購買商品 :</div>'
										for(var i=0;i<orderlist_info.length;i++){
											if(orderlist_info[i].ProductStyle_Vaule=='F'){
									message +='</div>'+
												'<div class="profile-info-value"style="float:left"id="orderlist_prdname_'+orderlist_info[i].Product_ID+'">' + orderlist_info[i].Product_Name +' 款式 '+ orderlist_info[i].ProductStyle_Vaule +'</div>'+	
												'<input type="text" class="form-control" name="quanity" id="quanity_'+orderlist_info[i].Product_ID+'" value='+orderlist_info[i].OrderItem_Quanity+'>'				
											}else{
									message +='</div>'+
												'<div class="profile-info-value"style="float:left"id="orderlist_prdname_'+orderlist_info[i].Product_ID+'">' + orderlist_info[i].Product_Name +' 款式   </div>'+						
												submit_radio(getstyle(orderlist_info[i].Product_ID),"radio_"+orderlist_info[i].Product_ID)+
												'<input type="text" class="form-control" name="quanity" id="quanity_'+orderlist_info[i].Product_ID+'" value='+orderlist_info[i].OrderItem_Quanity+'>'
											}
										}
					message +=			'<div class="profile-info-name">收件人 :</div>'+
										'<div class="profile-info-value">' +
										'<input type="text" class="form-control" name="uname" id="uname"value='+ orderlist_info[0].OrderList_UName +'>' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>'+
										'<div class="profile-info-name">地址 :</div>'+
										'<div class="profile-info-value">' +
										'<input type="text" class="form-control" name="uaddress" id="uaddress"value='+ orderlist_info[0].OrderList_UAddress +'>' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>'+
										'<div class="profile-info-name">手機:</div>'+
										'<div class="profile-info-value">' +
										'<input type="text" class="form-control" name="uphone" id="uphone" value='+ orderlist_info[0].OrderList_UPhone +'>' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>'+
										'<div class="profile-info-name">電子郵件:</div>'+
										'<div class="profile-info-value">' +
										'<input type="text" class="form-control" name="uemail" id="uemail" value='+ orderlist_info[0].OrderList_UEmail +'>' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>'+
									'</div>' +
								'</div>' +
							'</form>'; 
				}else if(type_ == "delete"){
					if(orderlist_info.length>1){
						message += '<div id="testinfo" style="float: left;width: 400px;">'+
									'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">下單日期:</div>' +
											'<div class="profile-info-value">' + orderlist_info[0].OrderList_OrderDate + '</div>' +
										'</div>' +
									'</div>'+	
									'<div class="profile-user-info profile-user-info-striped">' +	
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">訂單金額:</div>' +
											'<div class="profile-info-value">' + orderlist_info[0].OrderList_TotalPrice + '</div>' +
										'</div>' +
										'<div class="profile-info-name">購買商品 :</div>'
						for(var i=0;i<orderlist_info.length;i++){
							message +='<div class="profile-info-value">' + orderlist_info[i].Product_Name +'×'+ orderlist_info[i].OrderItem_Quanity +'</div>'
						}				
							message +='</div>'
						}else{
							message = '<div id="testinfo" style="float: left;width: 400px;">'+
							'<div class="profile-user-info profile-user-info-striped">' +
								'<div class="profile-info-row">' +
									'<div class="profile-info-name">下單日期:</div>' +
									'<div class="profile-info-value">' + orderlist_info[0].OrderList_OrderDate + '</div>' +
								'</div>' +
							'</div>'+	
							'<div class="profile-user-info profile-user-info-striped">' +	
								'<div class="profile-info-row">' +
									'<div class="profile-info-name">訂單金額:</div>' +
									'<div class="profile-info-value">' + orderlist_info[0].OrderList_TotalPrice + '</div>' +
								'</div>' +
								'<div class="profile-info-name">購買商品 :</div>'+
								'<div class="profile-info-value">' + orderlist_info[0].Product_Name +'×'+orderlist_info[0].OrderItem_Quanity +  '</div>' +
								'</div>'	
						}
						message +='<div class="profile-info-row">' +
								'<div class="profile-info-name">原因說明 :</div>' +
								'<div class="profile-info-value">' +
									'<textarea class="form-control" id="cancel_detail" name="input_cancel_detail" placeholder="請輸入原因" />' +
									'<span class="red error" style="color: red;"></span>' +
								'</div>' +
							'</div>' 
				}
				return message;
			}
			function submit_radio(result,idname){
				var radioData="";
				$.each(result[0], function(index, value) {
					radioData+='<input type="radio" id="'+idname+index+'" name="'+idname+'"value="'+index+'">'+value;
				});
	    		radioData+='<br>'+'<span class="red error" style="color: red;"></span>'
	    		return radioData
			}
			function getstyle(pid){
				var style={}
				var message=""
				
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/GetColValSearchServelt",
		            dataType:"json",
		            async: false,
		            data: {
		            	//<%-- 使用者帳號 --%>
		            	pid : pid,
		            	tablename:'ProductStyle',
		            	colname1:'ProductStyle_ID',
		            	colname2:'ProductStyle_Vaule'
		            },
		            success: function(result){
		            	style=result
		            },
		            error:
		                function(xhr, ajaxOptions, thrownError){
		                    alert(xhr.status+"\n"+thrownError);
		                }
				});
				return style;
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
				//<%-- orderlist_name 物件 --%>
				var cancel_detail = $("#cancel_detail");
				var uname = $("#uname");
				var uaddress = $("#uaddress");
				var uphone = $("#uphone");
				var uemail = $("#uemail");
				//<%-- 此處會有三種 type 新增、修改、刪除，刪除只需要執行再次確認的畫面即可，所以不需要執行欄位驗證 --%>
				switch (type_){
					case "delete":
						if(rule.test(cancel_detail.val())){
							cancel_detail.siblings('.error').text('');
						}else{
							cancel_detail.siblings('.error').text('請輸入原因');
							return_boolean = false;
						}
						break;
					case "update":
						if(rule.test(uname.val())){
							uname.siblings('.error').text('');
						}else{
							uname.siblings('.error').text('請輸入收件人姓名');
							return_boolean = false;
						}
						if(rule.test(uaddress.val())){
							uaddress.siblings('.error').text('');
						}else{
							uaddress.siblings('.error').text('請輸入地址');
							return_boolean = false;
						}
						if(rule.test(uphone.val())){
							uphone.siblings('.error').text('');
						}else{
							uphone.siblings('.error').text('請輸入手機');
							//account_password1.siblings('.error').append('請輸入密碼append');
							return_boolean = false;
						}
						if(rule.test(uemail.val())){
							uemail.siblings('.error').text('');
						}else{
							uemail.siblings('.error').text('請輸入電子郵件');
							return_boolean = false;
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
<style>
.daterangepicker {
	background-color: #a5d6a7 !important;
}
.calendar-table{
	background-color: #a5d6a7 !important;
}
.daterangepicker ltr show-calendar opensleft{
	background-color: #a5d6a7 !important;
}
.daterangepicker .calendar-table {
	border: 1px solid #a5d6a7 !important;
}
.daterangepicker td.active, .daterangepicker td.active:hover {
	background-color: #004d40;
}
.daterangepicker td.off, .daterangepicker td.off.in-range, .daterangepicker td.off.start-date, .daterangepicker td.off.end-date {
	background-color: transparent !important;
}
.table-condensed{
	color:black !important;
}
</style>

</head>
<body style="background-image: url('images/bgblack.png');">
<jsp:include page="../slidemenu.jsp"/>
		<div class="wrap-login100">
				<form class="login100-form validate-form" method="post">
					<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 70px;">
						訂單查詢
					</span>
					
					<div class="wrap-input100 validate-input"  style="float: left; position: relative;left: 50%; transform: translate(-50%,0px); width: auto !important;">
						<span style="color: white;">請選擇要查看的時間區間 ，若無則直接按搜尋</span><br>
						<input type="text" name="datefilter" value="" style="background: transparent;color: white;"/>
						<i class="fa fa-calendar"style="color:white;margin-right: 10px;float: left;"></i>
					</div>
					<button class="login100-form-btn" id="searchname" style="position: relative;left: 50%; transform: translate(-50%,0px);font-family:HanyiSentyGarden;">搜尋</button>
				</form>
			</div>
			<div id="testdiv" style="margin-left: 20px;"></div>	  

</body>


</html>