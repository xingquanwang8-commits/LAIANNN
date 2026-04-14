package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.Relic;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.SysDictItemMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class BusinessNoServiceImplTest {

    private static final DateTimeFormatter DATE_SEGMENT_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Mock
    private RelicMapper relicMapper;
    @Mock
    private RelicInboundOrderMapper relicInboundOrderMapper;
    @Mock
    private RelicOutboundOrderMapper relicOutboundOrderMapper;
    @Mock
    private InventoryTaskMapper inventoryTaskMapper;
    @Mock
    private RepairTaskMapper repairTaskMapper;
    @Mock
    private RepairLogMapper repairLogMapper;
    @Mock
    private RepairAcceptanceMapper repairAcceptanceMapper;
    @Mock
    private SysDictItemMapper sysDictItemMapper;

    private BusinessNoServiceImpl businessNoService;

    @BeforeEach
    void setUp() {
        initTableInfo(Relic.class);
        initTableInfo(InventoryTask.class);
        businessNoService = new BusinessNoServiceImpl(
            relicMapper,
            relicInboundOrderMapper,
            relicOutboundOrderMapper,
            inventoryTaskMapper,
            repairTaskMapper,
            repairLogMapper,
            repairAcceptanceMapper,
            sysDictItemMapper
        );
    }

    @Test
    void nextRelicNoShouldResetSequenceEveryDay() {
        LocalDate today = LocalDate.now();
        String todaySegment = today.format(DATE_SEGMENT_FORMATTER);
        String yesterdaySegment = today.minusDays(1).format(DATE_SEGMENT_FORMATTER);

        when(relicMapper.selectList(any())).thenReturn(List.of(
            buildRelic(String.format("REL-%s-001", todaySegment)),
            buildRelic(String.format("REL-%s-002", todaySegment)),
            buildRelic(String.format("REL-%s-099", yesterdaySegment)),
            buildRelic(String.format("REL-%d-225", today.getYear()))
        ));

        assertEquals(String.format("REL-%s-003", todaySegment), businessNoService.nextRelicNo());
    }

    @Test
    void nextInventoryTaskNoShouldResetSequenceEveryDay() {
        LocalDate today = LocalDate.now();
        String todaySegment = today.format(DATE_SEGMENT_FORMATTER);
        String yesterdaySegment = today.minusDays(1).format(DATE_SEGMENT_FORMATTER);

        when(inventoryTaskMapper.selectList(any())).thenReturn(List.of(
            buildInventoryTask(String.format("INV-%s-001", todaySegment)),
            buildInventoryTask(String.format("INV-%s-002", todaySegment)),
            buildInventoryTask(String.format("INV-%s-016", yesterdaySegment)),
            buildInventoryTask(String.format("INV-%d-015", today.getYear()))
        ));

        assertEquals(String.format("INV-%s-003", todaySegment), businessNoService.nextInventoryTaskNo());
    }

    private Relic buildRelic(String relicNo) {
        Relic relic = new Relic();
        relic.setRelicNo(relicNo);
        return relic;
    }

    private InventoryTask buildInventoryTask(String taskNo) {
        InventoryTask task = new InventoryTask();
        task.setTaskNo(taskNo);
        return task;
    }

    private void initTableInfo(Class<?> entityClass) {
        if (TableInfoHelper.getTableInfo(entityClass) != null) {
            return;
        }
        TableInfoHelper.initTableInfo(new MapperBuilderAssistant(new MybatisConfiguration(), ""), entityClass);
    }
}
