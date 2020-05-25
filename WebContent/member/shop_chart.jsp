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
	<!--<script src="js/jquery.js"></script>-->
	<!--<script src="js/datatables.min.js"></script>-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script src="js/bootbox.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/jquery.dataTables.bootstrap.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<script type="text/javascript">
	window.onload=function(){
		shop_chart();
		sidemenu();
	};
	function getlabel(){
		var arr='';
		var doID ="${doID}"
		$.ajax({
			type:"post", 
			url: "${pageContext.request.contextPath}/ChartServlet",
			dataType:"json",
			async: false,
			data: {
				tablename:'Shop',
				doID : doID
			},
			success: function(result){
				
				arr+=result[0].Shop_Name;
				for(var i=1;i<result.length;i++){
					arr+=","+result[i].Shop_Name;
				}
				
			},
			error: function(xhr, ajaxOptions, thrownError){
				alert(xhr.status+"\n"+thrownError);
			}
		});
		return arr
	}
	function getdata(){
		var arr='';
		var total=0;
		var qua=[];
		var doID ="${doID}"
		$.ajax({
			type:"post", 
			url: "${pageContext.request.contextPath}/ChartServlet",
			dataType:"json",
			async: false,
			data: {
				tablename:'Shop',
				doID : doID
			},
			success: function(result){
				qua.push(result[0].TotalQuanity);
				for(var i=1;i<result.length;i++){
					qua.push(result[i].TotalQuanity);
				}
			},
			error: function(xhr, ajaxOptions, thrownError){
				alert(xhr.status+"\n"+thrownError);
			}
		});
		return qua
	}
	function get_interval(arr_quanity){
		var total=0;
		var doID ="${doID}"
		$.ajax({
			type:"post", 
			url: "${pageContext.request.contextPath}/ChartServlet",
			dataType:"json",
			async: false,
			data: {
				tablename:'Shop',
				doID : doID
			},
			success: function(result){
				total=parseInt(result[0].TotalQuanity);
				for(var i=1;i<result.length;i++){
					total+=parseInt(result[i].TotalQuanity);
				}
			},
			error: function(xhr, ajaxOptions, thrownError){
				alert(xhr.status+"\n"+thrownError);
			}
		});
		var high=0;
		var mid=0;
		var low=0;
		var backgroundColor='';
		high=(total/4)*3;
		mid=(total/4)*2;
		low=(total/4)*1;
		var interval=[high,mid,low]
		
		backgroundColor+='rgba(255, 99, 132, 0.2)';
		//console.log(backgroundColor)
		for(var i=1;i<arr_quanity.length;i++){
			if(i<(arr_quanity.length/3)*1){
				backgroundColor+='|rgba(255, 99, 132, 0.2)';//pink
			}else if(i<(arr_quanity.length/3)*2 && i>=(arr_quanity.length/3)*1){
				backgroundColor+='|rgba(54, 162, 235, 0.2)';//blue
			}else if(i=>(arr_quanity.length/3)*2){
				backgroundColor+='|rgba(255, 206, 86, 0.2)';//yellow
			}
		}
		return backgroundColor;
	}
	function shop_chart(){
		var ctx = document.getElementById('myChart').getContext('2d');
		var chart = new Chart(ctx, {
		    type: 'bar',
		    data: {
		        datasets: [{
		            label: '本月銷量',
		            data: getdata(),
		            backgroundColor:get_interval(getdata()).split('|')
		        }],
		        labels: getlabel().split(',')
		    },
		    options: {
		        scales: {
		            yAxes: [{
		                ticks: {
		                    suggestedMin: 0
		                }
		            }]
		        }
		    }
		});
		$('#close_chart').click(function(){
	    	$('#prd_chart').slideToggle("slow");
	    	$('#control_i').attr('class','fa fa-angle-double-down fa-2x')
		});
		var doID ="${doID}"	
			    $.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/ChartServlet",
					datatype:"json",
					//contentType:"false",
					data:{
						tablename:'`OrderItem`,`Product`',
						doID:doID
					},
					success:function(result){
		            	//submit_table(result);
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
				                targets: [3], //設定第n欄不進行排序功能
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
			//製作DataTable
			function submit_table(result,dolevel){
				var obj = JSON.parse(result);//解析json字串為json物件形式
				if(result.length==0){
					var tableData= '<th>目前無訂單紀錄</th>';
					$("#tbody").html(tableData);
				}else{
					var tableData="<table id='tbody'>"+"<thead><tr><th>訂單編號</th><th>商品名稱</th><th>訂購數量</th><th>訂單內容</th></tr></thead><tbody>"
				}
				for(var i=0;i<obj.length;i++){
				tableData+="<tr>"
					tableData+="<td>"+obj[i].OrderList_ComID+"</td>"
					tableData+="<td>"+obj[i].Product_Name+"</td>"
					tableData+="<td>"+obj[i].OrderItem_Quanity+"</td>"
					tableData+="<td>"+'<a title="查詢" class="account_action" data-account_id="' + obj[i].OrderList_ID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv").html(tableData);
	    		
			}
			function action_function(){
				$('.account_action').on('click',function(){
					var type_ = $(this).data('type');
					var key_ = $(this).data('account_id');
					var url = "${pageContext.request.contextPath}/OrderItemSearchServelt";
					action_windows(key_,url,type_);
				});	
			}
			//判斷開啟哪種對話框
			function action_windows(key_,url,type_){
					$.ajax({
						type:"post", 
						url: url,
						dataType:"json",
						data: {
							tablename:'OrderList',
							id : key_,
							type:type_
						},
						success: function(result){
							console.log(result)
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
			
			//設計對話框樣式
			function action_page(type_,orderlist_info){
				console.log(orderlist_info)

				//<%-- 標題文字1 --%>
				var title_text =  '查詢 '+orderlist_info.OrderList_ComID+' 的訂單內容' 
				<%-- 按鈕圖示 --%>
				var button_action_icon = 'check' ;
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
					bootbox_buttons.cancel = {
							label: '<i class="fa fa-times fa-2x"></i> 關閉',
							className: 'btn btn-sm btn-danger',
							callback:function(){
							}
					}
					var bootbox_title="瀏覽訂單資訊"
					var message = get_bootbox_message(type_ , orderlist_info);
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
			}
			
			//製作對話框內容
			function get_bootbox_message(type_,orderlist_info){
				//<%-- 對話框內容 --%>
				var message = "";
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
				
				return message;
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
						商店銷售報表
					</span>
					<button id="close_chart" style="margin-bottom: 5px;color: white;position: relative;left: 70%;">
					<i id="control_i" class="fa fa-angle-double-up fa-2x"></i>
					</button>
					<div id="prd_chart" style="position: relative;width: 1000px;height:500px;left: 50%;transform: translate(-50%,0px);">
					<canvas id="myChart" style="background-color: white;"></canvas>
					</div>
				</form>
			</div>
			<div id="testdiv" style="margin-left: 20px;"></div>	  

</body>

</html>