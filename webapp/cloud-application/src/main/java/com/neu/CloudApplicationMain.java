package com.neu;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class CloudApplicationMain {

    private static final Log LOGGER = LogFactory.getLog(CloudApplicationMain.class);
    public static void main(String[] args) {
        SpringApplication.run(CloudApplicationMain.class, args);
    }
}