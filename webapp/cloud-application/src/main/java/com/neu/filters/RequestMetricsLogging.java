package com.neu.filters;

import com.timgroup.statsd.NonBlockingStatsDClient;
import com.timgroup.statsd.StatsDClient;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import java.io.IOException;

@Component
@Order(1)
public class RequestMetricsLogging implements Filter {

    private static final StatsDClient statsd = new NonBlockingStatsDClient("cloud-application-metrics", "statsd-host", 8125);


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        statsd.increment("number_of_visitors");
    }

    @Override
    public void destroy() {
        statsd.stop();
    }
}
