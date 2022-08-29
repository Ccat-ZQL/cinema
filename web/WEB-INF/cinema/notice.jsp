<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ftm" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: ZQL
  Date: 2021/6/1
  Time: 14:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>公告</title>
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
            window.location.href = "${pageContext.request.contextPath}/user/notice?currentPage=" + currentPage;
        }

        //下一页
        function nextPage(currentPage) {
            currentPage++;
            window.location.href = "${pageContext.request.contextPath}/user/notice?currentPage=" + currentPage;
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
                        <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/toOrderList'">我的订单</a></li>
                        <li><a onclick="window.location.href='${pageContext.request.contextPath}/user/logout'">退出登录</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <div style="width: 40%;margin: auto">
        <table class="table">
            <thead>
                <tr>
                    <th>标题</th>
                    <th>内容</th>
                    <th>发布时间</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${noticeList}" var="notice">
                   <tr>
                       <td>${notice.title}</td>
                       <td>${notice.content}</td>
                       <td><ftm:formatDate value="${notice.publishTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                   </tr>
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
