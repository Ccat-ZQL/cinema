<%--
  Created by IntelliJ IDEA.
  User: Mango
  Date: 2021/6/1
  Time: 15:15
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
    <title>公告管理</title>
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

        #seatDiv {
            width: 1000px;
        }
    </style>
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



    <div class="container" style="margin-top: 100px; width: 100%;">
        <div style="margin-bottom: 20px;" class="form-group">
            <span id="table-name">>>公告列表</span>
            <button type="button" class="btn btn-danger" style="float: right; font-weight: bold" onclick="delMulti()">批量删除</button>
            <button type="button" class="btn btn-success" style="float: right; font-weight: bold; margin-right: 10px" onclick="addNotice()">添加公告</button>
        </div>
        <table id="notices" style="table-layout:fixed; width: 100%;" class="table text-nowrap"></table>
    </div>
</body>

<script>
    $(function () {
        $('#notices').bootstrapTable({
            url: "${pageContext.request.contextPath}/admin/notice/getAll",
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
            }, {
                title : '标号',
                field : 'no',
                align: "center",
                formatter: function (value, row, index) {
                    //获取每页显示的数量
                    let pageSize=$('#notices').bootstrapTable('getOptions').pageSize;
                    //获取当前是第几页
                    let pageNumber=$('#notices').bootstrapTable('getOptions').pageNumber;
                    //返回序号，注意index是从0开始的，所以要加上1
                    return pageSize * (pageNumber - 1) + index + 1;
                },
            }, {
                title : 'id',
                field : 'id',
                visible: false
            },{
                title : '公告标题',
                field : 'title',
                align: "center",
            },{
                title : '公告内容',
                field : 'content',
                align: "center",
            }, {
                title : '发布时间',
                field : 'publishTime',
                sortable : true,
                align: "center",
            }, {
                title : '操作',
                field : 'Button',
                align: "center",
                formatter: function (value, row, index) {
                    return "<button type='button' class='btn btn-danger' onclick='delNotice("+row.id+")'>删除</button>";
                },
                cellStyle: {
                    css: {

                    }
                },
            }]
        })
    })

    /***
     * 添加公告模态框
     * */
    function addNotice() {
        // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
        $('#myModal').modal({backdrop: 'static', keyboard: false});
        $(".myModal-header").append(
            "<h3 class='modal-title' id='myModalLabel'>" +
            "   <span style='font-weight: bold'>添加公告</span>" +
            "</h3>"
        )
        $(".myModal-body").append(
            "<div class='form-group'>" +
            "<label for='name' class='modal-span'>公告标题</label>" +
            "<input type='text' class='form-control' id='notice-title' " +
            "placeholder='请输入公告标题'>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='introduction' class='modal-span'>公告内容</label>" +
            " <textarea class='form-control' id='notice-content'" +
            " name='noticeContent' rows='5' placeholder='请输入公告内容' style='min-width: 90%'></textarea>" +
            "</div>"
        )
        $(".myModal-footer").append(
            "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>",
            "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='submitNotice()'>提交</button>",
        )
        $('#myModal').modal('show')
    }

    /**
     * 批量删除公告
     **/
    function delMulti() {
        let checkIds;
        checkIds = getIdSelections();
        if (checkIds == "" || checkIds == null) {
            alert("请先选择公告");
            return;
        }

        if (confirm("是否删除这些公告？")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/notice/delMul",
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
        return $.map($("#notices").bootstrapTable('getSelections'), function(row) {
            return row.id
        })
    }

    /**
     * 单个删除公告
     **/
    function delNotice(id) {
        if (confirm("是否删除当前公告?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/notice/delOne",
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

    /**
     *  添加用户按钮提交
     **/
    function submitNotice() {
        let formData = new FormData();
        let title = $("#notice-title").val();
        if (title == "" || title == null) {
            alert("请输入公告标题")
            return;
        }
        let content = $("#notice-content").val();
        if (content == "" || content == null) {
            alert("请输入公告内容")
            return;
        }
        formData.append("title", title)
        formData.append("content", content)
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/notice/addNotice",
            type: "post",
            data: formData,
            async: false,
            contentType: false,
            processData: false,
            success: function (res) {
                if (res == true) {
                    alert("添加成功");
                    refreshTableData();
                    closeModel();
                } else {
                    alert("添加失败")
                }
            },
            error: function () {
                alert("出错了，请稍后再试！")
            }
        })
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
        $("#notices").bootstrapTable('refresh');
    }
</script>
</html>
