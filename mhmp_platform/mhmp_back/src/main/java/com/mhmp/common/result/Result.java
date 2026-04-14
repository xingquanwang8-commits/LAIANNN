package com.mhmp.common.result;

import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Map;

@Deprecated
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Result<T> extends R<T> {

    // Compatibility wrapper kept for existing controllers while reusing the shared response shape in R.
    public Result(Integer code, String message, T data) {
        super(code, message, data);
    }

    public Result(Integer code, String message, T data, Map<String, String> errors) {
        super(code, message, data, errors);
    }

    public static <T> Result<T> success() {
        return from(R.success());
    }

    public static <T> Result<T> success(T data) {
        return from(R.success(data));
    }

    public static <T> Result<T> success(String message, T data) {
        return from(R.success(message, data));
    }

    public static <T> Result<T> fail(String message) {
        return from(R.fail(message));
    }

    public static <T> Result<T> fail(Integer code, String message) {
        return from(R.fail(code, message));
    }

    public static <T> Result<T> fail(Integer code, String message, Map<String, String> errors) {
        return from(R.fail(code, message, errors));
    }

    private static <T> Result<T> from(R<T> response) {
        Result<T> result = new Result<>();
        result.setCode(response.getCode());
        result.setMessage(response.getMessage());
        result.setData(response.getData());
        result.setSuccess(response.getSuccess());
        result.setErrors(response.getErrors());
        result.setTimestamp(response.getTimestamp());
        return result;
    }
}
