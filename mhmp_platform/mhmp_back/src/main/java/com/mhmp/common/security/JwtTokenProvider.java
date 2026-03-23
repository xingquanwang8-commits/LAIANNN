package com.mhmp.common.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;

@Component
public class JwtTokenProvider {

    private final JwtProperties jwtProperties;
    private SecretKey secretKey;

    public JwtTokenProvider(JwtProperties jwtProperties) {
        this.jwtProperties = jwtProperties;
    }

    @PostConstruct
    public void init() {
        byte[] keyBytes;
        try {
            keyBytes = Decoders.BASE64.decode(jwtProperties.getSecret());
        } catch (Exception ex) {
            keyBytes = jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8);
        }
        this.secretKey = Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateToken(Long userId, String username) {
        Instant now = Instant.now();
        Instant expireAt = now.plusSeconds(jwtProperties.getExpireSeconds());
        return Jwts.builder()
            .subject(username)
            .issuer(jwtProperties.getIssuer())
            .issuedAt(Date.from(now))
            .expiration(Date.from(expireAt))
            .claim("uid", userId)
            .signWith(secretKey)
            .compact();
    }

    public boolean validateToken(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (Exception ex) {
            return false;
        }
    }

    public String getUsername(String token) {
        return parseClaims(token).getSubject();
    }

    public Long getUserId(String token) {
        Object userId = parseClaims(token).get("uid");
        if (userId == null) {
            return null;
        }
        return Long.valueOf(String.valueOf(userId));
    }

    private Claims parseClaims(String token) {
        return Jwts.parser()
            .verifyWith(secretKey)
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }
}
