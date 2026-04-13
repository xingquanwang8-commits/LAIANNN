package com.mhmp.serviceImpl;

import com.mhmp.common.security.JwtProperties;
import com.mhmp.common.security.JwtTokenProvider;
import com.mhmp.common.security.LoginUser;
import com.mhmp.common.security.RedisSessionService;
import com.mhmp.entity.SysMenu;
import com.mhmp.mapper.SysMenuMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.vo.MenuVO;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthServiceImplTest {

    @Mock
    private SysUserMapper sysUserMapper;
    @Mock
    private SysMenuMapper sysMenuMapper;
    @Mock
    private PasswordEncoder passwordEncoder;
    @Mock
    private JwtTokenProvider jwtTokenProvider;
    @Mock
    private JwtProperties jwtProperties;
    @Mock
    private RedisSessionService redisSessionService;

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void getCurrentMenusShouldReturnDatabaseMenusWithoutVirtualGrouping() {
        AuthServiceImpl service = new AuthServiceImpl(
            sysUserMapper,
            sysMenuMapper,
            passwordEncoder,
            jwtTokenProvider,
            jwtProperties,
            redisSessionService
        );

        LoginUser loginUser = LoginUser.builder()
            .id(1L)
            .username("admin")
            .password("encoded")
            .enabled(true)
            .authorities(List.of())
            .build();
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken(loginUser, null, List.of())
        );

        SysMenu rootMenu = new SysMenu();
        rootMenu.setId(10L);
        rootMenu.setParentId(0L);
        rootMenu.setMenuName("库存管理");
        rootMenu.setMenuType("CATA");
        rootMenu.setSortNo(2);
        rootMenu.setVisible(1);

        SysMenu childMenu = new SysMenu();
        childMenu.setId(11L);
        childMenu.setParentId(10L);
        childMenu.setMenuName("库存查询");
        childMenu.setMenuType("MENU");
        childMenu.setPath("/inventory/query");
        childMenu.setSortNo(1);
        childMenu.setVisible(1);

        SysMenu profileMenu = new SysMenu();
        profileMenu.setId(12L);
        profileMenu.setParentId(0L);
        profileMenu.setMenuName("个人中心");
        profileMenu.setMenuType("MENU");
        profileMenu.setPath("/profile");
        profileMenu.setSortNo(3);
        profileMenu.setVisible(1);

        when(sysMenuMapper.selectMenusByUserId(1L)).thenReturn(List.of(rootMenu, childMenu, profileMenu));

        List<MenuVO> menus = service.getCurrentMenus();

        assertEquals(2, menus.size());
        assertEquals("库存管理", menus.get(0).getMenuName());
        assertEquals(1, menus.get(0).getChildren().size());
        assertEquals("库存查询", menus.get(0).getChildren().get(0).getMenuName());
        assertEquals("/inventory/query", menus.get(0).getChildren().get(0).getPath());
        assertEquals("个人中心", menus.get(1).getMenuName());
        assertTrue(menus.stream().noneMatch(menu -> menu.getId() != null && menu.getId() < 0));
    }
}
