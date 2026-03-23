package com.mhmp.common.security;

import com.mhmp.service.AuthService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final RedisSessionService redisSessionService;
    private final AuthService authService;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider,
                                   RedisSessionService redisSessionService,
                                   AuthService authService) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.redisSessionService = redisSessionService;
        this.authService = authService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String token = resolveToken(request);
        if (StringUtils.hasText(token)
            && jwtTokenProvider.validateToken(token)
            && redisSessionService.isTokenActive(token)
            && SecurityContextHolder.getContext().getAuthentication() == null) {
            try {
                String username = jwtTokenProvider.getUsername(token);
                LoginUser loginUser = authService.loadLoginUserByUsername(username);
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    loginUser,
                    null,
                    loginUser.getAuthorities()
                );
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } catch (Exception ex) {
                SecurityContextHolder.clearContext();
            }
        }
        filterChain.doFilter(request, response);
    }

    public static String resolveToken(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (!StringUtils.hasText(authHeader) || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        return authHeader.substring(7);
    }
}
