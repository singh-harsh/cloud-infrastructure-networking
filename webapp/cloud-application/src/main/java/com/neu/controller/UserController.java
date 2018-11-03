package com.neu.controller;

import com.neu.data.UserRepository;
import com.neu.pojo.Account;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;


@RestController("/")
public class UserController {

    private static final Log LOGGER = LogFactory.getLog(UserController.class);

    @Autowired
    private UserRepository userRepository;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    @ResponseBody
    public Date getDate() {
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> registerUser(@RequestBody Account account) {

        if (!userRepository.existsByEmail(account.getEmail())) {
            LOGGER.debug("Account does not exist!!");
            if(!Account.VALID_EMAIL_ADDRESS_REGEX.matcher(account.getEmail()).matches()) {
                return new ResponseEntity<>("Invalid email format", HttpStatus.PRECONDITION_FAILED);
            }
            userRepository.save(account);
            return new ResponseEntity<>("Account successfully created!!", HttpStatus.CREATED);
        }
        return new ResponseEntity<>("Account already exists!!", HttpStatus.BAD_REQUEST);
    }
}
