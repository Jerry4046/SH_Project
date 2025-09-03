<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>로그인</title></head>
<body>
    <h2>로그인</h2>
    <form method="post" action="${pageContext.request.contextPath}/login">
        아이디: <input type="text" name="username"><br>
        비밀번호: <input type="password" name="password"><br>
        <input type="submit" value="로그인">
    </form>

    <c:if test="${param.error eq 'true'}">
        <p style="color:red;">아이디 또는 비밀번호가 잘못되었습니다.</p>
    </c:if>
</body>
</html>
