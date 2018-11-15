package com.neu.metrics;

import com.timgroup.statsd.NoOpStatsDClient;
import com.timgroup.statsd.NonBlockingStatsDClient;
import com.timgroup.statsd.StatsDClient;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RequestMetricsLogging {

    @Value("${publish.metrics}")
    private boolean publishMetrics;

    @Value("${metrics.server.hostname}")
    private String metricsServerHost;

    @Value("${metrics.server.port}")
    private int metricsServerPort;

    private static final Log LOGGER = LogFactory.getLog(RequestMetricsLogging.class);

    @Bean
    public StatsDClient metricsClient() {
        LOGGER.info(publishMetrics);
        LOGGER.info(metricsServerHost);
        LOGGER.info(metricsServerPort);
        if (publishMetrics) {
            return new NonBlockingStatsDClient("csye6225", metricsServerHost, metricsServerPort);

        }
        return new NoOpStatsDClient();
    }
}
