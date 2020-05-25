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
		var mag="${mag}"
		var doID="${doID}"
		$('body').css('background-image', 'linear-gradient(to right, rgba(27, 60, 121, 0.7),rgba(27, 60, 121, 0.7)),url("images/about-video.jpg")');
        $('body').css('background-size','100% 100%,100% 100%');
			if(mag=='prd'){
				$('#insertcate').remove();
				$('#searchcate').remove();
				var index ="${index}"
					if(index==''){
						index='0';
					}
				var pageindex=parseInt(index);
			    $.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/ProductSearchServelt",
					datatype:"json",
					//contentType:"false",
					data:{
						tablename:"Product",
						user:$('#prdnameinput').val(),
						name:$('#prdnameinput').val(),//getParameter(xx)
						doID:doID,
						type:'search'
					},
					success:function(result){
		            	submit_table(result,"Product");
						$('#tbody').DataTable({
							"displayStart": pageindex,
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
				            iDisplayLength: 10,// 每頁顯示筆數 
				            bSort: true,// 排序
				            lengthMenu: [10],
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
			}else{
				$('#insertprd2').remove();
				$('#insertphs').remove();
				$('#insertprd').remove();
				$('#searchinput').remove();
				$('#searchname').remove();
				$('#tabletitle').text('商品分類');
				var doID ="${doID}"
					 $.ajax({
							type:"post",
							url:"${pageContext.request.contextPath}/IDSearchServelt",
							datatype:"json",
							//contentType:"false",
							data:{
								tablename:"ShopCategoryAll",
								id:doID
							},
							success:function(result){
								console.log(result)
				            	submit_table2(result);
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
						                targets: [1,2,3],
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
			}
			$('#insertprd2').on("click",function(){
				
				action_page("insert2","","0");
				
				return false;
	 		});
			$('#insertphs').on("click",function(){
				
				action_page("insertphs","","0");
				
				return false;
	 		});
	 		$('#insertprd').on("click",function(){
				action_page("insert",'{"Product_Name":"","Product_Price":"","Product_Detail":"","Product_InsDate":"","Product_Quanity":"","Product_Vaild":"","Product_SellerID":""}',"0");
				return false;
	 		});
	 		$('#insertcate').on("click",function(){
				action_page("insertcate","","0");
				return false;
	 		});
				
			$('#searchname').on("click",function(){
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
							doID:doID,
							type:'search'
						},
						success:function(result){
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
					            iDisplayLength: 10,// 每頁顯示筆數 
					            bSort: true,// 排序
					            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
					            columnDefs: [{
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
				return false 
			});
		}		
			function action_function(){
				
					//<%-- 實作 HTML 物件 class 屬性有 account_aciont 的功能 --%>
					/*<%-- 注意事項  
					 		所以 新增的功能才必須抽離製作，否則在每次執行時都需要重設，物件的onclick功能，否則重複執行該物件會有重複執行的狀況發生 --%>*/
					$('.account_action').on('click',function(){
						//<%-- 執行的按鈕類型 --%>
						var index = $(this).data('row');
						var type_ = $(this).data('type');
						//<%-- 執行的 key --%>
						var key_ = $(this).data('account_id');
						var url = "${pageContext.request.contextPath}/ProductSearchServelt";
						if(type_=='log'||type_=='cateupdate'||type_=='catedelete'){
							url = "${pageContext.request.contextPath}/IDSearchServelt";
						}
						//<%-- 取得此次操作的相關資料 --%>
						action_windows(key_,url,type_,index);
					});	
				}
			//製作DataTable
			function submit_table2(result){
				var tableData="<table id='tbody2'><thead><tr>";
		            	tableData+="<th>分類編號</th>"
		            	tableData+="<th>分類名稱</th>"
		            	tableData+="<th>修改</th>"
				        tableData+="<th>下架/復原</th>"
						tableData+="</tr></thead><tbody>";
				var obj = JSON.parse(result);//解析json字串為json物件形式
				for(var i=0;i<obj.length;i++){
					if(obj[i].ShopCategory_Name!='不分類'){
						tableData+="<tr>"
						tableData+="<td>"+obj[i].ShopCategory_ID+"</td>"
						tableData+="<td>"+obj[i].ShopCategory_Name+"</td>"
						tableData+="<td>"+'<a title="修改" class="account_action" data-account_id="' + obj[i].ShopCategory_ID + '" data-type="cateupdate">' + 
						'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
						tableData+="<td>"+'<a title="刪除" class="account_action" data-account_id="' + obj[i].ShopCategory_ID + '" data-type="catedelete">' + 
						'<i class="fa fa-trash fa-2x"></i></a>'+"</td>"
						tableData+="</tr>"
						}
					}
				tableData+="</tbody></table>"
				$("#testdiv2").html(tableData);
	    		}
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
		            	console.log(colnames)
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
		            	tableData+="<th>下架/復原</th>"
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
				tableData+='<tr>'
					tableData+="<td>"+obj[i].Product_ID+"</td>"
					tableData+="<td>"+obj[i].Product_Name+"</td>"
					tableData+="<td>"+obj[i].Product_Price+"</td>"
//					tableData+="<td>"+obj[i].Product_Detail+"</td>"
					if(obj[i].Product_Quanity.indexOf('F : ')<0){
		                  tableData+="<td>"+obj[i].Product_Quanity+"</td>"
		               }else{
		                  tableData+="<td>"+obj[i].Product_Quanity.replace('F : ', '')+"</td>"}
					if(obj[i].ShopCategory_Name!=null){
						tableData+="<td>"+obj[i].ShopCategory_Name+"</td>"
					}else{
						tableData+="<td>未分類</td>"}
					tableData+="<td>"+GetColVal2('ProductVaild','ProductVaild_Value','ProductVaild_Detail',obj[i].Product_Vaild)+"</td>"
					tableData+="<td>"+'<a title="查詢" class="account_action" data-row="0" data-account_id="' + obj[i].Product_ID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="歷程" class="account_action" data-row="0" data-account_id="' + obj[i].Product_ID + '" data-type="log">' + 
					'<i class="fa fa-history fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="修改" class="account_action" data-row="'+i+'" data-account_id="' + obj[i].Product_ID + '" data-type="update">' + 
					'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="刪除" class="account_action" data-row="'+i+'" data-account_id="' + obj[i].Product_ID + '" data-type="delete">' + 
					'<i class="fa fa-trash fa-2x"></i></a>'+"</td>"
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv").html(tableData);
	    		}
			
			//找出欄位的值  ind=已有的vaule
			function GetColVal2(tablename,colname1,colname2,ind){
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
			function GetColVal(tablename,colname1,colname2,ind){
				var doID ="${doID}"
				var findvalue=0;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/GetCategoryServelt",
		            dataType:"json",
		            async: false,
		            data: {
		            	tablename : tablename,
		            	colname1:colname1,
		            	colname2:colname2,
		            	doID:doID
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
			function action_windows(key_,url,type_,index){
				var doID ="${doID}"
				var tablename;
				if(type_=="log"){
					tablename="ProductLog"
					url="${pageContext.request.contextPath}/IDSearchServelt";
					$.ajax({
						type:"post", 
						url: url,
						dataType:"json",
						data: {
							type:'log',
							tablename:tablename,
							id : key_,
							doID:doID
						},
						success: function(result){
							console.log(result);
							
							if($('.bootbox').length == 0){
								//<%-- 開啟對話框 --%>
								action_page(type_,result,index);
							}
						},
						error: function(xhr, ajaxOptions, thrownError){
							alert(xhr.status+"\n"+thrownError);
						}
					});
				}else if(type_=="catedelete"||type_=="cateupdate"){
					tablename="ShopCategoryEdit"
						url="${pageContext.request.contextPath}/IDSearchServelt";
						$.ajax({
							type:"post", 
							url: url,
							dataType:"json",
							data: {
								type:type_,
								tablename:tablename,
								id : key_,
								doID:doID
							},
							success: function(result){
								console.log(result);
								
								if($('.bootbox').length == 0){
									//<%-- 開啟對話框 --%>
									action_page(type_,result,index);
								}
							},
							error: function(xhr, ajaxOptions, thrownError){
								alert(xhr.status+"\n"+thrownError);
							}
						});
					
				}else{
					tablename="Product";
					url="${pageContext.request.contextPath}/ProductSearchServelt";
					$.ajax({
						type:"post", 
						url: url,
						dataType:"json",
						data: {
							type:'detail',
							tablename:tablename,
							id : key_,
							doID:doID
						},
						success: function(result){
							console.log(result);
							
							if($('.bootbox').length == 0){
								//<%-- 開啟對話框 --%>
								action_page(type_,result,index);
							}
						},
						error: function(xhr, ajaxOptions, thrownError){
							alert(xhr.status+"\n"+thrownError);
						}
					});
				}

			}
			function showtable(){
				
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
							doID:doID,
							type:'search'
						},
						success:function(result){
			            	submit_table(result,"Product");
							$('#tbody').DataTable({
								 "displayStart": index,
						    	searching: false, //關閉搜尋功能
					            oLanguage: {    // 中文化  
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
					            iDisplayLength: 10,// 每頁顯示筆數 
					            bSort: true,// 排序
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
				return false
						
			}
			//執行對話框內的動作
			function action(action_url,type_,form_data,index) {
				var doID ="${doID}"
				if(type_=="insertphs"){//上傳圖片
					PrdPhsUpload()
				}else if(type_=="insert2"){//csv
				var formData = new FormData(form_product);
				formData.append("tablename", "Product");
				formData.append("doID", doID);
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/CSVUploadServlet3",
						datatype:"text",
						processData: false,
						contentType:false,
						cache : false,
						data:formData,
						async: false,
						success:function(result){
							if(result=='1'){
							alert("csv上傳DB成功");}
							location.reload();
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});
				}else if(type_=="update"||type_=="delete"){//修改
					var prdqu=[]
					var prdquid=[]
					$("input[name='input_product_quanity']").each(function(){
						prdqu.push($(this).val().trim())
						prdquid.push($(this).attr('id').substring($(this).attr('id').indexOf('y')+1))
					});
					var doID ="${doID}"
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/ProductUpdateServelt",
						datatype:"text",
						async: false,
						data:{
							doID:doID,
							tablename:"Product",
							type:type_,
							id:form_data.product_key,
							name:form_data.product_name,//getParameter(xx)
							price:form_data.product_price,
							detail:form_data.product_detail,
							quanity:prdqu,
							quanityid:prdquid,
							vaild:form_data.product_vaild,
							category:getcheckvalue('product_category'),
							categoryname:getchecktext('product_category'),
							index:index
						},
						success:function(result){
							if(result==1){
								alert("修改成功");
								location.reload();
								if($('#product_phs').val()!=''){
									PrdPhsUpload()
								}
							}else{
								alert("修改失敗");
								location.reload();
							}
							
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}else if(type_=="insert"){//上架單一商品
					var stylename=[];
					$("input[name='input_product_style']").each(function(){
						var style_name=$(this).val()
						stylename.push(style_name)
					});
					var stylequ=[];
					$("input[name='input_product_quanity']").each(function(){
						var style_qu=$(this).val()
						stylequ.push(style_qu)
					});
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/InsPrdServelt",
						datatype:"text",
						//contentType:"false",
						data:{
							doID:doID,
							tablename:"Product",
							type:type_,
							id:form_data.product_key,
							name:form_data.product_name,//getParameter(xx)
							price:form_data.product_price,
							detail:form_data.product_detail,
							quanity:stylequ,
							category:getcheckvalue('product_category'),
							categoryname:getchecktext('product_category'),
							style:stylename
						},
						success:function(result){
							alert(result);
							OnePrdPhsUpload(result)
							//location.reload();
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}else if(type_=="insertcate"){//新增商品分類
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/InsPrdServelt",
						datatype:"text",
						//contentType:"false",
						data:{
							doID:doID,
							tablename:"ShopCategory",
							type:type_,
							name:form_data.category_name
						},
						success:function(result){
							bootbox.alert('新增成功');
							location.reload();
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}else if(type_=="cateupdate"){//修改商品分類
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/DBUpdateServelt",
						datatype:"text",
						//contentType:"false",
						data:{
							tablename:"ShopCategory",
							type:type_,
							name:form_data.category_name,
							id:form_data.category_key,
							vaild:''
						},
						success:function(result){
							bootbox.alert('修改成功');
							location.reload();
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});	
				}else if(type_=="catedelete"){//刪除商品分類
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/DBUpdateServelt",
						datatype:"text",
						//contentType:"false",
						data:{
							tablename:"ShopCategory",
							type:type_,
							id:form_data.category_key,
							vaild:form_data.category_vaild,
							name:''
						},
						success:function(result){
							bootbox.alert('修改成功');
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
			function PrdPhsUpload(){
				//上傳多張照片到server 和 DB
				var doID ="${doID}"
				var formData = new FormData(form_product);
				formData.append("tablename", "Product");
				formData.append("doID", doID);
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/PrdPhsUploadServlet",
					datatype:"text",
					processData: false,
					contentType:false,
					cache : false,
					data:formData,
					async: false,
					success:function(result){
						if(result=='1'){
						alert("上傳成功");}
							//location.reload();
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
			}
			function OnePrdPhsUpload(prdid){
				alert(prdid)
				//上傳多張照片到server 和 DB
				var doID ="${doID}"
				var formData = new FormData(form_product);
				formData.append("tablename", "Product");
				formData.append("doID", doID);
				formData.append("prdid", prdid);
				alert(prdid)
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/PrdPhsUploadServlet",
					datatype:"text",
					processData: false,
					contentType:false,
					cache : false,
					data:formData,
					async: false,
					success:function(result){
						if(result=='1'){
						bootbox.alert("上傳成功");}
							//location.reload();
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
			}
		
			//設計對話框樣式
			function action_page(type_,product_info,index){
				if(type_ != 'log'){
					//修改、刪除(DBUpdateServelt)
					product_info = product_info[0];
					action_url = "${pageContext.request.contextPath}/DBUpdateServelt";
				}else if(type_=='log'){
					product_info=product_info;
				}
				console.log(product_info)
				//<%-- 標題文字1 --%>
				var title_text = 
					(type_ == 'detail') ? '查詢 '+product_info.Product_Name+' 的商品帳號' : 
					(type_ == 'log') ? product_info.Product_Name+' 的操作記錄' : 
					(type_ == 'delete') ? (product_info.Product_Vaild == 1) ? '下架' : '重新上架' : 
					(type_ == 'catedelete') ? (product_info.ShopCategory_Vaild == 1) ? '下架' : '重新上架' :
					(type_ == 'update') ? '修改 '+product_info.Product_Name+' 的商品帳號' : '新增商品帳號';
				<%-- 按鈕圖示 --%>
				var button_action_icon = 
					(type_ != 'delete'||'catedelete') ? 'check' : 
					(product_info.Product_Vaild == 1) ? 'thumbs-down' : 'thumbs-up';
				<%-- 按鈕文字 --%>
				var button_action_text = 
					(type_ == 'delete') ? (product_info.Product_Vaild == 1) ? '下架' : '重新上架' : 
					(type_ == 'catedelete') ? (product_info.ShopCategory_Vaild == 1) ? '刪除' : '復原' : 
					(type_ == 'update') ? '修改' : '新增';
				console.log()
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
				if(type_ == 'delete' || type_ == 'update' || type_ == 'insert' || type_ == 'insert2'|| type_ == 'insertphs'|| type_ == 'insertcate'|| type_ == 'catedelete'|| type_ == 'cateupdate'){
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
									form_data.product_category = getcheckvalue('product_category');
								}else if(type_=="insertcate"){
									form_data.category_key = 0;
									form_data.category_name = $("#category_name").val();
								}else if(type_=="catedelete"){
									form_data.category_key = product_info.ShopCategory_ID;
									form_data.category_vaild =product_info.ShopCategory_Vaild;
								}else if(type_=="cateupdate"){
									form_data.category_key = product_info.ShopCategory_ID;
									form_data.category_name = $("#category_name").val();
								}
								form_data.type = type_;
								//<%-- 執行 --%>
								action(action_url,type_,form_data,index);
							}
							//<%-- 在驗證沒過的時候，需保留麵給商品 --%>
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
					var bootbox_title;
					if(type_== "detail"){
						bootbox_title="瀏覽商品資訊"
					}else if(type_== "update"){
						bootbox_title="修改商品資訊"
					}else if(type_== "delete"){
						bootbox_title="重新上架/下架商品"
					}else if(type_== "log"){
						bootbox_title="商品資訊修改歷史紀錄"
					}else if(type_== "insert"){
						bootbox_title="商品上架"
					}else if(type_== "insert2"){
						bootbox_title="批次上架"
					}else if(type_== "insertphs"){
						bootbox_title="圖片上傳"
					}else if(type_== "insertcate"){
						bootbox_title="新增商品分類"
					}else if(type_== "cateupdate"){
						bootbox_title="修改商品分類名稱"
					}else if(type_== "catedelete"){
						bootbox_title="刪除/復原商品分類"
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
					submit_checkbox(GetColVal('ShopCategory','ShopCategory_ID','ShopCategory_Name',null),"product_category","#categorycheck");
					$('.product_category').change(function() {
						
						if(this.checked){
							var cate_name=$(this).data('cate_name')
							var cate_id='#'+$(this).attr('id')
							if(cate_name=='不分類'){
								$("input[name='product_category']").each(function(){
									$(this).attr('checked',false)
									$(this).attr('disabled',true)
								});
								$(cate_id).attr('disabled',false)
							}else{
								$("input[name='product_category']").each(function(){
									if($(this).data('cate_name')=='不分類'){
										$(this).attr('checked',false)
										$(this).attr('disabled',true)
									}
								});	
							}
						}else{
							$("input[name='product_category']").each(function(){
								$(this).attr('disabled',false)
								});
						}
			 		});
					$('#new_style').on('click',function(){
						var count=0;
						var newdata=""
							$("input[name='input_product_style']").each(function(){//找出被勾選的選項
								count++;
							});
						submit_input(count,'#div_new_style')
						//$('#new_style').html('000');		
					});
					if(type_ == "update"){
						$("#product_name").val(product_info.Product_Name);//商品名稱
						$("#product_price").val(product_info.Product_Price); //商品$$
						$("#product_detail").val(product_info.Product_Detail);//細節說明
							if(product_info.Product_Quanity.indexOf(',')>0){
								var strs= new Array();
								var strid= new Array();
								strs=product_info.Product_Quanity.split(',');
								strid=product_info.ProductStyle_ID.split(',');
								for(var i=0;i<strs.length;i++){
									var id='#product_quanity'+strid[i]
									console.log(id+' '+strs[i].substring(strs[i].indexOf(':')+1))
									$(id).val(strs[i].substring(strs[i].indexOf(':')+1))
								}
							}else{
								//alert(product_info.Product_Quanity.substring(product_info.Product_Quanity.indexOf(':')+1))
								var id='#product_quanity'+product_info.ProductStyle_ID.trim();
								$(id).val(product_info.Product_Quanity.substring(product_info.Product_Quanity.indexOf(':')+1));
							}
						$("#product_quanity").val(product_info.Product_Quanity);
						$("input[name='product_category']").each(function(){
							var cate_name=$(this).data('cate_name')
							if(product_info.ShopCategory_Name.indexOf(cate_name)>=0){
								$(this).attr('checked',true)}
							});
					}else if(type_ == "cateupdate"){
						$("#category_name").val(product_info.ShopCategory_Name);//商品名稱
					}
				}
			function getcheckvalue(ckname){
				var val=[];
					$("input[name='"+ckname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
						val.push($(this).attr('value'));
							}
						});
			 return val;	
			}
			function getchecktext(ckname){
				var val=[];
					$("input[name='"+ckname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
						val.push($(this).data('cate_name'));
							}
						});
			 return val;	
			}
			function submit_input(count,htmlid){
		            var newData="";
		            newData+='<div class="profile-info-row">' +
					'<div class="profile-info-name">款式'+(count+1)+'</div>' +
					'<div class="profile-info-value">' +
					'<input type="text" class="form-control" id="product_style" name="input_product_style" placeholder="請輸入款式名稱"/>' +
						'<span class="red error" style="color: red;"></span>' +
					'</div>' +
				'</div>' +
				'<div class="profile-info-row">' +
					'<div class="profile-info-name">數量'+(count+1)+'</div>' +
					'<div class="profile-info-value">' +
						'<input type="text" class="form-control" id="product_quanity" name="input_product_quanity" placeholder="請輸入數量" />' +
						'<span class="red error" style="color: red;"></span>' +
					'</div>' +
				'</div>'
		        $(htmlid).append(newData);//運用html方法將拼接的table新增到tbody中return;
		     }
			//製作對話框內容
			function get_bootbox_message(type_,product_info){
				var message = "";
				if(type_ == "delete"){
					message = '<span class="note"> ' + ' [ <span class="bold"> '+ product_info.Product_Name +' </span> ]  </span>';
				}else if(type_ == "catedelete"){
					if(product_info.ShopCategory_Vaild == 1){
						message = '<span class="note"> ' + '<span class="bold" style="color:#311b92;"> 刪除該分類將使該分類的商品 一同下架 </span>  </span><br>'+
						'<span class="note"> ' + ' [ <span class="bold"> '+ product_info.ShopCategory_Name +' </span> ]  </span>';
					}else{
						message = '<span class="note"> ' + '<span class="bold" style="color:#311b92;"> 還原該分類將使該分類的商品 一同重新上架 </span>  </span><br>'+
						'<span class="note"> ' + ' [ <span class="bold"> '+ product_info.ShopCategory_Name +' </span> ]  </span>';
					}
				}else if(type_ == "log"){
					//<%-- class="pre-scrollable" 會顯示 Y 軸的卷軸 --%>
					message = '<div>';
					if(product_info.length==0){
						message += '<h6> 尚未有任何變更紀錄 </h6>';
					}else{
						for(var key in product_info){
							message+='<h6> ● ' +product_info[key].ProductLog_Time.substring(0,16)+ product_info[key].ProductLog_Event + '</h6>';
							}
					}
					message += '</div>';
					
				//<%-- 詳細資料 --%>
				}else if(type_ == "detail"){
					message += '<div id="testinfo" style="float: left;width: 400px;">'+
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品名稱:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Name + '</div>' +
									'</div>' +
								'</div>'+	
								'<div class="profile-user-info profile-user-info-striped">' +	
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品價錢:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Price + '</div>' +
									'</div>' +
								'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">細節說明:</div>' +
										'<div class="profile-info-value" style="white-space: pre-line;">' + product_info.Product_Detail+ '</div>' +
									'</div>' +
								'</div>' 
					if(product_info.Product_Quanity.indexOf(',')>0){
						message+='<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品數量:</div>'
						var strs= new Array();
						strs=product_info.Product_Quanity.split(',');
						for(var i=0;i<strs.length;i++){
						message+=	'<div class="profile-info-value">' + strs[i]+ '</div>' 
									 
						}
						message+=	'</div>' +
								'</div>'
					}else{
						message+='<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品數量:</div>' +
										'<div class="profile-info-value">' + product_info.Product_Quanity+ '</div>' +
									'</div>' +
								'</div>'
					}
					message +=	'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品分類:</div>' +
										'<div class="profile-info-value">' + product_info.ShopCategory_Name+ '</div>' +
									'</div>' +
								'</div>' +
							'</div>'+
							'<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel"style="width: 300px; height: 300px;float: right;">'+show_phs(product_info.Product_ID,product_info.Product_SellerID)+'</div>';
							
				//<%-- csv --%>
				}else if (type_ == "insert2"){
					message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
									'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">csv上傳 :</div>' +
											'<div class="profile-info-name" style="color:#311b92;">csv檔案內部格式:[商品名稱,價錢,商品細節說明,數量,分類代號]</div>' +
											'<div class="profile-info-name" style="color:#311b92;">若商品細節欲以分行表示請用"+"代替換行"</div>' +
											'<div class="profile-info-name" style="color:#ba68c8;">範例:弗里西亞耳環 / 2色 ,123,90,商品皆為實際拍攝+商品材質：純銀+商品材質：銅,金:50-銀:30,38-40</div>' +
											'<div class="profile-info-name" style="color:#d50000;">請注意csv檔內已換行來判斷是否還有下一樣商品，故不得有沒有文字的空行</div>' +
											'<div class="profile-info-value">' + 
											'<input type="file" class="form-control" id="product_csv" name="input_product_csv"/>' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
									'</div>' +
								'</form>'; 
				//<%-- 圖片 --%>	
				}else if (type_ == "insertphs"){
					message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
									'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">圖片上傳 (請將檔名改為該ID)</div>' +
											'<div class="profile-info-name" style="color:#ee6c4d;">1.修改:將圖片檔名與先前的檔名一致 就會直接覆蓋</div>' +
											'<div class="profile-info-name" style="color:#ee6c4d;">2.新增:建議新圖檔檔名 依照檔名編號+1 EX:先前有108(1).jpg 108(2).jpg 本次上傳的檔名:108(3).jpg....</div>' +
											'<div class="profile-info-value">' + 
											'<input type="file" class="form-control" id="product_phs" name="input_product_phs" multiple/>' +
											'<span class="red error" style="color: red;"></span>' +
											'</div>' +
										'</div>' +
									'</div>' +
								'</form>'; 
				}else if (type_=="update") {
					console.log(product_info.Product_Quanity)
					message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品名稱 :(名稱長度不得大於45)</div>' +
										'<div class="profile-info-value">' + 
										'<input type="text" class="form-control" id="product_name" name="input_product_name" placeholder="請輸入名稱" />' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品價錢 :</div>' +
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
									'</div>'
										if(product_info.Product_Quanity.indexOf(',')>0){
											message+='<div class="profile-info-row">' +
															'<div class="profile-info-name">商品數量:</div>'
											var strs= new Array();
											var strid= new Array();
											strs=product_info.Product_Quanity.split(',');
											strid=product_info.ProductStyle_ID.split(',');
											for(var i=0;i<strs.length;i++){
											message+=	'<div class="profile-info-value">'+strs[i].substring(0,strs[i].indexOf(':'))+
											'<input type="text" class="form-control" id="product_quanity'+strid[i]+'" name="input_product_quanity" placeholder="請輸入數量" />' +
											'<span class="red error" style="color: red;"></span>' 
											}
											message+=	'</div>' +
													'</div>'
										}else{
											message+='<div class="profile-info-row">' +
															'<div class="profile-info-name">商品數量:</div>' +
															'<div class="profile-info-value">'+
															'<input type="text" class="form-control" id="product_quanity'+product_info.ProductStyle_ID+'" name="input_product_quanity" placeholder="請輸入數量" />' +
															'<span class="red error" style="color: red;"></span>'
														'</div>' +
													'</div>'
										}
					message+=			'<div class="profile-info-row">' +
										'<div class="profile-info-name">分類</div>' +
										'<div class="profile-info-value" id="categorycheck">' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
									'<div class="profile-info-name">上傳商品圖片 :</div>' +
									'<div class="profile-info-value">' +
										'<input type="file" class="form-control" id="product_phs" name="input_product_phs" multiple/>' +
										'<span class="red error" style="color: red;"></span>' +
									'</div>' +
								'</div>' +
								'</div>' +
							'</form>'; 
				}else if (type_ == "insert") {
					message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品名稱 :(名稱長度不得大於45)</div>' +
										'<div class="profile-info-value">' + 
										'<input type="text" class="form-control" id="product_name" name="input_product_name" placeholder="請輸入名稱" />' +
										'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">商品價錢 :</div>' +
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
										'<div class="profile-info-name">款式 (如該商品無款式區別 預設名稱為"F" 可以更改):<i class="btn btn-outline-success btn-sm" id="new_style" style="margin-left: 1%;">新增款式</i></div>' +
										'<div class="profile-info-name" style="color:#311b92;">提醒:款式名稱後續無法做更改</div>' +
										'<div class="profile-info-value">' +
										'<input type="text" class="form-control" id="product_style" name="input_product_style" value="F"/>' +
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
									'<div id="div_new_style"></div>'+
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">分類</div>' +
										'<div class="profile-info-value" id="categorycheck">' +
										'</div>' +
									'</div>' +
									'<div class="profile-info-row">' +
									'<div class="profile-info-name">上傳商品圖片 :</div>' +
									'<div class="profile-info-value">' +
										'<input type="file" class="form-control" id="product_phs" name="input_product_phs" multiple/>' +
										'<span class="red error" style="color: red;"></span>' +
									'</div>' +
								'</div>' +
								'</div>' +
							'</form>'; 
			}else if (type_ == "insertcate") {
					message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
									'<div class="profile-user-info profile-user-info-striped">' +
										'<div class="profile-info-row">' +
											'<div class="profile-info-name">分類名稱 :</div>' +
											'<div class="profile-info-value">' + 
											'<input type="text" class="form-control" id="category_name" name="input_category_name" placeholder="請輸入名稱" />' +
											'<span class="red error" style="color: red;"></span>' +
										'</div>' +
									'</div>' +
								'</form>'; 
			}else if (type_ == "cateupdate") {
				message = 	'<form id="form_product" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
				'<div class="profile-user-info profile-user-info-striped">' +
					'<div class="profile-info-row">' +
						'<div class="profile-info-name">分類名稱 :</div>' +
						'<div class="profile-info-value">' + 
						'<input type="text" class="form-control" id="category_name" name="input_category_name" placeholder="請輸入名稱" />' +
						'<span class="red error" style="color: red;"></span>' +
					'</div>' +
				'</div>' +
			'</form>'; 
			}
				return message;
			}
			//製作checkbox
			function submit_checkbox(result,idname,htmlid){
//				console.log(result);
				var checkboxData='<div id="product_category_checkbox">';
	    		$.each(result, function(index, value) {
	    			checkboxData+='<input type="checkbox" id="'+idname+index+'" class="'+idname+'" name="'+idname+'" value="'+index+'"data-cate_name="'+value+'">'+value;
				});
	    		checkboxData+='<br>'+'<span class="red error" style="color: red;"></span>'+'</div>'
	    		$(htmlid).html(checkboxData);//運用html方法將拼接的table新增到tbody中return;
			}
			
			function check_repeat(category_name){
				return_check = true;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/GetColValSearchServelt",
		            dataType:"json",
		            async: false,
		            data: {
		            	tablename :'ShopCategory',
		            	colname1:'ShopCategory_Name',
		            	colname2:'ShopCategory_SellerID'	
		            },
		            success: function(result){
		            	$.each(result[0], function(index, value) {
		            		if(category_name===index){
		            			return_check=false;}
		            	}); 
	            		    
		            	
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
				var return_boolean = true;
				//<%-- category_name 物件 --%>
				var category_name = $("#category_name");
				//<%-- product_price 物件 --%>
				var product_price = $("#product_price");
				//<%-- product_detail 物件 --%>
				var product_detail = $("#product_detail");
				var product_phs = $("#product_phs");
				//<%-- 此處會有三種 type 新增、修改、刪除，刪除只需要執行再次確認的畫面即可，所以不需要執行欄位驗證 --%>
				switch (type_){
					case "delete":
						return true;
						break;
					//<%-- 新增(insert)不使用 break 中斷 switch 流程，是因為 修改(update)與 新增(insert)有共同驗證的欄位--%>
					case "insert":
						if(rule.test(product_phs.val())){
							product_phs.siblings('.error').text('');
						}else{
							product_phs.siblings('.error').text('請上傳至少一張商品圖片');
							return_boolean = false;
						}
						//<%-- 因為 新增(insert)時，password 是必填欄位，在 修改(update)為非必填欄位--%>
						if(rule.test(product_name.val())){
							product_name.siblings('.error').text('');
						}else{
							product_name.siblings('.error').text('請輸入商品名稱');
							return_boolean = false;
						}
						if(rule.test(product_price.val())){
							product_price.siblings('.error').text('');
						}else{
							product_price.siblings('.error').text('請輸入商品價格');
							return_boolean = false;
						}
						if(product_detail.val()==""){
							if (confirm("未輸入商品細節說明，如要返回輸入則按「取消」")){
							}else{
								return false;
							}   　　　
						}
						
						break;
					case "insertcate":
						//<%-- 因為 新增(insert)時，password 是必填欄位，在 修改(update)為非必填欄位--%>
						if(rule.test(category_name.val())){
							if(check_repeat(category_name.val())){
								//<%-- 沒有重複 --%>
								category_name.siblings('.error').text('');
							} else {
								//<%-- 有重複 --%>
								category_name.siblings('.error').text('此分類名稱已存在');
								return_boolean = false;
							}
						}else{
							product_name.siblings('.error').text('請輸入商品名稱');
							return_boolean = false;
						}
						break;
					case "update":
						if(rule.test(product_name.val())){
							product_name.siblings('.error').text('');
						}else{
							account_password1.siblings('.error').text('請輸入商品名稱');
							//account_password1.siblings('.error').append('請輸入密碼append');
							return_boolean = false;
						}
						if(rule.test(product_price.val())){
							product_price.siblings('.error').text('');
						}else{
							product_price.siblings('.error').text('請輸入商品價格');
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
			function show_phs(prdID,sellerID){//取得該商品的照片檔名
				var sellerID=sellerID;
				var carousel_data;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/GetPrdPhsServlet",
		            dataType:"json",
		            async: false,
		            data: {
		            	prdID:prdID,
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
					    carousel_data+= '</ol><div class="carousel-inner" style="height: 100%;width: 100%;">'    
					    for(i=0;i<1;i++){
								$.each(result[i], function(index, value) {
									carousel_data+='<div class="carousel-item active">'+
								      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+sellerID+'/'+value+'"alt="First slide">'+
								    '</div>'
						    });    
					    }
						for(i=1;i<result.length;i++){
							$.each(result[i], function(index, value) {
								carousel_data+= '<div class="carousel-item">'+
							      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+sellerID+'/'+value+'"alt="First slide">'+
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
<body>
<jsp:include page="../slidemenu.jsp"/>
		<div class="wrap-login100">
				<form class="login100-form validate-form" method="post">
					<span class="login100-form-title p-b-34 p-t-27" style="font-family: HanyiSentyGarden;font-size: 70px;" id="tabletitle">商品管理</span>
					<button class="login100-form-btn" id="insertcate" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">新增分類</button>
					<!--<button class="login100-form-btn" id="searchcate" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">分類清單</button>	 -->
					<button class="login100-form-btn" id="insertprd" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">單一上架</button>
					<button class="login100-form-btn" id="insertprd2" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">批次上架</button>
					<button class="login100-form-btn" id="insertphs" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">圖片上傳</button>
					<button class="login100-form-btn" id="searchname" style="margin-right: 10px;float: right;font-family:HanyiSentyGarden;">搜尋</button>
					

					<div class="wrap-input100 validate-input" id="searchinput" >
						<input class="input100" id="prdnameinput" type="text" name="user" placeholder="商品名稱">
						<span class="focus-input100" id="prdfocus" data-placeholder="&#xf207;"></span>
						<span id="prdnameempty" style="color: red;top: 50px;position: absolute;"></span>

					</div>
					
				</form>
			</div>
			<div id="testdiv2" style="margin-left: 20px;"></div>	
			<div id="testdiv" style="margin-left: 20px;"></div>	  

</body>


</html>