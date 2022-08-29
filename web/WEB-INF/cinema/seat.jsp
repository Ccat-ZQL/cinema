<%--
  Created by IntelliJ IDEA.
  User: Mango
  Date: 2021/5/26
  Time: 0:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <script src="${pageContext.request.contextPath}/js/jquery-3.1.1.min.js"></script>
    <title>座位展示</title>
    <style>
        #seatDiv {
            position: absolute;
            left:50%;
            top:50%;
            transform: translate(-50%, -50%);
        }
    </style>
</head>
<body>
    <div id="seatDiv">
        <div style="height: 3px; width: 70%; background: gray; margin: 0 auto 150px; text-align: center; font-weight: bold">屏幕</div>
        <c:forEach items="${seat}" var="row">
            <c:forEach items="${row.seats}" var="seatItem" varStatus="divIndex">
                <div style="width: 90px; text-align: right; height: 50px; float:left; line-height: 100%; font-size: large">
                    <div style="display: ${seatItem.isShow ? 'block' : 'none'}">
                        <label for="${seatItem.index}">${seatItem.index}</label>
                        <input type="checkbox" style="width: 15px; height: 15px" id="${seatItem.index}" value="${seatItem.index}"
                            ${seatItem.isOccupied ? "disabled":""}
                            ${seatItem.isOccupied ? "checked":""}
                            onclick="chooseSeat(this)"
                        />
                    </div>
                </div>
            </c:forEach>
            <div style="clear:both"></div>
        </c:forEach>
        <button onclick="order()" style="height: 35px;
    width: 150px;
    float: right;
    text-align: center;
    font-size: 20px;">提交</button>

    </div>
</body>
    <script>
        let choseArr = [];

        /**
         * 选中checkbox，将该值添加到choseArr
         * 取消checkbox，将该值从choseArr中移除
         * @param item
         */
        function chooseSeat(item) {
            if ($(item).prop('checked')) {
                choseArr.push($(item).val());
            } else {
                delValInArr($(item).val(), choseArr)
            }
        }

        /**
         * 删除 array中的value
         * @param value
         * @param array
         */
        function delValInArr(value,array){
            var pos=$.inArray(value,array);
            array.splice(pos,1);
        }

        /**
         * 点击提交
         */
        function order() {
            if (choseArr.length === 0){
                alert("请先选择座位");
                return;
            }
            $.ajax({
                url: "${pageContext.request.contextPath}/user/order",
                type: "GET",
                dataType: "json",
                data: {
                    "seats": choseArr.join(",").toString(),
                    "arrangementId":${arrangementId}
                },
                success: function (res) {
                    if (res.result > 0){
                        window.location.href = "${pageContext.request.contextPath}/user/toOrderList"
                    } else {
                        alert("提交失败！");
                    }
                }
            })
        }
    </script>
</html>
