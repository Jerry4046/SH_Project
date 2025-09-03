package com.project.SH.Signup;

import com.project.SH.dao.UserDao;
import com.project.SH.domain.User;
import com.project.SH.service.SignUpService;
import com.project.SH.service.SignUpServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


public class signupTest {

    private UserDao userDao;
    private SignUpService signUpService;

    /*@BeforeEach
    public void setUp() {
        userDao = mock(UserDao.class);
        signUpService = new SignUpServiceImpl(userDao);
    }


    @Test
    public void 회원가입_성공_테스트() {
        // given
        String name = "홍길동";
        String password = "1234";
        String grade = "A";

        // when
        assertDoesNotThrow(() -> {
            signUpService.signup(name, password, grade);
        });

        // then
        verify(userDao, times(1)).save(any(User.class));
    }

    @Test
    public void 회원가입_실패_테스트_등급_잘못된_경우() {
        // given
        String name = "홍길동";
        String password = "1234";
        String grade = "Z"; // 유효하지 않은 등급

        // when & then
        assertThrows(IllegalArgumentException.class, () -> {
            signUpService.signup(name, password, grade);
        });

        verify(userDao, never()).save(any(User.class));
    }*/
}
