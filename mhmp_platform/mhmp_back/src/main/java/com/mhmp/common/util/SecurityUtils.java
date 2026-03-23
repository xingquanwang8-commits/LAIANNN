package com.mhmp.common.util;

import com.mhmp.common.security.LoginUser;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public final class SecurityUtils {

    private SecurityUtils() {
    }

    public static LoginUser getLoginUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return null;
        }
        Object principal = authentication.getPrincipal();
        if (principal instanceof LoginUser loginUser) {
            return loginUser;
        }
        return null;
    }

    public static Long getUserId() {
        LoginUser loginUser = getLoginUser();
        return loginUser == null ? null : loginUser.getId();
    }

    public static String getUsername() {
        LoginUser loginUser = getLoginUser();
        return loginUser == null ? null : loginUser.getUsername();
    }
}
