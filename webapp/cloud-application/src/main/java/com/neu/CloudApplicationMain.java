package com.neu;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class CloudApplicationMain extends SpringBootServletInitializer {

    public static final Log LOGGER = LogFactory.getLog(CloudApplicationMain.class);

    @Value("${spring.datasource.driver-class-name}")
    private static String className;
    public static void main(String[] args) {
        LOGGER.info(className);
        SpringApplication.run(CloudApplicationMain.class, args);
    }
}