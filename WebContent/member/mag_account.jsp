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
	<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script src="js/bootbox.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/jquery.dataTables.bootstrap.js"></script>
	<script type="text/javascript">
	window.onload=function(){
		userview();
		sidemenu();
	};
	
	function userview(){
		var doID ="${doID}"
		var dolevel ="${level}"
		$('body').css('background-image', 'linear-gradient(to right, rgba(10, 16, 41, 0.65),rgba(10, 16, 41, 0.65)),url("images/about-video.jpg")');
		$('body').css('background-size','100% 100%,100% 100%');
		    console.log(dolevel)        
	        if(dolevel.indexOf('a')==-1){//無新增權限的管理員
	        	$('#insertuser').remove();
	        }else{
	        	$('#insertuser').on("click",function(){
		 			action_page("insert","");
					return false;
		 		});
	        }  	
			$('#searchname').on("click",function(){
				var dolevel ="${level}"
				var targets = [5,6,7,8];
				if(dolevel==='1ab'){
					targets = [5,6,7];
					}
				if(dolevel==='1a'){
					targets = [5,6];
				}
				
			    $.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/AccountSearchServelt",
					datatype:"json",
					//contentType:"false",
					data:{
						user:$('#usernameinput').val(),
						name:$('#nameinput').val()//getParameter(xx)
					},
					success:function(result){
						console.log(targets);
		            	submit_table(result,dolevel);
						
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
				            	//6瀏覽  7歷程 8修改 9刪除
				                targets: targets, //設定第n欄不進行排序功能
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
		});
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
						//<%-- url設定 --%>
						var url = "${pageContext.request.contextPath}/IDSearchServelt";
						
						//<%-- 取得此次操作的相關資料 --%>
						action_windows(key_,url,type_);
					});	
				}
			//製作DataTable
			function submit_table(result,dolevel){
				var obj = JSON.parse(result);//解析json字串為json物件形式
				if(result.length==0){
					var tableData= '<th>查無此使用者</th>';
					$("#tbody").html(tableData);
				}else{
					if(dolevel==='1abc'){
						var tableData="<table id='tbody'>"+"<thead><tr><th>使用者帳號</th><th>中文姓名</th><th>電子信箱</th><th>手機號碼</th><th>身分</th><th>瀏覽</th><th>歷程</th><th>修改</th><th>刪除</th></tr></thead><tbody>"
					}
					if(dolevel==='1ab'){
						var tableData="<table id='tbody'>"+"<thead><tr><th>使用者帳號</th><th>中文姓名</th><th>電子信箱</th><th>手機號碼</th><th>身分</th><th>瀏覽</th><th>歷程</th><th>修改</th></tr></thead><tbody>"
					}
				for(var i=0;i<obj.length;i++){
				tableData+="<tr>"
					tableData+="<td>"+obj[i].Account_UserName+"</td>"
					tableData+="<td>"+obj[i].Account_Name+"</td>"
					tableData+="<td>"+obj[i].Account_Email+"</td>"
					tableData+="<td>"+obj[i].Account_Phone+"</td>"
					if(obj[i].Account_Level.indexOf('1')==0){
						tableData+="<td>"+GetColVal('AccountLevel','AccountLevel_Value','AccountLevel_Detail','1')+"</td>"
					}else{
						tableData+="<td>"+GetColVal('AccountLevel','AccountLevel_Value','AccountLevel_Detail',obj[i].Account_Level)+"</td>"

					}
					tableData+="<td>"+'<a title="查詢" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="detail">' + 
					'<i class="fa fa-search fa-2x"></i></a>'+"</td>"
					tableData+="<td>"+'<a title="歷程" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="log">' + 
					'<i class="fa fa-history fa-2x"></i></a>'+"</td>"
					if(dolevel==='1ab'){
						if(obj[i].Account_Level.indexOf('1')==0){
							tableData+="<td>"+'<a title="修改" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="update">' + 
							'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
						}else{
							tableData+="<td>"+'<a title="修改" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="not-update">' + 
							'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
						}	
					}
					if(dolevel==='1abc'){
						if(obj[i].Account_Level.indexOf('1')==0){
							tableData+="<td>"+'<a title="修改" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="update">' + 
							'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
						}else{
							tableData+="<td>"+'<a title="修改" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="not-update">' + 
							'<i class="fa fa-edit fa-2x"></i></a>'+"</td>"
						}
					tableData+="<td>"+'<a title="刪除" class="account_action" data-account_id="' + obj[i].Account_ID + '" data-type="delete">' + 
					'<i class="fa fa-trash fa-2x"></i></a>'+"</td>"}
					tableData+="</tr>"
					}
				tableData+="</tbody></table>"
				$("#testdiv").html(tableData);//運用html方法將拼接的table新增到tbody中return;
//				document.getElementById("insertuser").style.display = "block";
	    		}
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
				if(type_.indexOf('not')==0){
					alert('此使用者非管理員身分，故無法修改其資料')
				}else{
					if(type_=="log"){
						tablename="AccountLog"
					}else{
						tablename="Account";
					}
					$
					$.ajax({
						type:"post", 
						url: url,
						dataType:"json",
						data: {
							tablename:tablename,
							id : key_,
							type:type_
						},
						success: function(result){
							
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
			}
			//判斷使用者身分
			function levelcheck(level) {
				  if ( level === '2' ) {
				    return '管理者';
				  } else if ( level === '1' ) {
				    return '賣家';
				  }else if ( level === '0' ) {
				    return '買家';
				  }
				}
			//判斷執行動作
			function typecheck(type) {
				  if ( type === 'delete' ) {
				    return '刪除';
				  } else if ( type === 'update' ) {
				    return '更新';
				  }else if ( type === 'insert' ) {
				    return '新增';
				  }
				}
			//執行對話框內的動作
			function action(action_url,type_,form_data) {
				var userID;
				var doID ="${doID}"
				$.ajax({
					type:"post",
					url:action_url,
					datatype:"text",
					//contentType:"false",
					data:{
						tablename:"Account",
						type:'admin',
						id:form_data.account_key,
						user:form_data.account_user,
						name:form_data.account_name,//getParameter(xx)
						ename:form_data.account_ename,
						password:form_data.account_password,
						phone:form_data.account_phone,
						email:form_data.account_email,
						level:1,
						vaild:form_data.account_vaild,
						admin:form_data.account_admin,
						address:form_data.account_address
					},
					success:function(result){
							if(result!=='1'){
								alert('成功')
								location.reload();
							}else if(result=='2'){
								alert('資料與先前相同')
								location.reload();
							}else if(result=='0'){
								alert('失敗')
								location.reload();
							}else{
								alert('成功')
								location.reload();
							}
						
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
					
			}
			function uploadphoto(userID){
				//上傳照片到server
				var formData = new FormData(form_account);
				formData.append("userID", userID);
				$.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/APhotouploadServlet",
					datatype:"text",
					processData: false,
					contentType:false,
					cache : false,
					data:formData,
					async: false,
					success:function(result){
						if(result=="T"){
							alert("上傳server成功");
							Accountupload(userID);}
							//location.reload();
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
				formData.append("type", type_);			
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
							alert("新增成功");
						}else{
							alert("新增成功");
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
		
			//設計對話框樣式
			function action_page(type_,account_info){
				//<%-- 按鈕執行所照訪網址 --%>
				//<%-- 除了 log 以外的資料，不可能會有複數 --%>

				if(type_ == 'delete'||type_ == 'update'||type_ == 'detail'){
					//修改、刪除(AccountServelt)
					account_info = account_info[0];
					action_url = "${pageContext.request.contextPath}/DBUpdateServelt";
				}else if(type_ == 'insert'){
					//新增(SignupServlet)
					account_info = '{"Account_UserName":"","Account_Password":"","Account_Name":"","Account_EName":"","Account_Email":"","Account_Level":"","Account_Photo":"","Account_Vaild":"0"}'
					action_url = "${pageContext.request.contextPath}/SignupServlet";
				}else{
					account_info=account_info
				}
				//<%-- 標題文字1 --%>
				var title_text = 
					(type_ == 'detail') ? '查詢 '+account_info.Account_Name+' 的使用者帳號' : 
					(type_ == 'log') ? account_info.Account_Name+' 的操作記錄' : 
					(type_ == 'delete') ? (account_info.Account_Vaild == 1) ? '停用' : '恢復' : 
					(type_ == 'update') ? '修改 '+account_info.Account_Name+' 的使用者帳號' : '新增使用者帳號';
				<%-- 按鈕圖示 --%>
				var button_action_icon = 
					(type_ != 'delete') ? 'check' : 
					(account_info.Account_Vaild == 1) ? 'thumbs-down' : 'thumbs-up';
				<%-- 按鈕文字 --%>
				var button_action_text = 
					(type_ == 'delete') ? (account_info.Account_Vaild == 1) ? '停用' : '恢復' : 
					(type_ == 'update') ? '修改' : '新增';
				
				//<%-- 按鈕初始化 --%>
				var bootbox_buttons = {};
				if(type_ == 'delete' || type_ == 'update' || type_ == 'insert'){
					bootbox_buttons.save = {
						label: '<i class="fa fa-'+button_action_icon+' fa-2x"></i> ' + button_action_text,
						className: 'btn btn-sm btn-primary',
						callback:function(result){

							//<%-- 欄位驗證 --%>
							if(validate(type_)){
								//<%-- 設計傳送資料 --%>
								var form_data = {};
								if(type_ == "delete"){
									form_data.account_key = account_info.Account_ID;
									form_data.account_vaild = account_info.Account_Vaild;
								}else{
									//<%-- 新增 與 修改 只差在 key 值，所以寫在一起 --%>
									form_data.account_key = (type_ == "update") ?  account_info.Account_ID : 0;
									form_data.account_name = $("#account_name").val();
									form_data.account_ename = $("#account_ename").val();
									form_data.account_email = $("#account_email").val();
									form_data.account_phone = $("#account_phone").val();
									form_data.account_user = $("#account_user").val();
									form_data.account_password = $("#account_password1").val();								
									form_data.account_level = $("[name='account_level']:checked").val();
									form_data.account_admin = JSON.stringify(getcheckvalue('account_admin'));									
									form_data.account_vaild = account_info.Account_Vaild;
									form_data.account_address= account_info.Account_Address;
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
					var bootbox_title;
					if(type_== "detail"){
						bootbox_title="瀏覽使用者資訊"
					}else if(type_== "update"){
						bootbox_title="修改權限"
					}else if(type_== "delete"){
						bootbox_title="停用/恢復管理者"
					}else if(type_== "log"){
						bootbox_title="資訊更改紀錄"
					}else if(type_== "insert"){
						bootbox_title="新增管理者"
					}
					var message = get_bootbox_message(type_ , account_info);
					bootbox.dialog({
						className: "medium",
						title: '<h3 class="smaller lighter no-margin blue">'+bootbox_title+'</h3>',
						message:message,
						buttons: bootbox_buttons,
						closeButton: false
					});
					submit_radio(GetColVal("AccountLevel","AccountLevel_Value","AccountLevel_Detail",null),"account_level");
					submit_checkbox(GetColVal("AdminLevel","AdminLevel_Value","AdminLevel_Detail",null),"account_admin");
					if(type_ == "insert"||type_ == 'update'){
						var account_level_val;
						$(function(){
						$("input:radio[name='account_level']").change(function(){
							$("input:radio[name='account_level']").each(function(){//找出被勾選的選項
								if($(this).is(':checked')==true){
								account_level_val=$(this).attr('value');
									if(account_level_val==='1'){
											document.getElementById('account_admin_checkbox').style.display = 'block';
										}else{
											document.getElementById('account_admin_checkbox').style.display = 'none';
											
										}
									}
								});
							});		
						});
					}
					if(type_ == "update"){
						$("#account_user").val(account_info.Account_UserName);//帳號
						$("#account_name").val(account_info.Account_Name); //中文姓名
						$("#account_ename").val(account_info.Account_EName);//英文姓名
						$("#account_email").val(account_info.Account_Email);//Email
						$("#account_phone").val(account_info.Account_Phone);//電話號碼
						$("#account_address").val(account_info.Account_Address);
						var level=account_info.Account_Level;
//						$.each(GetColVal("AccountLevel","AccountLevel_Value","AccountLevel_Detail",null), function(index, value) {
//							if(level.indexOf(index)!=-1){$("input:radio[name='account_level']").attr("checked",index);}
//						});
						
						//document.getElementById("account_level"+account_info.Account_Level).checked = true;
						if(level.indexOf('1')==-1){
							$("input[name='account_level'][value='"+level+"']").attr("checked",true);
						}else{
							$("input[name='account_level'][value='1']").attr("checked",true);
							document.getElementById('account_admin_checkbox').style.display = 'block';
							$.each(GetColVal("AdminLevel","AdminLevel_Value","AdminLevel_Detail",null), function(index, value) {
								if(level.indexOf(index)!=-1){
									$('#account_admin'+index).attr('checked',true)};
							});
						}
						$("#account_user").prop("readonly",true);
					}else{
						$("#account_user").prop("readonly",false);
					}
			}
			//取得被勾選的radio值
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
			//取得被勾選的radio值
			function getcheckvalue(ckname){
				var val=[];
//				$("input:radio[name='"+rdname+"']").change(function(){
					$("input[name='"+ckname+"']").each(function(){//找出被勾選的選項
						if($(this).is(':checked')==true){
						val.push($(this).attr('value'));
							}
						});
//					});		
			 return val;	
			}
			
			//製作對話框內容
			function get_bootbox_message(type_,account_info){
				//<%-- 對話框內容 --%>
				var message = "";
				//<%-- 刪除 --%>
				if(type_ == "delete"){
					delete_value = (account_info.account_status) ? '停用' : '恢復';
					message = '<span class="note"> ' + ' [ <span class="bold"> '+ account_info.Account_Name +' </span> ] 的使用者帳號？ </span>';
				//<%-- 操作紀錄 --%>
				}else if(type_ == "log"){
					//<%-- class="pre-scrollable" 會顯示 Y 軸的卷軸 --%>
					message = '<div>';
					if(account_info.length==0){
						message += '<h6> 尚未有任何變更紀錄 </h6>';
					}else{
						for(var key in account_info){
							message+='<h6> ● ' +account_info[key].AccountLog_Time.substring(0,16)+ account_info[key].AccountLog_Event + '</h6>';
							}
					}
					message += '</div>';
				//<%-- 詳細資料 --%>
				}else if(type_ == "detail"){
					message += 	'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">帳號:</div>' +
										'<div class="profile-info-value">' + account_info.Account_UserName + '</div>' +
									'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +	
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">中文姓名:</div>' +
										'<div class="profile-info-value">' + account_info.Account_Name + '</div>' +
									'</div>' +
								'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +	
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">手機號碼:</div>' +
										'<div class="profile-info-value">' + account_info.Account_Phone + '</div>' +
									'</div>' +
								'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +	
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">地址:</div>' 
										if(account_info.Account_Address!=null){
											message +='<div class="profile-info-value">' + account_info.Account_Address + '</div>'
										}else{
											message +='<div class="profile-info-value">無填寫</div>'
										}
					message +=		
									'</div>' +
								'</div>' +
								'<div class="profile-user-info profile-user-info-striped">' +
									'<div class="profile-info-row">' +
										'<div class="profile-info-name">使用者身分:</div>' +
										'<div class="profile-info-value">' + GetColVal("AccountLevel","AccountLevel_Value","AccountLevel_Detail",account_info.Account_Level.substring(0,1)) + '</div>' +
										'</div>' +
								'</div>';
				}else if(type_ == "insert"){
					message =		'<form id="form_account" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
					'<div class="profile-user-info profile-user-info-striped">' +
						'<div class="profile-info-row">' +
							'<div class="profile-info-name">帳號 :</div>' +
							'<div class="profile-info-value">' +
								'<input type="text" class="form-control" id="account_user" name="input_account_user" placeholder="請輸入帳號" />' +
								'<span class="red error" style="color: red;"></span>' +
							'</div>' +
						'</div>' +
						'<div class="profile-info-row">' +
							'<div class="profile-info-name">密碼 :</div>' +
							'<div class="profile-info-value">' +
								'<input type="password" class="form-control" id="account_password1" name="input_account_password1" placeholder="請輸入密碼" />' +
								'<span class="red error" style="color: red;"></span>' +
							'</div>' +
						'</div>' +
						'<div class="profile-info-row">' +
							'<div class="profile-info-name">再次輸入密碼 :</div>' +
							'<div class="profile-info-value">' +
								'<input type="password" class="form-control" id="account_password2" name="input_account_password2" placeholder="請再次輸入密碼" />' +
								'<span class="red error" style="color: red;"></span>' +
							'</div>' +
						'</div>' +
						'<div class="profile-info-row">' +
							'<div class="profile-info-name">使用者身分:管理員</div>' +
							'<div class="profile-info-value" id="admincheck">' +
							'</div>' +
						'</div>' +
					'</div>' +
				'</form>'; 
				}else{
					message =		'<form id="form_account" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">' +
										'<div class="profile-user-info profile-user-info-striped">' +
											'<div class="profile-info-row">' +
												'<div class="profile-info-name">帳號 :</div>' +
												'<div class="profile-info-value">' +
													'<input type="text" class="form-control" id="account_user" name="input_account_user" placeholder="請輸入帳號" />' +
													'<span class="red error" style="color: red;"></span>' +
												'</div>' +
											'</div>' +
											'<div class="profile-info-row">' +
												'<div class="profile-info-name">使用者身分:管理員</div>' +
												'<div class="profile-info-value" id="admincheck">' +
												'</div>' +
											'</div>' +
										'</div>' +
									'</form>'; 
				}
				return message;
			}
			//製作radio
			function submit_radio(result,idname){
//				console.log(result);

				var radioData="";
				$.each(result, function(index, value) {
					radioData+='<input type="radio" id="'+idname+index+'" name="'+idname+'"value="'+index+'">'+value;
				});
	    		radioData+='<br>'+'<span class="red error" style="color: red;"></span>'
	    		$("#levelradio").html(radioData);//運用html方法將拼接的table新增到tbody中return;
			}
			//製作checkbox
			function submit_checkbox(result,idname,htmlid){
//				console.log(result);
				var checkboxData='<div id="account_admin_checkbox">';
	    		$.each(result, function(index, value) {
	    			checkboxData+='<input type="checkbox" id="'+idname+index+'" name="'+idname+'" value="'+index+'">'+value;
				});
	    		checkboxData+='<br>'+'<span class="red error" style="color: red;"></span>'+'</div>'
	    		$("#admincheck").html(checkboxData);//運用html方法將拼接的table新增到tbody中return;
			}
			
			function check_repeat(account_user){
				return_check = false;
				$.ajax({
		    		type:"post", 
		            url:"${pageContext.request.contextPath}/AccountSearchServelt",
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

				//<%-- account_user 物件 --%>
				var account_user = $("#account_user");
				//<%-- account_name 物件 --%>
				var account_name = $("#account_name");
				//<%-- account_ename 物件 --%>
				var account_ename = $("#account_ename");
				//<%-- account_password1 物件 --%>
				var account_password1 = $("#account_password1");
				//<%-- account_password2 物件 --%>
				var account_password2 = $("#account_password2");

				//<%-- account_email 物件 --%>				
				var account_email=$('#account_email');
				//<%-- account_phone 物件 --%>				
				var account_phone=$('#account_phone');
				//<%-- account_level 物件的值 --%>
				var account_level_val=0;
				account_level_val =$("[name='account_level']:checked").val();
				//<%-- account_level 物件 --%>	
				var account_level= $("[name='account_level']");	
				
				//<%-- 此處會有三種 type 近來新增、修改、刪除，刪除只需要執行再次確認的畫面即可，所以不需要執行欄位驗證 --%>
				switch (type_){
					case "delete":
						return true;
						break;
					//<%-- 新增(insert)不使用 break 中斷 switch 流程，是因為 修改(update)與 新增(insert)有共同驗證的欄位--%>
					case "insert":
						//<%-- 因為 新增(insert)時，password 是必填欄位，在 修改(update)為非必填欄位--%>
						if(rule.test(account_password1.val())){
							account_password1.siblings('.error').text('');
						}else{
							account_password1.siblings('.error').text('請輸入密碼');
							//account_password1.siblings('.error').append('請輸入密碼append');
							return_boolean = false;
						}
						if(rule.test(account_password2.val())){
							account_password2.siblings('.error').text('');
						}else{
							account_password2.siblings('.error').text('請輸入密碼');
							return_boolean = false;
						}
						//<%-- 帳號不可變更 所以只有新增才需要判斷是否空值 --%>
						if(rule.test(account_user.val())){
							//<%-- 檢查帳號有無重複 --%>
							if(check_repeat(account_user.val())){
								//<%-- 沒有重複 --%>
								account_user.siblings('.error').text('');
							} else {
								//<%-- 有重複 --%>
								account_user.siblings('.error').text('使用者帳號已存在');
								return_boolean = false;
							}
						}else{
							account_user.siblings('.error').text('請輸入使用者帳號');
							return_boolean = false;
						}
					case "update":
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
							if(rule.test(account_phone.val())){
								account_phone.siblings('.error').text('');
							}else{
								if(account_phone.val().length<10){
									account_phone.siblings('.error').text('請輸入正確格式');
									return_boolean = false;	
								}else{
								account_phone.siblings('.error').text('請輸入手機號碼');
								return_boolean = false;
								}
							}	
							console.log(account_level_val);			
							if(typeof account_level_val !== 'undefined'){
								if(account_level_val==='1'){//管理員身分
									//<%-- account_admin 物件的值 --%>
									var account_admin_val = getcheckvalue("account_admin");
									console.log(account_admin_val);
									//<%-- account_admin 物件 --%>	
									var account_admin= $("[name='account_admin']");
									if(account_admin_val.length>0){
									account_admin.siblings('.error').text('');
									}else {//未選擇權限									
									account_admin.siblings('.error').text('請選擇權限');
									return_boolean = false;
									}
								account_level.siblings('.error').text('');
								}
							}						
							//<%-- 當 password 欄位有被填入時，需判斷兩個欄位的直要相同--%>
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
						break;
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
						使用者管理
					<button class="login100-form-btn" id="insertuser" style="font-family:HanyiSentyGarden;">新增管理員</button>
					</span>

					<div class="wrap-input100 validate-input"  style="float:left;right: 10px;">
						<input class="input100" id="usernameinput" type="text" name="user" placeholder="帳號">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span id="userempty" style="color: red;top: 50px;position: absolute;"></span>

					</div>
					<div class="wrap-input100 validate-input"  style="float:right">
						<input class="input100" id="nameinput" type="text" name="name" placeholder="姓名">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span id="nameempty" style="color: red;top: 50px;position: absolute;"></span>

					</div>
					<button class="login100-form-btn" id="searchname" style="float: right;font-family:HanyiSentyGarden;">搜尋</button>
				</form>
			</div>
			<div id="testdiv" style="margin-left: 20px;"></div>	  

</body>

</html>