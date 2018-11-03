package com.neu.controller;

import com.neu.data.AccountRepository;
import com.neu.pojo.Account;
import com.neu.service.SNSService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;


@RestController("/")
public class AccountController {

    private static final Log LOGGER = LogFactory.getLog(AccountController.class);

    @Autowired
    private SNSService snsService;

    @Autowired
    private AccountRepository accountRepository;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public Date getDate() {
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST)
    public ResponseEntity<String> registerUser(@RequestBody Account account) {

        if (!accountRepository.existsByEmail(account.getEmail())) {
            LOGGER.debug("Account does not exist!!");
            if(!Account.VALID_EMAIL_ADDRESS_REGEX.matcher(account.getEmail()).matches()) {
                return new ResponseEntity<>("Invalid email format", HttpStatus.PRECONDITION_FAILED);
            }
            accountRepository.save(account);
            return new ResponseEntity<>("Account successfully created!!", HttpStatus.CREATED);
        }
        return new ResponseEntity<>("Account already exists!!", HttpStatus.BAD_REQUEST);
    }

    @RequestMapping(value = "/user/reset", method = RequestMethod.GET)
    public ResponseEntity<String> resetPassword(@RequestParam String email) {
        if(accountRepository.existsByEmail(email)) {
            snsService.sendMessageToTopic(email);
            return new ResponseEntity<>("SNS Notified", HttpStatus.CREATED);
        }
        return new ResponseEntity<>("Username does not exist!!", HttpStatus.PRECONDITION_FAILED);
    }
}
