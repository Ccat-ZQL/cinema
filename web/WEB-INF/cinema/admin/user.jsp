<%--
  Created by IntelliJ IDEA.
  User: Mango
  Date: 2021/6/1
  Time: 11:03
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


    <script src="${pageContext.request.contextPath}/js/jquery-3.1.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/fileInput/bootstrap-fileinput.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/table/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/table/bootstrap-table.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/table/bootstrap-table-zh-CN.min.js"></script>
    <script src="${pageContext.request.contextPath}/layui/layui.js"></script>
    <title>用户管理</title>
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

    <script>
        window.operateEvents = {

            /**
             * 单个删除 按钮点击事件
             * @param e
             * @param value
             * @param row
             * @param index
             */
            "click .btn-danger": function (e, value, row, index) {
                del(row.id)
            },

            /**
             * 编辑 按钮点击事件
             * @param e
             * @param value
             * @param row
             * @param index
             */
            "click .btn-warning": function (e, value, row, index) {
                resetPassword(row.phone)
            },

            /**
             * 查看该用户的所有订单
             * @param e
             * @param value
             * @param row
             * @param index
             */
            "click .btn-info": function (e, value, row, index) {
                orderInfo(row.id)
            }
        }
    </script>
</head>
<body>

    <!-- 模态框 -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
         style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" data-backdrop=”static”>
        <div class="modal-dialog" style="width: auto">
            <div class="modal-content">
                <div class="myModal-header modal-header">

                </div>
                <div class="myModal-body modal-body">

                </div>
                <div class="myModal-footer modal-footer">

                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

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

    <div class="container" style="margin-top: 100px">
        <div style="margin-bottom: 20px;">
            <span id="table-name">>>普通用户列表</span>
            <button type="button" class="btn btn-danger" style="float: right; font-weight: bold" onclick="delMulti()">批量删除</button>
            <button type="button" class="btn btn-success" style="float: right; font-weight: bold; margin-right: 10px" onclick="addUser()">添加用户</button>
        </div>
        <table id="users" style="table-layout:fixed; width: 100%" class="table text-nowrap"></table>
    </div>
</body>

<script>
    /**
     * 初始化table
     **/
    $(function () {
        $('#users').bootstrapTable({
            url: "${pageContext.request.contextPath}/admin/user/getAllUsers",  //请求地址
            striped : true, //是否显示行间隔色
            pageNumber : 1, //初始化加载第一页
            pagination : true,//是否分页
            sidePagination : 'client',//server:服务器端分页|client：前端分页
            pageSize : 5,//单页记录数
            pageList : [5, 10],//可选择单页记录数
            showRefresh : false,//刷新按钮
            search: true,
            searchOnEnterKey: true,
            columns : [{
                checkbox: true,
                visible: true,                  //是否显示复选框
                width: 50
            },{
                title : '标号',
                field : 'no',
                align: "center",
                formatter: function (value, row, index) {
                    //获取每页显示的数量
                    let pageSize=$('#users').bootstrapTable('getOptions').pageSize;
                    //获取当前是第几页
                    let pageNumber=$('#users').bootstrapTable('getOptions').pageNumber;
                    //返回序号，注意index是从0开始的，所以要加上1
                    return pageSize * (pageNumber - 1) + index + 1;
                },
                width: 80
            }, {
                title : 'id',
                field : 'id',
                visible: false,
            }, {
                title : '用户名',
                field : 'name',
                sortable : false,
                align: "center",
                width: 200,
                cellStyle: {
                    css: {
                        "font-weight": "bolder"
                    }
                }
            }, {
                title : '手机号',
                field : 'phone',
                sortable : true,
                align: "center",
            }, {
                title : '操作',
                field : 'Button',
                align: "center",
                formatter: AddFuntionAlty,  //表格中增加按钮
                events: operateEvents,
                cellStyle: {
                    css: {
                        "display": "flex",
                        "justify-content": "space-around",
                        "width": "auto"
                    }
                }
            }]
        })
    })

    function orderInfo(id) {
        $.ajax({
            type: "get",
            url: "${pageContext.request.contextPath}/admin/user/getInfo",
            dataType: "json",
            data: {
                "id": id
            },
            success: function(res) {
                if (res != null) {
                    // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
                    $('#myModal').modal({backdrop: 'static', keyboard: false});
                    $(".myModal-header").append(
                        "<h3 class='modal-title' id='myModalLabel'>" +
                        "   <span style='font-weight: bold; float:left;'>"+res.name+"的订单如下</span>"
                    )
                    $(".myModal-body").append(
                        "<table id='orders' style='width: 1900px' style='table-layout:fixed; width: 100%' class='table text-nowrap'></table>"
                    )
                    $(".myModal-footer").append(
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>",
                    )
                    $('#orders').bootstrapTable({
                        url: "${pageContext.request.contextPath}/admin/order/getAllOrder?id=" + id,
                        striped : true, //是否显示行间隔色
                        pageNumber : 1, //初始化加载第一页
                        pagination : true,//是否分页
                        sidePagination : 'client',//server:服务器端分页|client：前端分页
                        pageSize : 5,//单页记录数
                        pageList : [5, 10],//可选择单页记录数
                        showRefresh : false,//刷新按钮
                        columns : [{
                            title : 'id',
                            field : 'id',
                            visible: false
                        },{
                            title : '订单号',
                            field : 'number',
                            align: "center",
                        },{
                            title : '放映厅',
                            field : 'screeningRoom',
                            align: "center",
                        },{
                            title : '票数',
                            field : 'ticketNumber',
                            align: "center",
                        },{
                            title : '单价',
                            field : 'price',
                            align: "center",
                        },{
                            title : '总价',
                            field : 'money',
                            align: "center",
                        }, {
                            title : '座位',
                            field : 'seat',
                            align: "center",
                        }, {
                            title : '下单时间',
                            field : 'time',
                            sortable : true,
                            align: "center",
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
                        }, {
                            title : '操作',
                            field : 'Button',
                            align: "center",
                            formatter: function (value, row, index) {
                                if (row.status == 0) {
                                    return "<button type='button' style='margin-left: 30px;' class='btn btn-danger' onclick='cancelOrder("+row.id+")'>取消订单</button>";
                                }
                            },
                            cellStyle: {
                                css: {

                                }
                            },
                        }]
                    })
                    $('#myModal').modal('show')
                } else {
                    alert("出错了，请稍后重试");
                }
            },
            error: function () {
                alert("出错了，请稍后重试");
            }
        })
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

    /**
     * 重置密码为123456
     * */
    function resetPassword(phone) {
        if (confirm("是否重置该用户的密码")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/user/resetPwd",
                dataType: "json",
                data: {
                    "phone": phone
                },
                success: function (res) {
                    if (res == true) {
                        refreshTableData();
                        alert("重置成功，密码为123456")
                    } else {
                        alert("重置失败")
                    }
                },
                error: function () {
                    alert("出错了，请稍后重试")
                }
            })
        }
    }

    /**
     * 批量删除用户
     **/
    function delMulti() {
        let checkIds;
        checkIds = getIdSelections();
        if (checkIds == "" || checkIds == null) {
            alert("请先选择用户");
            return;
        }

        if (confirm("是否删除这些用户？")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/user/delMulti",
                dataType: "json",
                data: {
                    "ids": checkIds.toString()
                },
                success: function (res) {
                    if (res == true) {
                        refreshTableData();
                        alert("删除成功")
                    } else {
                        alert("删除失败")
                    }
                },
                error: function () {
                    alert("出错了，请稍后重试")
                }
            })
        }
    }

    /**
     * 获取 table选中的列的电影的id
     **/
    function getIdSelections() {
        return $.map($("#users").bootstrapTable('getSelections'), function(row) {
            return row.id
        })
    }

    /**
     *  添加用户按钮提交
     **/
    function submitUser() {
        let formData = new FormData();
        let name = $("#user-name").val();
        if (name == "" || name == null) {
            alert("请输入用户名")
            return;
        }
        let phone = $("#user-phone").val();
        if (!(/^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$/.test(phone))) {
            alert("请输入正确的手机号")
            return;
        }
        let password = $("#user-password").val();
        if (password == "" || password == null) {
            alert("请输入用户密码")
            return;
        }
        formData.append("name", name)
        formData.append("phone", phone)
        formData.append("password", password)
        $.ajax({
            url: "${pageContext.request.contextPath}/user/registerUser",
            type: "post",
            data: formData,
            async: false,
            contentType: false,
            processData: false,
            success: function (res) {
                if (res.code == 1) {
                    alert("添加成功");
                    refreshTableData();
                    closeModel();
                } else {
                    alert(res.message)
                }
            },
            error: function () {
                alert("出错了，请稍后再试！")
            }
        })
    }


    /**
     * 单个删除用户
     **/
    function del(id) {
        if (confirm("是否删除当前用户?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/user/removeUser",
                dataType: "json",
                data: {
                    "id": id
                },
                success: function (res) {
                    if (res == true) {
                        refreshTableData();
                        alert("删除成功")
                    } else {
                        alert("删除失败")
                    }
                },
                error: function () {
                    alert("出错了，请稍后重试")
                }
            })
        }
    }

    /***
     * 添加用户模态框
     * */
    function addUser() {
        // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
        $('#myModal').modal({backdrop: 'static', keyboard: false});
        $(".myModal-header").append(
            "<h3 class='modal-title' id='myModalLabel'>" +
            "   <span style='font-weight: bold'>添加用户</span>" +
            "</h3>"
        )
        $(".myModal-body").append(
            "<div class='form-group'>" +
            "<label for='name' class='modal-span'>用户名称</label>" +
            "<input type='text' class='form-control' id='user-name' " +
            "placeholder='请输入用户名称'>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='name' class='modal-span'>用户手机号</label>" +
            "<input type='text' class='form-control' id='user-phone' " +
            "placeholder='请输入用户手机号'>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='name' class='modal-span'>用户密码</label>" +
            "<input type='password' class='form-control' id='user-password' " +
            "placeholder='请输入密码'>" +
            "</div>"
        )
        $(".myModal-footer").append(
            "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>",
            "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='submitUser()'>提交</button>",
        )
        $('#myModal').modal('show')
    }

    /**
     * 添加操作按钮
     * @return {string}
     */
    function AddFuntionAlty(value, row, index) {
        return [
            '<button type="button" class="btn btn-danger">删除</button>',
            '<button type="button" class="btn btn-warning">重置密码</button>',
            '<button type="button" class="btn btn-info">查看订单</button>'
        ].join("")
    }

    function closeModel() {
        $(".myModal-header").empty()
        $(".myModal-footer").empty()
        $(".myModal-body").empty();
        $('#myModal').modal('hide')
    }

    /**
     * 刷新表格数据
     **/
    function refreshTableData() {
        $("#users").bootstrapTable('refresh');
    }
</script>
</html>
