package com.mhmp.common.result;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode
@JsonInclude(JsonInclude.Include.NON_NULL)
public class R<T> {

    public static final int SUCCESS_CODE = 200;
    public static final int FAIL_CODE = 500;
    private static final String DEFAULT_SUCCESS_MESSAGE = "操作成功";
    private static final String DEFAULT_FAIL_MESSAGE = "系统处理失败，请稍后重试";

    private Integer code;
    private String message;
    private T data;
    private Boolean success;
    private Map<String, String> errors;
    private Long timestamp;

    public R(Integer code, String message, T data) {
        this(code, message, data, null);
    }

    public R(Integer code, String message, T data, Map<String, String> errors) {
        this.code = code;
        this.message = message;
        this.data = data;
        this.errors = errors;
        this.success = SUCCESS_CODE == code;
        this.timestamp = System.currentTimeMillis();
    }

    @JsonGetter("msg")
    public String getMsg() {
        return message;
    }

    public static <T> R<T> success() {
        return new R<>(SUCCESS_CODE, DEFAULT_SUCCESS_MESSAGE, null);
    }

    public static <T> R<T> success(T data) {
        return new R<>(SUCCESS_CODE, DEFAULT_SUCCESS_MESSAGE, data);
    }

    public static <T> R<T> success(String message, T data) {
        return new R<>(SUCCESS_CODE, message, data);
    }

    public static <T> R<T> fail(String message) {
        return new R<>(FAIL_CODE, message == null || message.isBlank() ? DEFAULT_FAIL_MESSAGE : message, null);
    }

    public static <T> R<T> fail(Integer code, String message) {
        return new R<>(code == null ? FAIL_CODE : code, message == null || message.isBlank() ? DEFAULT_FAIL_MESSAGE : message, null);
    }

    public static <T> R<T> fail(Integer code, String message, Map<String, String> errors) {
        return new R<>(code == null ? FAIL_CODE : code, message == null || message.isBlank() ? DEFAULT_FAIL_MESSAGE : message, null, errors);
    }
}
