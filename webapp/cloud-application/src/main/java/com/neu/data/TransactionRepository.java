package com.neu.data;

import com.neu.pojo.Attachment;
import com.neu.pojo.Transaction;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface TransactionRepository extends CrudRepository<Transaction, Long> {

    public List<Transaction> findTransactionByAccount_Email(String email);
    public Transaction findTransactionByIdAndAccount_Email(String id, String email);

}
