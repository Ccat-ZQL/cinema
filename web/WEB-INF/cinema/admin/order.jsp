<%--
  Created by IntelliJ IDEA.
  User: Mango
  Date: 2021/6/1
  Time: 15:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css" />
    <link href="${pageContext.request.contextPath}/bootstrap/table/bootstrap-table.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/fileInput/bootstrap-fileinput.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/layui/css/layui.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/select/bootstrap-select.min.css" rel="stylesheet">


    <script src="${pageContext.request.contextPath}/js/jquery-3.1.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/fileInput/bootstrap-fileinput.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/table/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/table/bootstrap-table.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/table/bootstrap-table-zh-CN.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/select/bootstrap-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/layui/layui.js"></script>
    <title>订单管理</title>
    <style>
        .bootstrap-table .fixed-table-container {
            height: fit-content;
        }

        #table-name {
            font-size: large;
            font-weight: bold;
        }

        td {
            white-space: nowrap;
        }

        .modal-span {
            font-weight: bold;
            font-size: large;
        }

        .modal-div {
            margin-top: 10px;
            width: 510px;
        }

        .form-group {
            margin-top: 10px;
        }

        .movie-input {
            margin-top: 5px;
        }

        .form-control {
            margin-top: 3px;
            width: 480px;
        }

        .modal.show .modal-dialog {
            display: table;
        }

        .modal-content {
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div id="div-head" style="width: 100%; height: 50px; background-color: #e1e1e1; border-color: #f8f8f8;">
        <span style="line-height: 50px;float: left;margin-left: 300px;font-size: 22px">购票系统后台管理系统</span>
        <span style="margin-left: 45px; float: left; font-size: 18px; font-weight: bold;line-height: 50px;">
            <a href="${pageContext.request.contextPath}/admin/index">->电影管理</a>
        </span>
        <span style="margin-left: 45px; float: left; font-size: 18px; font-weight: bold;line-height: 50px;">
            <a href="${pageContext.request.contextPath}/admin/user">->用户管理</a>
        </span>
        <span style="margin-left: 45px; float: left; font-size: 18px; font-weight: bold;line-height: 50px;">
            <a href="${pageContext.request.contextPath}/admin/order">->订单管理</a>
        </span>
        <span style="margin-left: 45px; float: left; font-size: 18px; font-weight: bold;line-height: 50px;">
            <a href="${pageContext.request.contextPath}/admin/notice">->公告管理</a>
        </span>
        <div>
            <p style="line-height: 50px;margin-right: 300px;font-weight: normal; font-size: large;float: right;">
                欢迎您，${sessionScope.user.name}&nbsp;&nbsp;&nbsp;&nbsp;
                <a id="logout" style="cursor: pointer"
                   onclick="window.location.href='${pageContext.request.contextPath}/user/logout'">
                    退出登录
                </a>
            </p>
        </div>
    </div>

    <div class="container" style="margin-top: 100px; width: 100%;">
        <div style="margin-bottom: 20px;" class="form-group">
            <span id="table-name">>>订单列表</span>
            <button class="btn btn-primary" style="float: right" onclick="refreshTable()">搜索</button>
            <input type="text" class="form-control" id="search-key"
                   placeholder="请输入手机号或订单编号" style="float: right">
        </div>
        <div class="form-group">
        </div>
        <table id="orders" style="table-layout:fixed; width: 100%;" class="table text-nowrap"></table>
    </div>
</body>

<script>
    $(function () {
        $('#orders').bootstrapTable({
            url: "${pageContext.request.contextPath}/admin/order/queryByCondition",
            striped : true, //是否显示行间隔色
            pageNumber : 1, //初始化加载第一页
            pagination : true,//是否分页
            sidePagination : 'client',//server:服务器端分页|client：前端分页
            pageSize : 5,//单页记录数
            pageList : [5, 10],//可选择单页记录数
            showRefresh : false,//刷新按钮
            search: false,
            queryParams: function (params) {
              return {
                  pageSize: params.pageSize,
                  pageNumber: params.pageNumber,
                  key: $("#search-key").val()
              }
            },
            columns : [{
                title : 'id',
                field : 'id',
                visible: false
            },{
                title : '用户名',
                field : 'name',
                align: "center",
            },{
                title : '手机号',
                field : 'phone',
                align: "center",
            },{
                title : '订单号',
                field : 'number',
                align: "center",
                width: 200
            },{
                title : '放映厅',
                field : 'screeningRoom',
                align: "center",
                width: 80
            },{
                title : '票数',
                field : 'ticketNumber',
                align: "center",
                width: 70
            },{
                title : '单价',
                field : 'price',
                align: "center",
                width: 70
            },{
                title : '总价',
                field : 'money',
                align: "center",
                width: 70
            }, {
                title : '座位',
                field : 'seat',
                align: "center",
            }, {
                title : '下单时间',
                field : 'time',
                sortable : true,
                align: "center",
                width: 200
            }, {
                title : '状态',
                align: "center",
                formatter: function (value, row, index) {
                    if (row.status == 0) {
                        return "<span style='color: red; font-weight: bold'>未支付</span>";
                    } else if (row.status == 1) {
                        return "<span style='color: green; font-weight: bold'>已付款</span>";
                    } else {
                        return "<span style='color: black; font-weight: bold'>已取消</span>";
                    }
                },
                width: 80
            }, {
                title : '操作',
                field : 'Button',
                align: "center",
                formatter: function (value, row, index) {
                    if (row.status == 0) {
                        return "<button type='button' class='btn btn-danger' onclick='cancelOrder("+row.id+")'>取消订单</button>";
                    }
                },
                cellStyle: {
                    css: {

                    }
                },
            }]
        })
    })

    function refreshTable() {
        $("#orders").bootstrapTable('refresh');
    }

    function cancelOrder(id) {
        if (confirm("是否取消该订单")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/order/cancelOrder",
                dataType: "json",
                data: {
                    "id": id
                },
                success: function (res) {
                    if (res == true) {
                        $("#orders").bootstrapTable('refresh');
                        alert("订单取消成功")
                    } else {
                        alert("订单取消失败")
                    }
                },
                error: function () {
                    alert("出错了，请稍后重试")
                }
            })
        }
    }
</script>
</html>
