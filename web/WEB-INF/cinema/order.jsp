<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ftm" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: ZQL
  Date: 2021/5/29
  Time: 22:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>订单列表</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        a{
            cursor:pointer;
        }
    </style>
    <script>

        //跳转到上一页
        function previousPage(currentPage) {
            currentPage--;
            window.location.href = "${pageContext.request.contextPath}/user/toOrderList?currentPage=" + currentPage;
        }

        //下一页
        function nextPage(currentPage) {
            currentPage++;
            window.location.href = "${pageContext.request.contextPath}/user/toOrderList?currentPage=" + currentPage;
        }

        //鼠标悬停
        function mouseOver(event) {
            event.style.backgroundColor = "#CCCCCC";
        }
        //鼠标 移除
        function mouseOut(event) {
            event.style.backgroundColor = "#FFFFFF";
        }

        function updateOrder(orderId,action) {
            window.location.href="${pageContext.request.contextPath}/user/updateOrder?orderId="+orderId+"&action="+action;
        }
    </script>

</head>
<body>
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid" style="width: 60%">
            <div class="navbar-header">
                <a class="navbar-brand" onclick="window.location.href='${pageContext.request.contextPath}/user/toIndex';">购票大厅</a>
            </div>
            <ul class="nav navbar-nav navbar-left">
                <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/notice'">查看公告</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <c:choose>
                    <c:when test="${ sessionScope.user==null }">
                        <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/register'"> 注册</a>
                        </li>
                        <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/login'"> 登录</a></li>
                    </c:when>
                    <c:otherwise>
                        <p class="navbar-text">欢迎您，${sessionScope.user.name}</p>
                        <li>
                            <a onclick="window.location.href='${pageContext.request.contextPath}/user/changepassword'">修改密码</a>
                        </li>
                        <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/logout'">退出登录</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <div style="width: 60%;margin: auto">
        <table class="table">
            <thead>
            <tr>
                <th>电影名</th>
                <th>时间</th>
                <th>放映厅</th>
                <th>座位</th>
                <th>状态</th>
                <th>订单编号(凭此编号取票)</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
                <c:forEach items="${orderList}" var="order">

                    <tr onmouseover="mouseOver(this)" onmouseout="mouseOut(this)">
                        <td>${order.movie.name}</td>
                        <td>
                            <ftm:formatDate value="${order.arrangement.startTime}" pattern="yyyy年MM月dd日 HH:mm:ss" /> ——
                            <ftm:formatDate value="${order.arrangement.endTime}" pattern="HH:mm:ss" />
                        </td>
                        <td>${order.arrangement.roomChinese}</td>
                        <td>${order.order.seat}</td>
                        <c:if test="${order.order.status == 0}">
                            <td style="color: red">未支付</td>
                        </c:if>
                        <c:if test="${order.order.status == 1}">
                            <td style="color: #128054">已出票</td>
                        </c:if>
                        <c:if test="${order.order.status == 2}">
                            <td style="color: gray">已取消</td>
                        </c:if>
                        <td>${order.order.number}</td>
                        <td>
                            <a href="#" class="btn btn-primary" role="button" data-toggle="modal" data-target="#order${order.order.id}">
                                查看详情
                            </a>
                        </td>
                    </tr>

                    <!-- 模态框（Modal） -->
                    <div class="modal fade" id="order${order.order.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"
                                            aria-hidden="true">×
                                    </button>
                                    <h4 class="modal-title" id="myModalLabel">
                                        订单详情
                                    </h4>
                                </div>
                                <div class="modal-body">
                                    <p>电影名称：${order.movie.name} </p>
                                        <br>
                                    <p>时间：
                                        <ftm:formatDate value="${order.arrangement.startTime}" pattern="yyyy年MM月dd日 HH:mm:ss" />——
                                        <ftm:formatDate value="${order.arrangement.endTime}" pattern="HH:mm:ss" />
                                    </p>
                                        <br>
                                    <p>放映厅：${order.arrangement.roomChinese}</p>
                                        <br>
                                    <p>座位：${order.order.seat}</p>
                                        <br>
                                    <p>票数：${order.order.ticketNumber}</p>
                                        <br>
                                    <p>价格：${order.order.money}元</p>
                                        <br>
                                    <p>订单编号(凭此取票)：${order.order.number}</p>
                                        <br>
                                    <p>订单提交时间：<ftm:formatDate value="${order.order.time}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
                                </div>
                                <div class="modal-footer">
                                    <c:if test="${order.order.status == 0}">
                                        <button class="btn btn-default"
                                                onclick="updateOrder(${order.order.id},1)"
                                                style="float: left">
                                            支付订单
                                        </button>
                                        <button class="btn btn-default"
                                                onclick="updateOrder(${order.order.id},2)"
                                                style="float: left">
                                            取消订单
                                        </button>
                                    </c:if>
                                    <button type="button" class="btn btn-default"
                                            data-dismiss="modal">关闭
                                    </button>
                                </div>
                            </div><!-- /.modal-content -->
                        </div><!-- /.modal-dialog -->
                    </div><!-- /.modal -->
                </c:forEach>
            </tbody>
        </table>
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

</body>
</html>
