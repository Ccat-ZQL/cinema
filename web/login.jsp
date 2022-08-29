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
  <title>用户登录</title>
  <meta charset="utf-8">
  <link href="${pageContext.request.contextPath}/css/style.css" rel='stylesheet' type='text/css' />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>
    <script src="${pageContext.request.contextPath}/js/jquery-3.1.1.min.js"></script>
    <script>
        function login() {

            // alert($("input[name='role'] :checked").val());
            $.ajax({
                url:"${pageContext.request.contextPath}/user/userLogin",
                dataType:"json",
                data:{
                    "phone": $("#phone").val(),
                    "password": $("#password").val(),
                },
                success:function (res) {
                    if (res.code === 1){
                      if ($("input[name='role']").prop("checked")){
                        window.location.href = "${pageContext.request.contextPath}/admin/index";
                      } else {
                        window.location.href = "${pageContext.request.contextPath}/user/toIndex";
                      }
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
    <h1>影院售票系统</h1>

    <form onsubmit="return false">
      <input type="text" class="text" value="手机号"  name="phone" id="phone" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = '手机号';}">
      <input type="password" value="password"  name="password" id="password" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Password';}">
      <br>
      <input type="radio" name="role" value="1" id="role1" > <label for="role1">管理员</label>
      <input type="radio" name="role" value="0" id="role0" checked="checked"><label for="role0">普通用户</label>
      <br>
      <div class="submit" style="margin-top: 10px;width: 92%">
        <input type="submit"  value="LOGIN" onclick="login()" >
      </div>
      <a onclick="window.location.href='${pageContext.request.contextPath}/user/register'" style="cursor: pointer; color: blue">点我注册</a>
    </form>


  </div>

</div>
</body>
</html>

