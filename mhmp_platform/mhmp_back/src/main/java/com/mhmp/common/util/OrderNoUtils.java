package com.mhmp.common.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

public final class OrderNoUtils {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    private OrderNoUtils() {
    }

    public static String nextOrderNo(String prefix) {
        return prefix + "-" + LocalDateTime.now().format(DATE_TIME_FORMATTER) + "-"
            + ThreadLocalRandom.current().nextInt(100, 1000);
    }
}
