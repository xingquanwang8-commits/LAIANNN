package com.mhmp.common.exception;

import com.mhmp.common.result.R;
import org.junit.jupiter.api.Test;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

class GlobalExceptionHandlerTest {

    private final GlobalExceptionHandler handler = new GlobalExceptionHandler();

    @Test
    void handleBindExceptionShouldReturnReadableValidationErrors() {
        BindException exception = new BindException(new Object(), "userSaveDTO");
        exception.addError(new FieldError("userSaveDTO", "username", "用户名不能为空"));
        exception.addError(new FieldError("userSaveDTO", "realName", "姓名不能为空"));

        R<Void> response = handler.handleBindException(exception);

        assertEquals(400, response.getCode());
        assertEquals("用户名不能为空；姓名不能为空", response.getMessage());
        assertEquals("用户名不能为空", response.getErrors().get("username"));
        assertEquals("姓名不能为空", response.getErrors().get("realName"));
        assertFalse(response.getSuccess());
    }

    @Test
    void handleBusinessExceptionShouldKeepBusinessMessageAndStructuredErrors() {
        BusinessException exception = new BusinessException(409, "角色编码已存在", Map.of("roleCode", "角色编码已存在"));

        R<Void> response = handler.handleBusinessException(exception);

        assertEquals(409, response.getCode());
        assertEquals("角色编码已存在", response.getMessage());
        assertEquals("角色编码已存在", response.getErrors().get("roleCode"));
        assertFalse(response.getSuccess());
    }
}
