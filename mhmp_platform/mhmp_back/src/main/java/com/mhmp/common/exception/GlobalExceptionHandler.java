package com.mhmp.common.exception;

import com.mhmp.common.result.R;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);
    private static final int BAD_REQUEST = 400;
    private static final String DEFAULT_VALIDATION_MESSAGE = "提交信息不完整，请检查后重试";
    private static final String DEFAULT_SYSTEM_MESSAGE = "系统处理失败，请稍后重试";

    @ExceptionHandler(BusinessException.class)
    public R<Void> handleBusinessException(BusinessException exception) {
        return buildFailResponse(exception.getCode(), exception.getMessage(), exception.getErrors(), DEFAULT_SYSTEM_MESSAGE);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public R<Void> handleMethodArgumentNotValidException(MethodArgumentNotValidException exception) {
        return buildValidationResponse(exception.getBindingResult().getFieldErrors());
    }

    @ExceptionHandler(BindException.class)
    public R<Void> handleBindException(BindException exception) {
        return buildValidationResponse(exception.getBindingResult().getFieldErrors());
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public R<Void> handleConstraintViolationException(ConstraintViolationException exception) {
        LinkedHashMap<String, String> errors = new LinkedHashMap<>();
        for (ConstraintViolation<?> violation : exception.getConstraintViolations()) {
            String field = resolveViolationField(violation);
            String message = sanitizeMessage(violation.getMessage(), DEFAULT_VALIDATION_MESSAGE);
            if (!field.isBlank() && !errors.containsKey(field)) {
                errors.put(field, message);
            }
        }
        return buildFailResponse(BAD_REQUEST, joinMessages(errors.values(), DEFAULT_VALIDATION_MESSAGE), errors, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public R<Void> handleHttpMessageNotReadableException(HttpMessageNotReadableException exception) {
        return buildFailResponse(BAD_REQUEST, "提交数据格式不正确，请检查填写内容", null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public R<Void> handleMissingServletRequestParameterException(MissingServletRequestParameterException exception) {
        return buildFailResponse(BAD_REQUEST, "缺少必要参数：" + exception.getParameterName(), null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public R<Void> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException exception) {
        return buildFailResponse(BAD_REQUEST, "请求参数格式不正确，请检查后重试", null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public R<Void> handleIllegalArgumentException(IllegalArgumentException exception) {
        return buildFailResponse(BAD_REQUEST, exception.getMessage(), null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public R<Void> handleMaxUploadSizeExceededException(MaxUploadSizeExceededException exception) {
        return buildFailResponse(BAD_REQUEST, "上传文件过大，请压缩后重试", null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public R<Void> handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException exception) {
        return buildFailResponse(405, "请求方法不支持，请检查后重试", null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public R<Void> handleNoResourceFoundException(NoResourceFoundException exception) {
        return buildFailResponse(404, "请求地址不存在", null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public R<Void> handleAccessDeniedException(AccessDeniedException exception) {
        return buildFailResponse(403, "没有访问权限", null, DEFAULT_VALIDATION_MESSAGE);
    }

    @ExceptionHandler(Exception.class)
    public R<Void> handleException(Exception exception) {
        log.error("Unhandled application exception", exception);
        return buildFailResponse(500, DEFAULT_SYSTEM_MESSAGE, null, DEFAULT_SYSTEM_MESSAGE);
    }

    private R<Void> buildValidationResponse(List<FieldError> fieldErrors) {
        LinkedHashMap<String, String> errors = new LinkedHashMap<>();
        for (FieldError fieldError : fieldErrors) {
            String field = fieldError.getField();
            String message = sanitizeMessage(fieldError.getDefaultMessage(), DEFAULT_VALIDATION_MESSAGE);
            if (field != null && !field.isBlank() && !errors.containsKey(field)) {
                errors.put(field, message);
            }
        }
        return buildFailResponse(BAD_REQUEST, joinMessages(errors.values(), DEFAULT_VALIDATION_MESSAGE), errors, DEFAULT_VALIDATION_MESSAGE);
    }

    private R<Void> buildFailResponse(Integer code, String message, Map<String, String> errors, String fallback) {
        return R.fail(code, sanitizeMessage(message, fallback), errors == null || errors.isEmpty() ? null : errors);
    }

    private String sanitizeMessage(String message, String fallback) {
        if (message == null) {
            return fallback;
        }
        String trimmed = message.trim();
        return trimmed.isEmpty() ? fallback : trimmed;
    }

    private String joinMessages(Collection<String> messages, String fallback) {
        String message = messages.stream()
            .map(item -> sanitizeMessage(item, ""))
            .filter(item -> !item.isBlank())
            .distinct()
            .collect(Collectors.joining("；"));
        return message.isBlank() ? fallback : message;
    }

    private String resolveViolationField(ConstraintViolation<?> violation) {
        String propertyPath = violation.getPropertyPath() == null ? "" : violation.getPropertyPath().toString();
        if (propertyPath.isBlank()) {
            return "request";
        }
        int lastSeparatorIndex = propertyPath.lastIndexOf('.');
        return lastSeparatorIndex >= 0 ? propertyPath.substring(lastSeparatorIndex + 1) : propertyPath;
    }
}
