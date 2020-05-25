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
		var oag="${oag}"
		var startdate="${startdate}"
		var enddate="${enddate}"
		var doID ="${doID}"
		console.log(startdate+enddate)
      	$('body').css('background-image', 'linear-gradient(to right, rgba(38, 63, 110, 0.7),rgba(38, 63, 110, 0.7)),url("images/about-video.jpg")');
        $('body').css('background-size','100% 100%,100% 100%');
        if(startdate!="-1"){
        	$('input[name="datefilter"]').val(startdate+'-'+enddate);
        }
			$('input[name="datefilter"]').daterangepicker({
			      autoUpdateInput: false,
			      locale: {
			    	  applyLabel: "確認",
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
			
			if(oag=='mag'){
				 if(startdate=="-1"){
					  $.ajax({
							type:"post",
							url:"${pageContext.request.contextPath}/OrderListSearchServelt",
							datatype:"json",
							//contentType:"false",
							data:{
								startdate:'',
								enddate:'',
								doID:doID,
								level:'mag'
							},
							success:function(result){
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
						                targets: [3,4], //設定第n欄不進行排序功能
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
				  }else{
					  $.ajax({
							type:"post",
							url:"${pageContext.request.contextPath}/OrderListSearchServelt",
							datatype:"json",
							//contentType:"false",
							data:{
								startdate:'',
								enddate:'',
								doID:doID,
								level:'mag'
							},
							success:function(result){
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
						                targets: [3,4], //設定第n欄不進行排序功能
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
				  }
				$('#searchreq').remove();
				$('#read_req').remove();
				$('#label_read_req').remove();
				$('#searchorder').on("click",function(){
					$('#testdiv_title').css('display','')	
				    $.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/OrderListSearchServelt",
						datatype:"json",
						//contentType:"false",
						data:{
							startdate:startdate,
							enddate:enddate,
							doID:doID,
							level:'mag'
						},
						success:function(result){
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
					                targets: [3,4], //設定第n欄不進行排序功能
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
				
			}else{
				$('#searchorder').remove();
				$('#main_title').text('需求審核');
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/OrderListUpdateMagServelt",
					datatype:"json",
					data:{
						result:''
					},
					success:function(result){
						submit_table2(result,"OrderListUpdate");
						$('#tbody2').DataTable({
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
				                targets: [1,3,5,6,7], //設定第n欄不進行排序功能
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
			}
			$('#read_req:checkbox').change(function () {
				if($('#read_req:checkbox').prop('checked')){
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/OrderListUpdateMagServelt",
						datatype:"json",
						data:{
							startdate:startdate,
							enddate:enddate,
							result:'2'
						},
						success:function(result){
							submit_table2(result,"OrderListUpdate");
							$('#tbody2').DataTable({
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
					                targets: [1,3,5,6,7], //設定第n欄不進行排序功能
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
				}else{
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/OrderListUpdateMagServelt",
						datatype:"json",
						data:{
							startdate:startdate,
							enddate:enddate,
							result:''
						},
						success:function(result){
							submit_table2(result,"OrderListUpdate");
							$('#tbody2').DataTable({
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
					                targets: [1,3,5,6,7], //設定第n欄不進行排序功能
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
					
				}
			  });
			$('#searchreq').on("click",function(){
				var req
				if($('#read_req:checkbox').prop('checked')){
					req='2'
				}else{
					req=''
				}
			    $.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/OrderListUpdateMagServelt",
					datatype:"json",
					//contentType:"false",
					data:{
						startdate:startdate,
						enddate:enddate,
						result:req
					},
					success:function(result){
						submit_table2(result,"OrderListUpdate");
						$('#tbody2').DataTable({
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
				                targets: [1,3,5,6,7], //設定第n欄不進行排序功能
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
				var doID ="${doID}"
					$('.account_action').on('click',function(){
						var type_ = $(this).data('type');
						var key_ = $(this).data('orderlist_id');
						var url = "${pageContext.request.contextPath}/OrderItemSearchServelt";
						if(type_=='read'){
							var formData = new FormData();
							formData.append("OID",key_);
							formData.append("type", type_);
							formData.append("doID", doID);
							$('#read_icon'+key_).attr("class","fa fa-check-square fa-2x");
							$.ajax({
								type:"post", 
								url: "${pageContext.request.contextPath}/OrderListUpdateServelt",
								dataType:"text",
								processData: false,
								contentType:false,
								cache : false,
								data:formData,
								async: false,
								success: function(result){
									console.log(result)
								},
								error: function(xhr, ajaxOptions, thrownError){
									alert(xhr.status+"\n"+thrownError);
								}
							});
						}else{
							action_windows(key_,url,type_,startdate,enddate);}
					});
			}
			//訂單管理DT
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
		        			if(colnames[i].ShowCol_E.indexOf('OrderList_')==0){
		        				if(colnames[i].ShowCol_E=='OrderList_ShopName'){
		        					
		        				}else{
				            		tableData+="<th>"+colnames[i].ShowCol_C+"</th>";
				            		colr.push(colnames[i].ShowCol_E);
		        				}
			            	}
		                }
		            	tableData+="<th>瀏覽</th>"
		            	tableData+="<th>歷程</th>"
						tableData+="</tr></thead><tbody>";
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
        				//console.log(idList[0]+'  '+colr[i])
        				//console.log(idList[0]==colr[j])
	                }
        			
                }
				for(var i=0;i<=arr.length;i++){
        			const idList = arr.map(item => Object.keys(item)[i]);
        			for(var j=0;j<colr.length;j++){
        				//console.log(idList[0]+'  '+colr[j])
        				//console.log(idList[0]==colr[j])
	                }
        			
                }
				for(var i=0;i<obj.length;i++){
				tableData+="<tr>"
					tableData+="<td>"+obj[i].OrderList_ComID+"</td>"
					tableData+="<td>"+obj[i].OrderList_OrderDate+"</td>"
					tableData+="<td>"+obj[i].OrderList_TotalPrice+"</td>"
					tableData+="<td>"+GetColVal("OrderState","OrderState_Value","OrderState_Detail",obj[i].OrderList_State)+"</td>"
					tableData+="<td>"+'<a title="查詢" class="account_action" data-orderlist_id="' + obj[i].OrderList_ID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="歷程" class="account_action" data-orderlist_id="' + obj[i].OrderList_ID + '" data-type="log">' + 
					'<i class="fa fa-history fa-2x"></i></a>'+"</td>"
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv").html(tableData);//運用html方法將拼接的table新增到tbody中return;
	    		}
			//需求審核DT
			function submit_table2(result,tablename){
				var colnum=0;
				var colr=[];
				var tableData="<table id='tbody2'><thead><tr>";
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
		        			if(colnames[i].ShowCol_E.indexOf('OrderListUpdate')==0){
			            		tableData+="<th>"+colnames[i].ShowCol_C+"</th>";
			            		colr.push(colnames[i].ShowCol_E);
			            		}
		            	}
		            	tableData+="<th>訂單資訊</th>";
		            	tableData+="<th>允許</th>";
		            	tableData+="<th>拒絕</th>";
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
					tableData+="<td>"+obj[i].OrderListUpdate_ComID+"</td>"
					tableData+="<td>"+obj[i].OrderListUpdate_Event+"</td>"
					tableData+="<td>"+obj[i].OrderListUpdate_Time+"</td>"
					tableData+="<td>"+GetColVal('Account','Account_ID','Account_Name',obj[i].OrderListUpdate_AID)+"</td>"
					tableData+="<td>"+GetColVal('OrderListUpdateResult','OrderListUpdateResult_Value','OrderListUpdateResult_Detail',obj[i].OrderListUpdate_Result)+"</td>"
					tableData+="<td>"+'<a title="查詢" class="account_action" data-orderlist_id="' + obj[i].OrderListUpdate_OID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					if(obj[i].OrderListUpdate_Result==2){
					tableData+="<td>"+'<a title="允許" class="account_action" data-orderlist_id="' + obj[i].OrderListUpdate_OID + '" data-type="allow">' + 
					'<i class="fa fa-check fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="拒絕" class="account_action" data-orderlist_id="' + obj[i].OrderListUpdate_OID + '" data-type="reject">' + 
					'<i class="fa fa-times-circle fa-2x"></i></a>'+"</td>"
					}else{
					tableData+="<td>"+'<a title="允許" class="account_action" data-orderlist_id="' + obj[i].OrderListUpdate_OID + '" data-type="allow"></a>'+"</td>"
					tableData+="<td>"+'<a title="拒絕" class="account_action" data-orderlist_id="' + obj[i].OrderListUpdate_OID + '" data-type="reject"></a>'+"</td>"	
					}
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv2").html(tableData);//運用html方法將拼接的table新增到tbody中return;
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
			function action_windows(key_,url,type_,startdate,enddate){
				console.log('action_windows'+startdate)
				var tablename;
				if(type_=="log"){
					tablename="OrderListLog"
					url = "${pageContext.request.contextPath}/IDSearchServelt";
				}else if(type_=="allow"){
					tablename="OrderListUpdate";
					url = "${pageContext.request.contextPath}/OrderItemSearchServelt";
				}else if(type_=="reject"){
					tablename="OrderListUpdateDESC";
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
						console.log(result)
						if($('.bootbox').length == 0){
							//<%-- 開啟對話框 --%>						
							action_page(type_,result,startdate,enddate);
						}
					},
					error: function(xhr, ajaxOptions, thrownError){
						alert(xhr.status+"\n"+thrownError);
					}
				});
			}
			//執行對話框內的動作
			function action(action_url,type_,orderlist_info,startdate,enddate) {
				console.log('action'+startdate)
				var doID ="${doID}"
					if(type_=='allow'){
						var formData = new FormData(form_orderlist);
						formData.append("doID", doID);
						formData.append("OID", orderlist_info[0].OrderListUpdate_OID);
						formData.append("type", type_);
						formData.append("AID", orderlist_info[0].OrderListUpdate_AID);
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
								if(result==1){
									bootbox.alert({
									    message: "已修改",
									    callback: function () {
									    	location.reload();
									    }
									})
								}else{
									bootbox.alert({
									    message: "修改未成功，請再操作一次",
									    callback: function () {
									    	location.reload();
									    }
									})
								}
								//location.reload();
							},
							error:function(xhr,ajaxOptions,thrownError){
								alert("");
								alert(xhr.status);
								alert(thrownError);
							}
						});
					}else if(type_=='reject'){
						var formData = new FormData(form_orderlist);
						formData.append("doID", doID);
						formData.append("OID", orderlist_info[0].OrderListUpdate_OID);
						formData.append("type", type_);
						formData.append("AID", orderlist_info[0].OrderListUpdate_AID);
						formData.append("reject_detail", $("#reject_detail").val());
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
								alert(result)
								if(result==1){
									bootbox.alert({
									    message: "已修改",
									    callback: function () {
									    	location.reload();
									    }
									})
									//bootbox.alert('已修改')
								}else{
									bootbox.alert({
									    message: "修改未成功，請再操作一次",
									    callback: function () {
									    	location.reload();
									    }
									})
									//bootbox.alert('修改未成功，請再操作一次')
								}
								location.reload();
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
						formData2.append("OID", orderlist_info[0].OrderList_ID);
						formData2.append("type", type_);
						formData2.append("cancel_detail", $("#cancel_detail").val());
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
									//bootbox.alert('已送出請求')
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
			function action_page(type_,orderlist_info,startdate,enddate){
				console.log('action_page'+startdate)
				orderlist_info=orderlist_info;
				var action_url;
				if(type_ == 'allow'||type_=='reject'){
					action_url = "${pageContext.request.contextPath}/OrderListUpdateServelt";
				}else if(type_=='log'){
					
				}
				//<%-- 標題文字1 --%>
				var title_text = 
					(type_ == 'detail') ? '查詢訂單資訊' : 
					(type_ == 'log') ? '查詢訂單的操作記錄' : 
					(type_ == 'delete') ? (orderlist_info.OrderList_Vaild == 1) ? '下架' : '重新上架' : 
					(type_ == 'update') ? '修改訂單' : '新增訂單';
				<%-- 按鈕圖示 --%>
				var button_action_icon = 
					(type_ != 'delete') ? 'check' : 
					(orderlist_info.OrderList_Vaild == 1) ? 'thumbs-down' : 'thumbs-up';
				<%-- 按鈕文字 --%>
				var button_action_text = 
					(type_ == 'delete') ? (orderlist_info.OrderList_Vaild == 1) ? '刪除' : '恢復' : 
					(type_ == 'update') ? '修改' : (type_ == 'insert') ? '新增': '確認';
				
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
				if(type_ == 'delete' || type_ == 'update' || type_ == 'insert'|| type_ == 'allow'|| type_ == 'reject'){
					
					bootbox_buttons.save = {
						label: '<i class="fa fa-'+button_action_icon+' fa-2x"></i> ' + button_action_text,
						className: 'btn btn-sm btn-primary',
						callback:function(result){

							//<%-- 欄位驗證 --%>
							if(validate(type_)){
								//<%-- 設計傳送資料 --%>
								var form_data = {};
								if(type_ == "delete"){
									form_data.orderlist_key = orderlist_info.OrderList_ID;
									form_data.orderlist_vaild = orderlist_info.OrderList_Vaild;
								}else if(type_=="insert"||type_=='update'){
									//<%-- 新增 與 修改 只差在 key 值，所以寫在一起 --%>
									form_data.orderlist_key = (type_ == "update") ?  orderlist_info.OrderList_ID : 0;
									form_data.orderlist_name = $("#orderlist_name").val();
									form_data.orderlist_price = $("#orderlist_price").val();
									form_data.orderlist_detail = $("#orderlist_detail").val();
									form_data.orderlist_quanity = $("#orderlist_quanity").val();
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
					}else if(type_== "log"){
						bootbox_title="訂單修改紀錄"
					}else if(type_== "allow"){
						bootbox_title="允許買家所提出的需求"
					}else if(type_== "reject"){
						bootbox_title="拒絕買家所提出的需求"
					}

					var message = get_bootbox_message(type_ , orderlist_info);
					
					bootbox.dialog({
						animate: true,
						className: "medium",
						title: '<h3 class="smaller lighter no-margin blue">'+bootbox_title+'</h3>',
						message:message,
						buttons: bootbox_buttons,
						closeButton: false
					});
					$('#edit').on('click',function(){
						$('.form-qunity').attr('disabled',false);
					});
					$('#edit_state').on('click',function(){
						submit_radio(GetColVal("OrderState","OrderState_Value","OrderState_Detail",null),"orderlist_state","#stateradio");
						$('#su').css('display','block')
						$("input[name='orderlist_state']").each(function(){
							if($(this).attr('value')==orderlist_info[0].OrderList_State){
									$(this).attr('checked',true)
								}
						});
						$('#su').on('click',function(){
							alert(getradiotext("orderlist_state")+' '+orderlist_info[0].OrderList_ComID)
					        $.ajax({
		                        type:"post",
		                        url:"${pageContext.request.contextPath}/OrderListUpdateStateServelt",
		                        datatype:"text",
		                        data:{
		                           orderstate:getradiovalue("orderlist_state"),
		                           oid:orderlist_info[0].OrderList_ID,
		                           comID:orderlist_info[0].OrderList_ComID,
		                           statename:getradiotext("orderlist_state"),
		                           aid:orderlist_info[0].OrderList_UserID,
		                           startdate:startdate,
		                           enddate:enddate
		                        },
		                        async: false,
		                        success:function(result){
		                           if(result==1){
		                        	   bootbox.alert('修改成功');
		                        	   location.reload();
		                           }
		                        },
								error:function(xhr,ajaxOptions,thrownError){
									alert("");
									alert(xhr.status);
									alert(thrownError);
								}   
					        });
						});
					});		
					
			}
			function submit_radio(result,idname,htmlid){
//	          console.log(result);

	            var radioData="";
	            $.each(result, function(index, value) {
	            	if(value!='已取消'){
	            	   radioData+='<input type="radio" id="'+idname+index+'" name="'+idname+'"value="'+index+'" data-state="'+value+'">'+value;
	               }
	            });
	            radioData+='<br>'+'<span class="red error" style="color: red;"></span>'
	            $(htmlid).html(radioData);//運用html方法將拼接的table新增到tbody中return;
	         }
			function getradiovalue(rdname){
				var val=0;
//				$("input:radio[name='"+rdname+"']").change(function(){
					$("input:radio[name='"+rdname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
							val=$(this).attr('value')
							}
						});
//					});	
				console.log(val);
			 return val;	
			}
			function getradiotext(rdname){
				var val=0;
//				$("input:radio[name='"+rdname+"']").change(function(){
					$("input:radio[name='"+rdname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
							val=$(this).data('state')
							}
						});
//					});	
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
					message +='<div class="profile-info-name">訂單狀態 :</div>'+
								'<div class="profile-info-value">' + GetColVal("OrderState","OrderState_Value","OrderState_Detail",orderlist_info[0].OrderList_State) +
									'<button id="edit_state" style="margin-left: 1%;"><i class="fas fa-edit"></i>編輯</button>'+
								'</div>'+
								'<div id="stateradio"style="float:left;"></div>'+
								'<button id="su" class="btn btn-outline-success btn-sm" style="margin-left: 4%;display:none"><i class="fas fa-check"></i>提交</button>'+
							'</div>'
					
				}else if(type_ == "allow"){
					var sql=orderlist_info[0].OrderListUpdate_SqlEvent
					var sqls= new Array();
					sqls=sql.split(';'); //字元分割
					//console.log("orderlist_info"+orderlist_info)
					var event=orderlist_info[0].OrderListUpdate_Event
							message += '<form id="form_orderlist" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">'+
							'<div class="profile-user-info profile-user-info-striped">' +
								'<div class="profile-info-row">' +
									'<div class="profile-info-value">允許</div>' +
									'<div class="profile-info-value" style="white-space: pre-line;">' + orderlist_info[0].OrderListUpdate_Event + '</div>' +
								'</div>' +
							'</div>'
							for(var i=0;i<orderlist_info.length;i++){
								for(var j=0;j<sqls.length;j++){
									console.log(sqls[j]+'   '+'`OrderItem_SID`='+orderlist_info[i].ProductStyle_ID)
									if(sqls[j].indexOf('`OrderItem_SID`='+orderlist_info[i].ProductStyle_ID)>0){
										message +='<div class="profile-info-value" style="color:#ee6c4d;">['+orderlist_info[i].Product_Name+'   '+orderlist_info[i].ProductStyle_Vaule +']  現庫存量 : '+orderlist_info[i].Product_Quanity+'</div>'
									}
								}
							}
							message +='</form>'	
				}else if(type_ == "reject"){
					console.log(orderlist_info)
						message = '<form id="form_orderlist" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">'+
									'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">需求內容:</div>' +
											'<div class="profile-info-value">' + orderlist_info[0].OrderListUpdate_Event + '</div>' +
										'</div>' +
									'</div>'+	
									'<div class="profile-user-info profile-user-info-striped">' +	
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">拒絕原因:</div>' +
											'<textarea class="form-control" id="reject_detail" name="input_reject_detail" placeholder="請填寫拒絕原因" />'+
									'</form>'	
				}
				return message;
			}
			
			function validate(type_){
				//<%-- 驗證規則(正則表達式) --%>
				var rule = /^.+$/;
				//<%-- 回傳boolean參數，預設為true --%>
				var return_boolean = true;
				//<%-- orderlist_name 物件 --%>
				var orderlist_name = $("#orderlist_name");
				//<%-- orderlist_price 物件 --%>
				var orderlist_price = $("#orderlist_price");
				//<%-- orderlist_detail 物件 --%>
				var orderlist_detail = $("#orderlist_detail");
				
				//<%-- 此處會有三種 type 新增、修改、刪除，刪除只需要執行再次確認的畫面即可，所以不需要執行欄位驗證 --%>
				switch (type_){
					case "delete":
						return true;
						break;
					//<%-- 新增(insert)不使用 break 中斷 switch 流程，是因為 修改(update)與 新增(insert)有共同驗證的欄位--%>
					case "insert":
						//<%-- 因為 新增(insert)時，password 是必填欄位，在 修改(update)為非必填欄位--%>
						if(rule.test(orderlist_name.val())){
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
<body>
<jsp:include page="../slidemenu.jsp"/>
		<div class="wrap-login100">
				<form class="login100-form validate-form" method="post">
					<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 70px;" id="main_title">
						訂單管理
					</span>
					
					<div class="wrap-input100 validate-input"  style="float: left; position: relative;left: 50%; transform: translate(-50%,0px); width: auto !important;">
						<span style="color: white;">請選擇要查看的時間區間 ，若無則直接按搜尋</span><br>
						<input type="text" name="datefilter" value="" style="background: transparent;color: white;"/>
						<i class="fa fa-calendar"style="color:white;margin-right: 10px;float: left;"></i>
						
					</div>
					<button class="login100-form-btn" id="searchorder" style="position: relative;left: 50%; transform: translate(-50%,0px);font-family:HanyiSentyGarden;">搜尋</button>
					<button class="login100-form-btn" id="searchreq" style="position: relative;left: 50%; transform: translate(-50%,0px);font-family:HanyiSentyGarden;">搜尋</button>
				</form>
			</div>

			<div id="testdiv2" style="margin-left: 20px;"></div>
			<div id="testdiv" style="margin-left: 20px;"></div>		  

</body>


</html>