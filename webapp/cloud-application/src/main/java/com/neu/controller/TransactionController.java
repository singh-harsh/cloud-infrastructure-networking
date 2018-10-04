package com.neu.controller;

import com.neu.data.TransactionRepository;
import com.neu.data.UserRepository;
import com.neu.pojo.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.UUID;


@RestController
public class TransactionController {

    @Autowired
    TransactionRepository transactionRepository;
    @Autowired
    UserRepository userRepository;

    @RequestMapping(value = "/transaction/create", method = RequestMethod.POST)
    public ResponseEntity<?> createTransaction(@RequestBody @Valid Transaction transaction, Authentication authentication) {
        if (!Transaction.isEmpty(transaction)) {
            String username = authentication.getName();
            transaction.setId(UUID.randomUUID().toString());
            transaction.setAccount(userRepository.findUserByEmail(username));
            Transaction savedTransaction = transactionRepository.save(transaction);
            return new ResponseEntity<>(savedTransaction, HttpStatus.CREATED);
        }
        return new ResponseEntity<String>("Invalid inputs", HttpStatus.BAD_REQUEST);
    }

    @GetMapping(value = "/transaction/view")
    public ResponseEntity<List<Transaction>> viewTransaction(Authentication authentication) {
	List<Transaction> transactionByAccount_email = transactionRepository.findTransactionByAccount_Email(authentication.getName());
        return new ResponseEntity<>(transactionByAccount_email, HttpStatus.OK);
    }

    @PutMapping(value = "/transaction/update/{id}")
    public ResponseEntity<?> updateTransaction(@PathVariable String id, Authentication authentication, @RequestBody @Valid Transaction transaction) {
        if (!Transaction.isEmpty(transaction)) {
            Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
            trans.setAmount(transaction.getAmount());
            trans.setMerchant(transaction.getMerchant());
            trans.setCategory(transaction.getCategory());
            trans.setDate(transaction.getDate());
            trans.setDescription(transaction.getDescription());
            transactionRepository.save(trans);
            return new ResponseEntity<Transaction>(trans, HttpStatus.CREATED);
        }
        return new ResponseEntity<String>("Invalid Inputs", HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping(value = "/transaction/delete/{id}")
    public ResponseEntity<String> deleteTransaction(@PathVariable String id, Authentication authentication) {
        Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
        if (trans == null)
            return new ResponseEntity<String>("No transaction found", HttpStatus.BAD_REQUEST);
        transactionRepository.delete(trans);
        return new ResponseEntity<String>("Transaction successfully deleted", HttpStatus.NO_CONTENT);
    }
}
