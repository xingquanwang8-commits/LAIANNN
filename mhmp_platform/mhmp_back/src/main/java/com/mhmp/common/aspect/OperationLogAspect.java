package com.mhmp.common.aspect;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.security.LoginUser;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.entity.SysOperationLog;
import com.mhmp.mapper.SysOperationLogMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

@Aspect
@Component
public class OperationLogAspect {

    private static final int MAX_TEXT_LENGTH = 2000;

    private final SysOperationLogMapper sysOperationLogMapper;
    private final ObjectMapper objectMapper;

    public OperationLogAspect(SysOperationLogMapper sysOperationLogMapper, ObjectMapper objectMapper) {
        this.sysOperationLogMapper = sysOperationLogMapper;
        this.objectMapper = objectMapper;
    }

    @Around("@annotation(operationLog)")
    public Object around(ProceedingJoinPoint joinPoint, OperationLog operationLog) throws Throwable {
        long startTime = System.currentTimeMillis();
        Object result = null;
        Throwable throwable = null;
        try {
            result = joinPoint.proceed();
            return result;
        } catch (Throwable ex) {
            throwable = ex;
            throw ex;
        } finally {
            saveLog(joinPoint, operationLog, result, throwable, System.currentTimeMillis() - startTime);
        }
    }

    private void saveLog(ProceedingJoinPoint joinPoint,
                         OperationLog operationLog,
                         Object result,
                         Throwable throwable,
                         long costTime) {
        try {
            HttpServletRequest request = getCurrentRequest();
            SysOperationLog entity = new SysOperationLog();
            LoginUser loginUser = SecurityUtils.getLoginUser();
            entity.setUserId(loginUser == null ? null : loginUser.getId());
            entity.setUsername(resolveUsername(joinPoint, loginUser));
            entity.setModuleName(operationLog.module());
            entity.setBusinessType(operationLog.businessType());
            entity.setRequestUri(request == null ? null : request.getRequestURI());
            entity.setRequestMethod(request == null ? null : request.getMethod());
            entity.setOperationDesc(operationLog.description());
            entity.setOperationIp(request == null ? null : request.getRemoteAddr());
            entity.setOperationStatus(throwable == null ? "SUCCESS" : "FAIL");
            entity.setCostTime(costTime);
            entity.setRequestParam(toJsonSafe(buildRequestParam(joinPoint)));
            entity.setResponseResult(throwable == null ? toJsonSafe(result) : truncate(throwable.getMessage()));
            entity.setOperationTime(LocalDateTime.now());
            entity.setCreateBy(loginUser == null ? null : loginUser.getId());
            entity.setUpdateBy(loginUser == null ? null : loginUser.getId());
            entity.setDeleted(0);
            sysOperationLogMapper.insert(entity);
        } catch (Exception ignored) {
            // Logging should never block business behavior.
        }
    }

    private HttpServletRequest getCurrentRequest() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attributes == null ? null : attributes.getRequest();
    }

    private Map<String, Object> buildRequestParam(ProceedingJoinPoint joinPoint) {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("args", Arrays.stream(joinPoint.getArgs())
            .filter(arg -> arg != null)
            .filter(arg -> !(arg instanceof HttpServletRequest))
            .toList());
        return payload;
    }

    private String resolveUsername(ProceedingJoinPoint joinPoint, LoginUser loginUser) {
        if (loginUser != null && StringUtils.hasText(loginUser.getUsername())) {
            return loginUser.getUsername();
        }
        return Arrays.stream(joinPoint.getArgs())
            .filter(arg -> arg != null)
            .map(this::extractUsernameFromArg)
            .filter(StringUtils::hasText)
            .findFirst()
            .orElse(null);
    }

    private String extractUsernameFromArg(Object arg) {
        try {
            Object username = arg.getClass().getMethod("getUsername").invoke(arg);
            return username == null ? null : String.valueOf(username);
        } catch (Exception ignored) {
            return null;
        }
    }

    private String toJsonSafe(Object value) {
        if (value == null) {
            return null;
        }
        try {
            return truncate(objectMapper.writeValueAsString(value));
        } catch (JsonProcessingException ignored) {
            return truncate(String.valueOf(value));
        }
    }

    private String truncate(String value) {
        if (!StringUtils.hasText(value) || value.length() <= MAX_TEXT_LENGTH) {
            return value;
        }
        return value.substring(0, MAX_TEXT_LENGTH);
    }
}
