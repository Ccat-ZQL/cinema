<%--
  Created by IntelliJ IDEA.
  User: Mango
  Date: 2021/5/26
  Time: 14:53
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
    <title>电影管理</title>
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

    <script>
        window.operateEvents = {
            /**
             * 查看详情 按钮点击事件
             * @param e
             * @param value
             * @param row
             * @param index
             */
            "click .btn-primary": function (e, value, row, index) {
                showDetail(row.id)
            },

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
                editMovie(row.id)
            },

            /**
             * 查看场次 按钮点击事件
             * @param e
             * @param value
             * @param row
             * @param index
             */
            "click .btn-info": function (e, value, row, index) {
                arrangeMovie(row.id)
            }
        }
    </script>
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
    </div

    ><!-- 安排电影场次 -->
    <div class="modal fade" id="addArrangement" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
         style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" data-backdrop=”static”>
        <div class="modal-dialog" style="width: auto">
            <div class="modal-content">
                <div class="addArrangement-header modal-header">

                </div>
                <div class="addArrangement-body modal-body">

                </div>
                <div class="addArrangement-footer modal-footer">

                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

    <!-- 座位详情显示 -->
    <div class="modal fade" id="seatDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabelSeat" aria-hidden="true"
         style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" data-backdrop=”static”>
        <div class="modal-dialog" style="width: auto">
            <div class="modal-content">
                <div class="seatModal modal-body">
                    <div id="seatDiv">
                        <div style="height: 3px; width: 70%; background: gray; margin: 0 auto 150px; text-align: center; font-weight: bold">屏幕</div>
                        <div id="seatContent" ></div>
                    </div>
                </div>
                <div class="seatModal modal-footer">
                    <button type="button" class="btn btn-primary" style="float: right; font-weight: bold; margin-right: 15px" onclick="closeSeatDetailModal()">关闭</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

    <!--放大图的imgModal-->
    <div class="modal fade bs-example-modal-lg text-center" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" >
        <div class="modal-dialog modal-lg" style="display: inline-block; width: auto;">
            <div class="modal-content">
                <img  id="imgInModalID"
                      class="carousel-inner img-responsive img-rounded"
                      onclick="closeImageViewer()"
                      onmouseover="this.style.cursor='pointer';this.style.cursor='hand'"
                      onmouseout="this.style.cursor='default'"
                />
            </div>
        </div>
    </div>

    <div class="container" style="margin-top: 100px">
        <div style="margin-bottom: 20px;">
            <span id="table-name">>>电影上映列表</span>
            <button type="button" class="btn btn-danger" style="float: right; font-weight: bold" onclick="delMulti()">批量删除</button>
            <button type="button" class="btn btn-success" style="float: right; font-weight: bold; margin-right: 10px" onclick="addMovie()">添加电影</button>
        </div>
        <table id="movies" style="table-layout:fixed; width: 100%" class="table text-nowrap"></table>
    </div>
</body>
<script>

    /**
     * 初始化table
     **/
    $(function () {
        $('#movies').bootstrapTable({
            url: "${pageContext.request.contextPath}/admin/movie",  //请求地址
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
                    let pageSize=$('#movies').bootstrapTable('getOptions').pageSize;
                    //获取当前是第几页
                    let pageNumber=$('#movies').bootstrapTable('getOptions').pageNumber;
                    //返回序号，注意index是从0开始的，所以要加上1
                    return pageSize * (pageNumber - 1) + index + 1;
                },
                width: 80
            }, {
                title : 'id',
                field : 'id',
                visible: false,
            }, {
                title : '电影名',
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
                title : '上映时间',
                field : 'showTime',
                sortable : true,
                align: "center",
                width: 200
            },{
                title : '电影介绍',
                field : 'introduction',
                sortable : false,
                align: "center",
                cellStyle:{
                    css:{
                        "overflow": "hidden",
                        "text-overflow": "ellipsis",
                        "white-space": "nowrap",
                        "width": "auto"
                    }
                }
            },{
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

    /**
     * 添加操作按钮
     * @return {string}
     */
    function AddFuntionAlty(value, row, index) {
        return [
            '<button type="button" class="btn btn-primary">查看详情</button>',
            '<button type="button" class="btn btn-danger">删除</button>',
            '<button type="button" class="btn btn-warning">编辑</button>',
            '<button type="button" class="btn btn-info">查看场次</button>'
        ].join("")
    }

    function arrangeMovie(id) {
        $.ajax({
            type: "get",
            url: "${pageContext.request.contextPath}/admin/movie/detail",
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
                        "   <span style='font-weight: bold; float:left;'>"+res.name+"场次安排如下</span>" +
                        "</h3><button style='float: right;' type='button' class='btn btn-success'" +
                        "       onclick='showAddArrangementModal("+id+")'>添加场次</button>"
                    )
                    $(".myModal-body").append(
                        "<table id='arrangement' style='width: 1900px' style='table-layout:fixed; width: 100%' class='table text-nowrap'></table>"
                    )
                    $(".myModal-footer").append(
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>",
                    )
                    $('#arrangement').bootstrapTable({
                        url: "${pageContext.request.contextPath}/admin/am?id=" + id,  //请求地址
                        striped : true, //是否显示行间隔色
                        pageNumber : 1, //初始化加载第一页
                        pagination : true,//是否分页
                        sidePagination : 'client',//server:服务器端分页|client：前端分页
                        pageSize : 5,//单页记录数
                        pageList : [5, 10],//可选择单页记录数
                        showRefresh : false,//刷新按钮
                        columns : [{
                            title : '影厅',
                            field : 'roomChinese',
                            align: "center",
                        },{
                            title : '价格',
                            field : 'price',
                            align: "center",
                        }, {
                            title : 'id',
                            field : 'id',
                            visible: false,
                        }, {
                            title : '开始时间',
                            field : 'startTime',
                            sortable : true,
                            align: "center",
                        }, {
                            title : '结束时间',
                            field : 'endTime',
                            sortable : true,
                            align: "center",
                        },{
                            title : '操作',
                            field : 'Button',
                            align: "center",
                            formatter: function (value, row, index) {
                                return "<button type='button' class='btn btn-primary' onclick='showSeatDetail("+row.id+")'>查看座位详情</button>" +
                                    "<button type='button' style='margin-left: 30px;' class='btn btn-danger' onclick='delArrangement("+row.id+")'>删除</button>"
                            },  //表格中增加按钮
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

    function showSeatDetail(id) {
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/am/seat/" + id,
            type: "get",
            dataType: "json",
            success: function (res) {
                if (res != null) {
                    // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
                    $('#seatDetail').modal({backdrop: 'static', keyboard: false});
                    for (let i = 0; i < res.length; i++) {
                        let seats = res[i].seats
                        for (let j = 0; j < seats.length; j++) {
                            let seatItem = seats[j]
                            $("#seatContent").append(
                                "<div style='width: 90px; text-align: right; height: 50px; float:left; line-height: 100%; font-size: large'>" +
                                "    <div style='display: "+(seatItem.isShow ? 'block' : 'none')+"'>" +
                                "         <label for='"+seatItem.index+"'>"+seatItem.index+"</label>" +
                                "         <input type='checkbox' style='width: 15px; height: 15px;' id='"+seatItem.index+"' value='"+seatItem.index+"'" +
                                "                disabled "+(seatItem.isOccupied ? 'checked' : '') +
                                "          />" +
                                "    </div>" +
                                "</div>"
                            )
                        }
                        $("#seatContent").append("<div style='clear:both'></div>")
                    }
                    showSeatDetailModal();
                } else {
                    alert("出错了，请稍后重试")
                }
            },
            error: function () {
                alert("出错了，请稍后重试")
            }
        })
    }

    function delArrangement(id) {
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/am/del/" + id,
            dataType: "json",
            success: function (res) {
                if (res == true) {
                    $("#arrangement").bootstrapTable('refresh');
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

    /***
     * 编辑电影，弹出模态框
     * */
    function editMovie(movieId) {
        $.ajax({
            type: "get",
            url: "${pageContext.request.contextPath}/admin/movie/detail",
            dataType: "json",
            data: {
                "id": movieId
            },
            success: function (res) {
                if (res != null) {
                    // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
                    $('#myModal').modal({backdrop: 'static', keyboard: false});
                    $(".myModal-header").append(
                        "<h3 class='modal-title' id='myModalLabel'>" +
                        "   <span style='font-weight: bold'>编辑电影信息</span>" +
                        "</h3>"
                    )

                    $(".myModal-body").append(
                        "<div class='form-group'>" +
                        "<label for='name' class='modal-span'>电影名称</label>" +
                        "<input type='text' class='form-control' id='movie-name' value='"+res.name+"' " +
                        "placeholder='请输入电影名称'>" +
                        "</div>" +
                        "<div class='form-group'>" +
                        "<label for='introduction' class='modal-span'>电影简介</label>" +
                        " <textarea class='form-control' id='introduction'" +
                        " name='introduction' rows='5' style='min-width: 90%'>"+res.introduction+"</textarea>" +
                        "</div>" +
                        "<div class='form-group'>" +
                        "<label for='name' class='modal-span'>电影上映时间</label>" +
                        "<div class='layui-form'>" +
                        "  <div class='layui-form-item'>" +
                        "    <div class='layui-inline'>" +
                        "      <div class='layui-input-inline'>" +
                        "        <input type='text' class='form-control' style='margin-top:3px' id='showTimePicker' placeholder='yyyy-MM-dd' value='"+handleTime(res.showTime)+"'>" +
                        "      </div>" +
                        "    </div>" +
                        "  </div>" +
                        "</div>" +
                        "<div class='form-group'>" +
                        "<label class='modal-span'>电影封面图片</label>" +
                        "<br />" +
                        "<div class='container'>" +
                        "    <div class='page-header'>" +
                        "        <form>" +
                        "            <div class='form-group' id='uploadForm' enctype='multipart/form-data'>" +
                        "                <div class='fileinput fileinput-new' data-provides='fileinput'  id='exampleInputUpload'>" +
                        "                    <div class='fileinput-new thumbnail' style='width: 200px;height: auto;max-height:150px;'>" +
                        "                        <img id='picImg' style='width: 100%;height: auto;max-height: 140px;' src='${pageContext.request.contextPath}/pic/noimage.png' alt='' />" +
                        "                    </div>" +
                        "                    <div class='fileinput-preview fileinput-exists thumbnail' style='max-width: 200px; max-height: 150px;'></div>" +
                        "                    <div>" +
                        "                        <span class='btn btn-primary btn-file'>" +
                        "                            <span class='fileinput-new'>选择文件</span>" +
                        "                            <span class='fileinput-exists'>换一张</span>" +
                        "                            <input type='file' name='pic1' id='picID' accept='image/gif,image/jpeg,image/x-png'/>" +
                        "                        </span>" +
                        "                        <a href='javascript:;' class='btn btn-warning fileinput-exists' data-dismiss='fileinput'>移除</a>" +
                        "                    </div>" +
                        "                </div>" +
                        "            </div>" +
                        "        </form>" +
                        "    </div>" +
                        "</div>"
                    )
                    $("#picImg").attr("src", "${pageContext.request.contextPath}/pic/" + res.picUrl);
                    $(".myModal-footer").append(
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>",
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='updateMovie("+movieId+")'>更新</button>",
                    )
                    layui.use('laydate', function () {
                        const laydate = layui.laydate;
                        laydate.render({
                            elem: "#showTimePicker",
                            type: "date",
                        })
                    })
                    $('#myModal').modal('show')
                } else {
                    alert("请求出错了，请稍后再试")
                }
            },
            error: function () {
                alert("请求出错了，请稍后再试")
            }
        })
    }

    /**
     * 提交修改电影信息
     * */
    function updateMovie(id) {
        let formData = new FormData();
        let file = $("#picID")[0].files[0];
        if (file != null) {
            if (!(file.type == "image/jpeg" || file.type == "image/png")) {
                alert("请上传图片格式的文件");
                return;
            }
        }
        formData.append("id", id)
        formData.append("name", $("#movie-name").val())
        formData.append("introduction", $("#introduction").val())
        formData.append("showTime", $("#showTimePicker").val() + " 00:00:00")
        formData.append("file", file)
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/movie/updateMovie",
            type: "post",
            data: formData,
            async: false,
            contentType: false,
            processData: false,
            success: function (res) {
                if (res == true) {
                    alert("更新成功");
                    closeModel();
                    refreshTableData();
                } else {
                    alert("更新失败")
                }
            },
            error: function () {
                alert("出错了，请稍后再试！")
            }
        })
    }

    function handleTime(date) {
        let split = date.split(" ");
        return split[0];
    }

    /***
     * 添加电影弹模态框
     * */
    function addMovie() {
        // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
        $('#myModal').modal({backdrop: 'static', keyboard: false});
        $(".myModal-header").append(
            "<h3 class='modal-title' id='myModalLabel'>" +
            "   <span style='font-weight: bold'>添加电影</span>" +
            "</h3>"
        )
        $(".myModal-body").append(
            "<div class='form-group'>" +
                "<label for='name' class='modal-span'>电影名称</label>" +
                "<input type='text' class='form-control' id='movie-name' " +
                    "placeholder='请输入电影名称'>" +
            "</div>" +
            "<div class='form-group'>" +
                "<label for='introduction' class='modal-span'>电影简介</label>" +
                " <textarea class='form-control' id='introduction'" +
                    " name='introduction' rows='5' style='min-width: 90%'></textarea>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label for='name' class='modal-span'>电影上映时间</label>" +
            "<div class='layui-form'>" +
            "  <div class='layui-form-item'>" +
            "    <div class='layui-inline'>" +
            "      <div class='layui-input-inline'>" +
            "        <input type='text' class='form-control' style='margin-top:3px' id='showTimePicker' placeholder='点我选择日期'>" +
            "      </div>" +
            "    </div>" +
            "  </div>" +
            "</div>" +
            "<div class='form-group'>" +
            "<label class='modal-span'>电影封面图片</label>" +
            "<br />" +
            "<div class='container'>" +
            "    <div class='page-header'>" +
            "        <form>" +
            "            <div class='form-group' id='uploadForm' enctype='multipart/form-data'>" +
            "                <div class='fileinput fileinput-new' data-provides='fileinput'  id='exampleInputUpload'>" +
            "                    <div class='fileinput-new thumbnail' style='width: 200px;height: auto;max-height:150px;'>" +
            "                        <img id='picImg' style='width: 100%;height: auto;max-height: 140px;' src='${pageContext.request.contextPath}/pic/noimage.png' alt='' />" +
            "                    </div>" +
            "                    <div class='fileinput-preview fileinput-exists thumbnail' style='max-width: 200px; max-height: 150px;'></div>" +
            "                    <div>" +
            "                        <span class='btn btn-primary btn-file'>" +
            "                            <span class='fileinput-new'>选择文件</span>" +
            "                            <span class='fileinput-exists'>换一张</span>" +
            "                            <input type='file' name='pic1' id='picID' accept='image/gif,image/jpeg,image/x-png'/>" +
            "                        </span>" +
            "                        <a href='javascript:;' class='btn btn-warning fileinput-exists' data-dismiss='fileinput'>移除</a>" +
            "                    </div>" +
            "                </div>" +
            "            </div>" +
            "        </form>" +
            "    </div>" +
            "</div>"
        )
        $(".myModal-footer").append(
            "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>",
            "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='submitMovie()'>提交</button>",
        )

        layui.use('laydate', function () {
            const laydate = layui.laydate;
            laydate.render({
                elem: "#showTimePicker",
                type: "date",
            })
        })
        $('#myModal').modal('show')
    }

    /**
     *  电影按钮提交
     **/
    function submitMovie() {
        let formData = new FormData();
        let file = $("#picID")[0].files[0];
        if (file == null) {
            alert("请上传电影封面图片");
            return;
        }
        if (!(file.type == "image/jpeg" || file.type == "image/png")) {
            alert("请上传图片格式的文件");
            return;
        }
        formData.append("name", $("#movie-name").val())
        formData.append("introduction", $("#introduction").val())
        formData.append("showTime", $("#showTimePicker").val() + " 00:00:00")
        formData.append("file", file)
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/movie/addMovie",
            type: "post",
            data: formData,
            async: false,
            contentType: false,
            processData: false,
            success: function (res) {
                if (res == true) {
                    alert("添加成功");
                    closeModel();
                    refreshTableData();
                } else {
                    alert("添加失败")
                }
            },
            error: function () {
                alert("出错了，请稍后再试！")
            }
        })
    }

    /**
     * 显示图片大图
     **/
    $('#file').change(function(){
        let file = $('#file').get(0).files[0];
        let reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload=function(e){
            $('#imgShow').get(0).src = e.target.result;
        }
    });

    /**
     * 批量删除电影
     **/
    function delMulti() {
        let checkIds;
        checkIds = getIdSelections();
        if (checkIds == "" || checkIds == null) {
            alert("请先选择电影");
            return;
        }

        if (confirm("是否删除这些电影？")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/movie/delMulti",
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
        return $.map($("#movies").bootstrapTable('getSelections'), function(row) {
            return row.id
        })
    }


    /**
     * 单个删除电影
     **/
    function del(id) {
        if (confirm("是否删除当前电影?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/movie/del",
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
     * 刷新表格数据
     **/
    function refreshTableData() {
        $("#movies").bootstrapTable('refresh');
    }

    /**
     * 刷新表格数据
     **/
    function refreshArrangemenTableData() {
        $("#arrangement").bootstrapTable('refresh');
    }

    /**
     * 查看详情
     * @param id
     */
    function showDetail(id) {
        // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
        $('#myModal').modal({backdrop: 'static', keyboard: false});
        //modal-body
        $.ajax({
            type: "get",
            url: "${pageContext.request.contextPath}/admin/movie/detail",
            dataType: "json",
            data: {
                "id": id
            },
            success: function (res) {
                if (res != null) {
                    $(".myModal-header").append(
                        "<h3 class='modal-title' id='myModalLabel'>" +
                        "   <span style='font-weight: bold'>电影详情</span>" +
                        "</h3>"
                    )
                    $(".myModal-body").append(
                        "<div class='modal-div'><span class='modal-span'>电影名称：</span>"+res.name+"</div>" +
                        "<div class='modal-div'><span class='modal-span'>上映时间：</span>"+res.showTime+ "</div>"+
                        "<div class='modal-div'><span class='modal-span'>简介：</span>"+res.introduction+"</div>"+
                        "<div class='modal-div'><span class='modal-span'>电影封面：</span>" +
                            "<img title='点我查看大图' onclick='showImage(\""+"${pageContext.request.contextPath}/pic/" +res.picUrl+"\")' " +
                                "style='height:150px; width:200px' src='${pageContext.request.contextPath}/pic/"+res.picUrl+"'" +
                            "/>" +
                        "</div>"
                    )
                    $(".myModal-footer").append(
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeModel()'>关闭</button>"
                    )
                } else {
                    alert("出错了，请稍后重试")
                }
            },
            error: function () {
                alert("出错了，请稍后重试")
            }
        })
        $('#myModal').modal('show')
    }

     function closeModel() {
         $(".myModal-header").empty()
         $(".myModal-footer").empty()
         $(".myModal-body").empty();
         $('#myModal').modal('hide')
     }

    //显示大图
    function showImage(source) {
        $("#imgModal").find("#imgInModalID").attr("src",source);
        $("#imgModal").modal("show");
    }
    //关闭
    function closeImageViewer() {
        $("#imgModal").modal('hide');
    }

    function showSeatDetailModal() {
        $("#seatDetail").modal('show')
    }

    function closeSeatDetailModal() {
        $("#seatContent").empty()
        $("#seatDetail").modal('hide')
    }

    function showAddArrangementModal(id) {
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/sr",
            success: function (res) {
                if (res == null) {
                    alert("出错了，请稍后重试")
                } else {
                    // 只有点击关闭才能关闭模态框，点击空白出不能自动关闭
                    $('#addArrangement').modal({backdrop: 'static', keyboard: false});
                    $(".addArrangement-header").append(
                        "<h3 class='modal-title' id='myModalLabel'>" +
                        "   <span style='font-weight: bold'>安排电影场次</span>" +
                        "</h3>"
                    )
                    $(".addArrangement-body").append(
                        "<div class='form-group'>" +
                        "<label for='name' class='modal-span'>影厅</label>" +
                        "<div class='dropdown' style='margin-top: 10px'>" +
                        "        <select id='movieHouseId' class='form-control'>" +

                        "        </select>" +
                        "  </div>" +
                        "</div>" +
                        "<div class='form-group'>" +
                        "<label for='introduction' class='modal-span'>价格</label>" +
                        "<input type='number' placeholder='请输入该场电影价格' id='moviePrice' class='form-control' value='0'/>" +
                        "</div>" +
                        "<div class='form-group'>" +
                        "<label for='name' class='modal-span'>电影开场时间</label>" +
                        "<div class='layui-form'>" +
                        "  <div class='layui-form-item'>" +
                        "    <div class='layui-inline'>" +
                        "      <div class='layui-input-inline'>" +
                        "        <input type='text' class='form-control' style='margin-top:3px' id='startTimePicker' placeholder='点我选择时间'>" +
                        "      </div>" +
                        "    </div>" +
                        "  </div>" +
                        "</div>"+
                        "<div class='form-group'>" +
                        "<label for='name' class='modal-span'>电影结束时间</label>" +
                        "<div class='layui-form'>" +
                        "  <div class='layui-form-item'>" +
                        "    <div class='layui-inline'>" +
                        "      <div class='layui-input-inline'>" +
                        "        <input type='text' class='form-control' style='margin-top:3px' id='endTimePicker' placeholder='点我选择时间'>" +
                        "      </div>" +
                        "    </div>" +
                        "  </div>" +
                        "</div>"
                    )
                    $(".addArrangement-footer").append(
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='closeAddArrangementModal()'>关闭</button>",
                        "<button type='button' class='btn btn-primary' data-dismiss='modal' onclick='submitArrangement("+id+")'>提交</button>",
                    )
                    for (let i = 0; i < res.length; i++) {
                        let house = res[i];
                        $("#movieHouseId").append(
                            "<option value='"+house.id+"'>"+house.chineseNumber+"号厅</option>"
                        )
                    }
                    layui.use('laydate', function () {
                        const laydate = layui.laydate;
                        laydate.render({
                            elem: "#startTimePicker",
                            type: "datetime",
                            format: "yyyy-MM-dd HH:mm:ss"
                        })
                        laydate.render({
                            elem: "#endTimePicker",
                            type: "datetime",
                            format: "yyyy-MM-dd HH:mm:ss"
                        })
                    })

                    $("#addArrangement").modal('show')
                }
            },
            error: function () {
                alert("出错了，请稍后重试")
            }
        })
    }
    
    function checkMoney(value) {
        let reg = /(?!^0*(\.0{1,2})?$)^\d{1,13}(\.\d{1,2})?$/;
        if(reg.test(value)) {
            return true;
        } else {
            return false;
        }
    }

    function submitArrangement(id) {
        let price = $("#moviePrice").val();
        if (!checkMoney(price)) {
            alert("请输入正确的金额")
            return;
        }
        let startTime = $("#startTimePicker").val();
        let endTime = $("#endTimePicker").val();
        if (startTime >= endTime) {
            alert("时间选择有误，请仔细检查")
            return;
        }
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/am/add",
            type: "post",
            dataType: "json",
            data: {
                "movieId": id,
                "roomId": $("#movieHouseId").val(),
                "startTime": startTime,
                "endTime": endTime,
                "price": price
            },
            success: function (res) {
                if (res == true) {
                    refreshArrangemenTableData()
                    alert("添加成功")
                    closeAddArrangementModal();
                } else {
                    alert("出错了，请稍后重试1")
                }
            },
            error: function () {
                alert("出错了，请稍后重试")
            }
        })
    }

    function closeAddArrangementModal() {
        $(".addArrangement-header").empty()
        $(".addArrangement-body").empty()
        $(".addArrangement-footer").empty()
        $("#addArrangement").modal('hide')
    }
</script>
</html>
