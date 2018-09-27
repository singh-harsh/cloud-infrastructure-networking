package com.neu.controller;

import com.neu.data.UserRepository;
import com.neu.pojo.Account;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;



@RestController
public class UserController {

    private static final Log LOGGER = LogFactory.getLog(UserController.class);

    @Autowired
    private UserRepository userRepository;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    @ResponseBody
    public Date getDate() {
        LOGGER.debug("Get request received!!");
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST)
    @ResponseBody
    public String registerUser(@RequestBody Account account) {

        LOGGER.debug("Request received for account creation!!");
        System.out.println("Request received for account creation!!");
        // Add account to database
        if(!userRepository.existsByEmail(account.getEmail())) {
            LOGGER.debug("Account does not exist!!");
            LOGGER.debug(account.getPassword());
            userRepository.save(account);
            return "Account successfully created!!";
        }

        LOGGER.debug("Account already exists!! : " + account.getEmail());
        return "Account already exists!!";

    }
}
