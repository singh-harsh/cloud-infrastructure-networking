package com.neu.controller;

import com.neu.data.AccountRepository;
import com.neu.pojo.Account;
import com.neu.service.SNSService;
import com.timgroup.statsd.StatsDClient;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;


@RestController("/")
public class AccountController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionController.class);

    @Autowired
    private StatsDClient statsDClient;

    @Autowired
    private SNSService snsService;

    @Autowired
    private AccountRepository accountRepository;

    @RequestMapping(value = "/datetime", method = RequestMethod.GET)
    public Date getDate() {
        LOGGER.info(statsDClient.toString());
        statsDClient.increment("endpoint.homepage.http.get");
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST)
    public ResponseEntity<String> registerUser(@RequestBody Account account) {
        statsDClient.increment("endpoint.register.http.post");
        if (!accountRepository.existsByEmail(account.getEmail())) {
            LOGGER.info("Account does not exist!!");
            if(!Account.VALID_EMAIL_ADDRESS_REGEX.matcher(account.getEmail()).matches()) {
                LOGGER.info("Invalid email request");
                return new ResponseEntity<>(
                        "Invalid email format", HttpStatus.PRECONDITION_FAILED);
            }
            accountRepository.save(account);
            LOGGER.info("Account successfully created!!");
            return new ResponseEntity<>("Account successfully created!!", HttpStatus.CREATED);
        }
        LOGGER.info("Account already exists!!");
        return new ResponseEntity<>("Account already exists!!", HttpStatus.BAD_REQUEST);
    }

    @RequestMapping(value = "/user/reset", method = RequestMethod.GET)
    public ResponseEntity<String> resetPassword(@RequestParam String email) {
        statsDClient.increment("endpoint.reset.http.get");
        if(accountRepository.existsByEmail(email)) {
            snsService.sendMessageToTopic(email);
            LOGGER.info("SNS Notified!!");
            return new ResponseEntity<>("SNS Notified", HttpStatus.OK);
        }
        return new ResponseEntity<>("Username does not exist!!", HttpStatus.PRECONDITION_FAILED);
    }
}
