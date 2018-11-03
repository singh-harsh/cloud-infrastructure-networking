package com.neu.authentication;


import com.neu.data.AccountRepository;
import com.neu.pojo.Account;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
public class DetailsService implements UserDetailsService {

    @Autowired
    private AccountRepository accountRepository;

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
        Account account = accountRepository.findUserByEmail(s);
        if(account == null) {
            throw new UsernameNotFoundException("You are not logged in!!");
        }

        return new org.springframework.security.core.userdetails.User(account.getEmail(), account.getPassword(), AuthorityUtils.commaSeparatedStringToAuthorityList(""));
    }
}
