package com.mhmp.common.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Slf4j
@Component
public class RedisSessionService {

    private final StringRedisTemplate stringRedisTemplate;
    private final JwtProperties jwtProperties;

    public RedisSessionService(StringRedisTemplate stringRedisTemplate, JwtProperties jwtProperties) {
        this.stringRedisTemplate = stringRedisTemplate;
        this.jwtProperties = jwtProperties;
    }

    public void saveToken(String token, Long userId) {
        try {
            stringRedisTemplate.opsForValue().set(buildKey(token), String.valueOf(userId), Duration.ofSeconds(jwtProperties.getExpireSeconds()));
        } catch (Exception ex) {
            log.warn("Redis 不可用，跳过 token 缓存：{}", ex.getMessage());
        }
    }

    public void deleteToken(String token) {
        try {
            stringRedisTemplate.delete(buildKey(token));
        } catch (Exception ex) {
            log.warn("Redis 不可用，跳过 token 删除：{}", ex.getMessage());
        }
    }

    public boolean isTokenActive(String token) {
        try {
            Boolean exists = stringRedisTemplate.hasKey(buildKey(token));
            return Boolean.TRUE.equals(exists);
        } catch (Exception ex) {
            log.warn("Redis 不可用，按 JWT 模式继续鉴权：{}", ex.getMessage());
            return true;
        }
    }

    private String buildKey(String token) {
        return jwtProperties.getRedisPrefix() + token;
    }
}
