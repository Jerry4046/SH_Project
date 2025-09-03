<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>회원가입</title>
</head>
<body>
<h2>회원가입</h2>

<form action="${pageContext.request.contextPath}/signup" method="post">
    이름: <input type="text" name="name"><br>
    비밀번호: <input type="password" name="password"><br>
    등급: <select name="grade">
        <option value="A">관리자</option>
        <option value="N">일반회원</option>
    </select><br>
    <input type="submit" value="회원가입">
</form>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>
<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

</body>
</html>
