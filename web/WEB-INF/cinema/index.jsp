<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ftm" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: ZQL
  Date: 2021/5/26
  Time: 1:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>首页</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        a {
            cursor: pointer;
            text-decoration: none;
        }
    </style>
    <script>
        //跳转到上一页
        function previousPage(currentPage) {
            currentPage--;
            window.location.href = "${pageContext.request.contextPath}/user/toIndex?page=" + currentPage;
        }

        //下一页
        function nextPage(currentPage) {
            currentPage++;
            window.location.href = "${pageContext.request.contextPath}/user/toIndex?page=" + currentPage;
        }

        //鼠标悬停
        function mouseOver(event) {
            event.style.backgroundColor = "#CCCCCC";
        }
        //鼠标 移除
        function mouseOut(event) {
            event.style.backgroundColor = "#FFFFFF";
        }

        function toSelectSeat(arrangementId) {
            window.location.href="${pageContext.request.contextPath}/user/seat/"+arrangementId;
        }

    </script>
</head>
<body>
<nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid" style="width: 60%">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">购票大厅</a>
        </div>
        <ul class="nav navbar-nav navbar-left">
            <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/notice'">查看公告</a></li>
        </ul>
        <%--            <form class="navbar-form navbar-left" role="search">--%>
        <%--                <div class="form-group">--%>
        <%--                    <input type="text" class="form-control" placeholder="Search" style="width: 300px">--%>
        <%--                </div>--%>
        <%--                <button type="submit" class="btn btn-default">搜索电影</button>--%>
        <%--            </form>--%>
        <ul class="nav navbar-nav navbar-right">
            <c:choose>
                <c:when test="${ sessionScope.user==null }">
                    <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/register'"> 注册</a></li>
                    <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/login'"> 登录</a></li>
                </c:when>
                <c:otherwise>
                    <p class="navbar-text">欢迎您，${sessionScope.user.name}</p>
                    <li>
                        <a onclick="window.location.href='${pageContext.request.contextPath}/user/changepassword'">修改密码</a>
                    </li>
                    <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/toOrderList'">我的订单</a></li>
                    <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/logout'">退出登录</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<div style="width: 60%;margin: auto;height: 350px">
    <c:forEach items="${movies}" var="movie">

        <div class="col-sm-3 col-md-2">
            <div class="thumbnail">
                <a onclick="getArrangement(${movie.id})">
                    <img src="${pageContext.request.contextPath}/pic/${movie.picUrl}" style="height:220px;width:180px">
                </a>
                <div class="caption">
                    <p>${movie.name}</p>
                    <p>
                        <a href="#" class="btn btn-primary" role="button" data-toggle="modal" data-target="#${movie.name}">
                            电影详情
                        </a>
                    </p>
                </div>
            </div>
        </div>

        <!-- 模态框（Modal） -->
        <div class="modal fade" id="${movie.name}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"
                                aria-hidden="true">×
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            电影详情
                        </h4>
                    </div>
                    <div class="modal-body">
                        <p>电影名称：${movie.name} </p>
                        <br>
                        <p>上映时间：<ftm:formatDate value="${movie.showTime}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
                        <h3>电影简介：</h3>
                        ${movie.introduction}
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default"
                                data-dismiss="modal">关闭
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->
    </c:forEach>

</div>
<div style="width: 60%;margin: auto">
    <ul class="pager">
        <c:if test="${page.currentPage!=0}">
            <li><a onclick="previousPage(${page.currentPage})">上一页</a></li>
        </c:if>

        <c:if test="${page.currentPage!=page.total}">
            <li><a onclick="nextPage(${page.currentPage})">下一页</a></li>
        </c:if>
    </ul>
</div>

<div style="width: 60%; margin: auto">
    <script>
        var date = new Date();
        var today = date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
        getArrangement(${movies[0].id});


        /**
         * 获取排片
         */
        function getArrangement(movieId) {
            $.ajax({
                url:"${pageContext.request.contextPath}/user/getArrangement",
                dataType:"json",
                data:{
                    "movieId":movieId,
                },
                success:function (res) {
                    showArrangement(res);
                }
            });
        }

        /**
         * 展示排片
         */
        function showArrangement(res) {
            cleanNav();
            if (res.data[0].date != null){
                for (let i = 0; i < res.data.length; i++) {
                    if (i === 0){
                        $("#myTab").append("<li class='active'><a href='#"+res.data[i].date+"' data-toggle='tab'>"+res.data[i].date+"</a></li>");
                        $("#myTabContent").append("<div class='tab-pane fade in active' id='"+res.data[i].date+"'></div>")
                    }else {
                        $("#myTab").append("<li><a href='#"+res.data[i].date+"' data-toggle='tab'>"+res.data[i].date+"</a></li>")
                        $("#myTabContent").append("<div class='tab-pane fade' id='"+res.data[i].date+"'></div>")
                    }


                    $("#"+res.data[i].date).append("<table class='table'><tbody  id='table"+res.data[i].date+"'></tbody><thead>\n" +
                        "                <tr>\n" +
                        "                    <th>时间</th>\n" +
                        "                    <th>放映厅</th>\n" +
                        "                    <th>价格</th>\n" +
                        "                </tr>\n" +
                        "                </thead></table>")
                    let list = res.data[i].list;
                    for (let j = 0; j < list.length; j++) {
                        $("#table"+res.data[i].date).append("<tr onmouseover='mouseOver(this)' onmouseout='mouseOut(this)' onclick='toSelectSeat("+list[j].id+")'> <td>"+timeFormat(list[j].startTime)+"——"+timeFormat(list[j].endTime)+"</td>\n" +
                            "                    <td>"+list[j].roomChinese+"</td>\n" +
                            "                    <td>"+list[j].price+"元</td></tr>")
                    }
                }
            } else {
                var dateTime = new Date();
                var today = dateTime.getFullYear()+"-"+(dateTime.getMonth()+1)+"-"+dateTime.getDate()
                $("#myTab").append("<li class='active'><a href='#warn' data-toggle='tab'>"+today+"</a></li>");
                $("#myTabContent").append("<div class='tab-pane fade in active' id='warn'><h1>暂无排片</h1></div>")
            }
        }

        /**
         * 清空排片内容
         */
        function cleanNav() {
            $("#myTab").empty();
            $("#myTabContent").empty();
        }

        //时间字符串 取 时:分:秒
        function timeFormat(times){
            var timearr = times.replace(" ", ":").replace(/\:/g, "-").split("-");
            var timestr = ""+timearr[3]+":" + timearr[4] + ":" + timearr[5]
            //var timestr = "" + timearr[1].split("")[1] + "月" + timearr[2] + "日\t" + timearr[3] + ":" + timearr[4] + ""
            return timestr
        }
    </script>
    <ul id="myTab" class="nav nav-tabs">
    </ul>
    <div id="myTabContent" class="tab-content">

    </div>



</div>
</body>
</html>
