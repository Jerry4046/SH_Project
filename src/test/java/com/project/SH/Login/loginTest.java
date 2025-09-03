/*
package com.project.SH.Login;

import com.project.SH.domain.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class loginTest {

    @Autowired
    private LoginService loginService;

*/
/*    @Test
    public void 로그인_성공_테스트() {
        // given
        String name = "관리자";
        String password = "1234";

        // when
        User user = loginService.login(name, password);

        // then
        Assertions.assertNotNull(user); // 로그인 성공
        Assertions.assertEquals("관리자", user.getName());
        Assertions.assertEquals("uuid_Test1", user.getUuid());
        Assertions.assertEquals("N", user.getGrade());
    }*//*


    @Test
    public void 로그인_실패_테스트() {
        // given
        String name = "관리자";
        String password = "1234";

        // when
        User user = loginService.login(name, password);

        // then
        Assertions.assertNotNull(user); // 로그인 실패
        Assertions.assertNotEquals("관리", user.getName());
        Assertions.assertNotEquals("uui_Test1", user.getUuid());
        Assertions.assertNotEquals("A", user.getGrade());
    }
}
*/
