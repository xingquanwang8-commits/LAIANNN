package com.mhmp.common.result;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RTest {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void successResponseShouldSerializeMessageAndLegacyMsg() throws Exception {
        R<Long> response = R.success("新增成功", 1L);

        JsonNode json = objectMapper.readTree(objectMapper.writeValueAsString(response));

        assertEquals(200, response.getCode());
        assertTrue(response.getSuccess());
        assertEquals("新增成功", json.get("message").asText());
        assertEquals("新增成功", json.get("msg").asText());
        assertEquals(1L, json.get("data").asLong());
        assertTrue(json.has("timestamp"));
    }

    @Test
    void legacyResultShouldRemainCompatibleWithUnifiedResponseShape() {
        Result<Void> response = Result.fail(400, "参数错误", Map.of("name", "名称不能为空"));

        assertEquals(400, response.getCode());
        assertEquals("参数错误", response.getMessage());
        assertEquals("参数错误", response.getMsg());
        assertFalse(response.getSuccess());
        assertEquals("名称不能为空", response.getErrors().get("name"));
        assertNotNull(response.getTimestamp());
    }
}
