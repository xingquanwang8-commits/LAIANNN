package com.mhmp.common.exception;

import com.mhmp.common.result.Result;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.util.List;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException exception) {
        return Result.fail(exception.getCode(), exception.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleMethodArgumentNotValidException(MethodArgumentNotValidException exception) {
        return Result.fail(400, joinFieldMessages(exception.getBindingResult().getFieldErrors()));
    }

    @ExceptionHandler(BindException.class)
    public Result<Void> handleBindException(BindException exception) {
        return Result.fail(400, joinFieldMessages(exception.getBindingResult().getFieldErrors()));
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public Result<Void> handleConstraintViolationException(ConstraintViolationException exception) {
        String message = exception.getConstraintViolations().stream()
            .map(violation -> violation.getMessage())
            .filter(item -> item != null && !item.isBlank())
            .collect(Collectors.joining("；"));
        return Result.fail(400, message.isBlank() ? "提交信息不完整，请检查后重试" : message);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public Result<Void> handleHttpMessageNotReadableException(HttpMessageNotReadableException exception) {
        return Result.fail(400, "提交数据格式不正确，请检查填写内容");
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public Result<Void> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException exception) {
        return Result.fail(400, "请求参数格式不正确，请检查后重试");
    }

    @ExceptionHandler(AccessDeniedException.class)
    public Result<Void> handleAccessDeniedException(AccessDeniedException exception) {
        return Result.fail(403, "没有访问权限");
    }

    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception exception) {
        log.error("Unhandled application exception", exception);
        return Result.fail("系统处理失败，请稍后重试");
    }

    private String joinFieldMessages(List<FieldError> fieldErrors) {
        String message = fieldErrors.stream()
            .map(FieldError::getDefaultMessage)
            .filter(item -> item != null && !item.isBlank())
            .collect(Collectors.joining("；"));
        return message.isBlank() ? "提交信息不完整，请检查后重试" : message;
    }
}
