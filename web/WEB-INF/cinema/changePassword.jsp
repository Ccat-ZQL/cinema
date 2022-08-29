<%--
  Created by IntelliJ IDEA.
  User: ZQL
  Date: 2021/5/25
  Time: 23:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<html>
<head>
    <title>用户修改密码</title>
    <meta charset="utf-8">
    <link href="${pageContext.request.contextPath}/css/style.css" rel='stylesheet' type='text/css' />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>
    <script src="${pageContext.request.contextPath}/js/jquery-3.1.1.min.js"></script>
    <script>
        function changePwd() {
            $.ajax({
                url:"${pageContext.request.contextPath}/user/changePwd",
                dataType:"json",
                data:{
                    "phone": $("#phone").val(),
                    "password": $("#password").val()
                },
                success:function (res) {
                    if (res.code === 1){
                        window.location.href="${pageContext.request.contextPath}/user/login";
                    } else {
                        alert(res.message);
                    }
                }
            })
        }
    </script>
</head>
<body>
<div class="main">
    <div class="login-form">
        <h1>修改密码</h1>
        <form onclick="return false">
            <input type="text" class="text"  name="phone" id="phone" placeholder="手机号">
            <input type="password"  name="password" id="password" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Password';}">
            <br>
            <br>
            <div class="submit" style="margin-top: 10px">
                <input type="submit"  value="CHANGE" onclick="changePwd()" >
            </div>
        </form>

    </div>

</div>
</body>
</html>

