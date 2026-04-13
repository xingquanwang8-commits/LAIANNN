package com.mhmp.common.exception;

import lombok.Getter;

import java.util.LinkedHashMap;
import java.util.Map;

@Getter
public class BusinessException extends RuntimeException {

    private final Integer code;
    private final Map<String, String> errors;

    public BusinessException(String message) {
        this(500, message, null);
    }

    public BusinessException(Integer code, String message) {
        this(code, message, null);
    }

    public BusinessException(String message, Map<String, String> errors) {
        this(500, message, errors);
    }

    public BusinessException(Integer code, String message, Map<String, String> errors) {
        super(message);
        this.code = code == null ? 500 : code;
        this.errors = errors == null || errors.isEmpty() ? null : new LinkedHashMap<>(errors);
    }
}
