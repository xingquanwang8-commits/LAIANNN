package com.mhmp.serviceImpl;

import com.mhmp.common.security.LoginUser;
import com.mhmp.dto.TransferTaskConfirmDTO;
import com.mhmp.dto.TransferTaskCreateDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicTransferTask;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysUser;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicTransferTaskMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.vo.TransferTaskPrincipalVO;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TransferTaskServiceImplTest {

    @Mock
    private RelicMapper relicMapper;
    @Mock
    private RelicTransferTaskMapper relicTransferTaskMapper;
    @Mock
    private BusinessNoService businessNoService;
    @Mock
    private SysUserMapper sysUserMapper;
    @Mock
    private SysRoleMapper sysRoleMapper;
    @Mock
    private SysUserRoleMapper sysUserRoleMapper;

    private TransferTaskServiceImpl transferTaskService;

    @BeforeEach
    void setUp() {
        transferTaskService = new TransferTaskServiceImpl(
            relicMapper,
            relicTransferTaskMapper,
            businessNoService,
            sysUserMapper,
            sysRoleMapper,
            sysUserRoleMapper
        );
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void createTaskShouldAssignTransferToResearcher() {
        mockLogin(900L, "admin");

        SysUser assigner = buildUser(900L, "admin", "系统管理员");
        SysUser principal = buildUser(301L, "researcher02", "研究员甲");

        Relic relic = new Relic();
        relic.setId(10L);
        relic.setRelicNo("REL-2026-001");
        relic.setName("青铜簋");
        relic.setCurrentStatus("IN_STOCK");
        relic.setStorageLocationCode("LOC-A");

        when(sysUserMapper.selectRoleCodesByUserId(900L)).thenReturn(List.of("admin"));
        when(sysUserMapper.selectRoleCodesByUserId(301L)).thenReturn(List.of("researcher"));
        when(sysUserMapper.selectById(900L)).thenReturn(assigner);
        when(sysUserMapper.selectById(301L)).thenReturn(principal);
        when(relicMapper.selectById(10L)).thenReturn(relic);
        when(relicTransferTaskMapper.selectCount(any())).thenReturn(0L);
        when(businessNoService.nextTransferTaskNo()).thenReturn("TRF-20260415-001");
        doAnswer(invocation -> {
            RelicTransferTask task = invocation.getArgument(0);
            task.setId(88L);
            return 1;
        }).when(relicTransferTaskMapper).insert(any(RelicTransferTask.class));

        TransferTaskCreateDTO createDTO = new TransferTaskCreateDTO();
        createDTO.setRelicId(10L);
        createDTO.setPrincipalUserId(301L);
        createDTO.setTargetLocationCode("LOC-B");
        createDTO.setTransferReason("展柜调整");

        Long taskId = transferTaskService.createTask(createDTO);

        assertEquals(88L, taskId);
        verify(relicTransferTaskMapper).insert(any(RelicTransferTask.class));
    }

    @Test
    void confirmTaskShouldUpdateRelicLocationAndMarkTaskCompleted() {
        mockLogin(301L, "researcher02");

        RelicTransferTask task = new RelicTransferTask();
        task.setId(88L);
        task.setTaskNo("TRF-20260415-001");
        task.setRelicId(10L);
        task.setPrincipalUserId(301L);
        task.setTaskStatus("ASSIGNED");
        task.setFromLocationCode("LOC-A");
        task.setTargetLocationCode("LOC-B");
        task.setTransferReason("展柜调整");

        Relic relic = new Relic();
        relic.setId(10L);
        relic.setRelicNo("REL-2026-001");
        relic.setName("青铜簋");
        relic.setCurrentStatus("IN_STOCK");
        relic.setStorageLocationCode("LOC-A");

        when(relicTransferTaskMapper.selectById(88L)).thenReturn(task);
        when(relicMapper.selectById(10L)).thenReturn(relic);

        TransferTaskConfirmDTO confirmDTO = new TransferTaskConfirmDTO();
        confirmDTO.setConfirmRemark("已完成转存并复核库位");

        transferTaskService.confirmTask(88L, confirmDTO);

        assertEquals("LOC-B", relic.getStorageLocationCode());
        assertEquals("COMPLETED", task.getTaskStatus());
        assertEquals("已完成转存并复核库位", task.getConfirmRemark());
        assertNotNull(task.getCompleteTime());
        verify(relicMapper).updateById(relic);
        verify(relicTransferTaskMapper).updateById(task);
    }

    @Test
    void taskPrincipalsShouldBeSortedByUsername() {
        mockLogin(900L, "admin");

        SysRole researcherRole = new SysRole();
        researcherRole.setId(10L);

        SysUserRole firstRelation = new SysUserRole();
        firstRelation.setUserId(301L);
        SysUserRole secondRelation = new SysUserRole();
        secondRelation.setUserId(302L);

        SysUser firstUser = buildUser(301L, "zulu_researcher", "Alpha User");
        SysUser secondUser = buildUser(302L, "alpha_researcher", "Zulu User");

        when(sysUserMapper.selectRoleCodesByUserId(900L)).thenReturn(List.of("admin"));
        when(sysRoleMapper.findByRoleCode("researcher")).thenReturn(researcherRole);
        when(sysUserRoleMapper.selectList(any())).thenReturn(List.of(firstRelation, secondRelation));
        when(sysUserMapper.selectBatchIds(any())).thenReturn(List.of(firstUser, secondUser));

        List<TransferTaskPrincipalVO> principals = transferTaskService.taskPrincipals();

        assertEquals(2, principals.size());
        assertEquals("alpha_researcher", principals.get(0).getUsername());
        assertEquals("Zulu User", principals.get(0).getDisplayName());
        assertEquals("zulu_researcher", principals.get(1).getUsername());
        assertEquals("Alpha User", principals.get(1).getDisplayName());
    }

    private void mockLogin(Long userId, String username) {
        LoginUser loginUser = LoginUser.builder()
            .id(userId)
            .username(username)
            .password("secret")
            .enabled(true)
            .authorities(List.of())
            .build();
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken(loginUser, null, loginUser.getAuthorities())
        );
    }

    private SysUser buildUser(Long id, String username, String realName) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setUsername(username);
        user.setRealName(realName);
        user.setStatus("ENABLED");
        return user;
    }
}
