<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>帳號資料查詢</title>	
	</head>
	<body class="no-skin">
		<div class="main-content">
			<div class="main-content-inner">
				<div id="all-content">
					<%-- 路徑列 (麵包屑) --%>
					<div class="breadcrumbs ace-save-state" id="breadcrumbs">
						<ul class="breadcrumb">
							<%-- 首頁 --%>
							<li>
								<i class="fa fa-home home-icon fa-fw"></i>
								<a href="${pageContext.servletContext.contextPath}/general/home.jsp">首頁</a>
							</li>
							<li class="active">
								使用者帳號管理
							</li>
							<li class="active">
								使用者帳號查詢
							</li>
						</ul>
					</div>
					<div class="page-content">
						<div class="page-header">
							<h1>
								<%-- 標題列 --%>
								<i class="menu-icon fa fa-server fa-fw"></i> 使用者帳號管理
								<small><i class="ace-icon fa fa-angle-double-right"></i> 使用者帳號查詢 </small>
								<%-- 功能按鈕 --%>
								<div class="pull-right">
									<c:if test="${user_auth_list.contains('2')}">
										<button class="btn btn-white btn-primary" id="create" data-type="insert">
											<i class="ace-icon fa fa-plus"></i> 新增使用者帳號
										</button>
									</c:if>									
								</div>
							</h1>
						</div>
						<%-- 主要查詢即顯示區塊 --%>
						<div class="row">
							<div class="col-xs-12">
							<%-- 查詢表單 form --%>
								<div id="account_select_div">
									<form id="account_form" class="form-horizontal" role="form">
										<div class="profile-user-info profile-user-info-striped">
											<div class="profile-info-row">
												<div class="profile-info-name">帳號</div>
												<div class="profile-info-value">
													<input type="text" class="form-control" id="select_account_name" placeholder="請輸入帳號">
												</div>
												<div class="profile-info-name">使用者</div>
												<div class="profile-info-value">
													<input type="text" class="form-control" id="select_ccount_user" placeholder="請輸入使用者名稱">
												</div>
											</div>
										</div>
										<div class="profile-user-info profile-user-info-striped">
											<div class="profile-info-row">
												<div class="profile-info-name">帳號狀態</div>
												<div class="profile-info-value">
													<input type="checkbox" class="ace ace-switch ace-switch-6" id="select_account_status" value="1" checked/>
													<span class="lbl"></span>
												</div>
											</div>
										</div>
										<hr/>
										<div class="text-center">
											<button type="button" class="btn btn-sm btn-info" id="submit" >
												<i class="ace-icon fa fa-search bigger-110 fa-fw"></i>查詢
											</button>
										</div>
										<br/>
									</form>
								</div>
							<%-- 查詢結果顯示區塊 --%>
								<div id="account_table_div">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>