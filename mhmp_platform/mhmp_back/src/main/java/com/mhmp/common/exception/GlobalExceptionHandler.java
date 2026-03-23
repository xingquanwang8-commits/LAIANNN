package com.mhmp.common.exception;

import com.mhmp.common.result.Result;
import jakarta.validation.ConstraintViolationException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException exception) {
        return Result.fail(exception.getCode(), exception.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleMethodArgumentNotValidException(MethodArgumentNotValidException exception) {
        String message = exception.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(FieldError::getDefaultMessage)
            .collect(Collectors.joining("；"));
        return Result.fail(400, message);
    }

    @ExceptionHandler(BindException.class)
    public Result<Void> handleBindException(BindException exception) {
        String message = exception.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(FieldError::getDefaultMessage)
            .collect(Collectors.joining("；"));
        return Result.fail(400, message);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public Result<Void> handleConstraintViolationException(ConstraintViolationException exception) {
        return Result.fail(400, exception.getMessage());
    }

    @ExceptionHandler(AccessDeniedException.class)
    public Result<Void> handleAccessDeniedException(AccessDeniedException exception) {
        return Result.fail(403, "没有访问权限");
    }

    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception exception) {
        return Result.fail("系统异常：" + exception.getMessage());
    }
}
