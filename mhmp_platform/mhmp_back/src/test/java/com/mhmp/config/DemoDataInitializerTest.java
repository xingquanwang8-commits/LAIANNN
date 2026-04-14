package com.mhmp.config;

import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.SysUserMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DemoDataInitializerTest {

    @Mock
    private SysUserMapper sysUserMapper;
    @Mock
    private RelicMapper relicMapper;
    @Mock
    private RelicAttachmentMapper relicAttachmentMapper;
    @Mock
    private RelicInboundOrderMapper relicInboundOrderMapper;
    @Mock
    private RelicInboundDetailMapper relicInboundDetailMapper;
    @Mock
    private RelicOutboundOrderMapper relicOutboundOrderMapper;
    @Mock
    private RelicOutboundDetailMapper relicOutboundDetailMapper;
    @Mock
    private InventoryTaskMapper inventoryTaskMapper;
    @Mock
    private InventoryTaskDetailMapper inventoryTaskDetailMapper;
    @Mock
    private RepairTaskMapper repairTaskMapper;
    @Mock
    private RepairPlanMapper repairPlanMapper;
    @Mock
    private RepairLogMapper repairLogMapper;
    @Mock
    private RepairAcceptanceMapper repairAcceptanceMapper;

    private DemoDataInitializer initializer;

    @BeforeEach
    void setUp() {
        FileStorageProperties fileStorageProperties = new FileStorageProperties();
        fileStorageProperties.setBasePath("target/test-uploads");
        initializer = new DemoDataInitializer(
            sysUserMapper,
            relicMapper,
            relicAttachmentMapper,
            relicInboundOrderMapper,
            relicInboundDetailMapper,
            relicOutboundOrderMapper,
            relicOutboundDetailMapper,
            inventoryTaskMapper,
            inventoryTaskDetailMapper,
            repairTaskMapper,
            repairPlanMapper,
            repairLogMapper,
            repairAcceptanceMapper,
            fileStorageProperties
        );
    }

    @Test
    void upsertRelicShouldPreserveExistingBusinessStatus() {
        Relic relic = new Relic();
        relic.setId(1L);
        relic.setRelicNo("REL-20260408-015");
        relic.setName("清代嵌螺钿木匣");
        relic.setCategoryCode("WOOD");
        relic.setMaterialCode("BAMBOO_WOOD");
        relic.setEra("清代");
        relic.setSource("新征集待交接");
        relic.setStorageLocationCode("LOC_A");
        relic.setPreservationStatusCode("BASIC_COMPLETE");
        relic.setCurrentStatus("INBOUND_PENDING");
        relic.setProtectionLevel("一级");
        relic.setStorageCondition("Constant temperature and humidity, quarterly inspection.");
        relic.setAttentionNote("Demo record for inbound, outbound, repair and inventory linkage.");
        relic.setDescription("清代嵌螺钿木匣 demo record for museum business process simulation.");
        relic.setNote("已有业务备注");
        relic.setImageUrl("/uploads/demo/images/relic-placeholder.png");
        relic.setAppraisalReportUrl("/uploads/demo/reports/appraisal-note.txt");

        when(relicMapper.selectOne(any())).thenReturn(relic);

        Relic result = ReflectionTestUtils.invokeMethod(
            initializer,
            "upsertRelic",
            "REL-2026-015",
            "清代嵌螺钿木匣",
            "WOOD",
            "BAMBOO_WOOD",
            "清代",
            "新征集待交接",
            null,
            "BASIC_COMPLETE",
            "TO_BE_INBOUND",
            "一级",
            "/uploads/demo/images/relic-placeholder.png",
            "/uploads/demo/reports/appraisal-note.txt",
            "用于模拟新增建档后待入库、可发起入库的文物。",
            1L,
            LocalDateTime.of(2026, 4, 3, 10, 0)
        );

        assertSame(relic, result);
        assertEquals("INBOUND_PENDING", relic.getCurrentStatus());
        assertEquals("LOC_A", relic.getStorageLocationCode());
        verify(relicMapper, never()).updateById(any(Relic.class));
    }

    @Test
    void upsertInboundOrderShouldPreserveExistingApprovalStatus() {
        RelicInboundOrder order = new RelicInboundOrder();
        order.setId(1L);
        order.setOrderNo("IN-20260408-003");
        order.setBatchNo("BATCH-20260408-003");
        order.setSource("馆际征集移交");
        order.setHandlerName("周敏");
        order.setInboundTime(LocalDateTime.of(2026, 4, 8, 10, 0));
        order.setTotalCount(1);
        order.setStatus("APPROVED");
        order.setRemark("已有审批结果");

        when(relicInboundOrderMapper.selectOne(any())).thenReturn(order);

        ReflectionTestUtils.invokeMethod(
            initializer,
            "upsertInboundOrder",
            "IN-2026-003",
            "BATCH-2026-003",
            "馆际征集移交",
            "周敏",
            LocalDateTime.of(2026, 4, 8, 10, 0),
            1,
            "PENDING",
            "待审批演示入库单",
            1L
        );

        assertEquals("APPROVED", order.getStatus());
        verify(relicInboundOrderMapper, never()).updateById(any(RelicInboundOrder.class));
    }
}
