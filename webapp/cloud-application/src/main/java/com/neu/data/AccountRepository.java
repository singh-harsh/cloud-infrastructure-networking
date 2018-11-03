package com.neu.data;


import com.neu.pojo.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {

    public Account findUserByEmail(String email);

    public boolean existsByEmail(String email);
}
