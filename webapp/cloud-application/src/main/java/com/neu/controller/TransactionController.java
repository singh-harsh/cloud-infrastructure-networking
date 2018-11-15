package com.neu.controller;

import com.neu.data.AttachmentRepository;
import com.neu.data.TransactionRepository;
import com.neu.data.AccountRepository;
import com.neu.pojo.Attachment;
import com.neu.pojo.Transaction;
import com.neu.service.StorageService;
import com.timgroup.statsd.StatsDClient;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;


@RestController
public class TransactionController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionController.class);

    @Autowired
    private StatsDClient statsDClient;

    @Autowired
    private StorageService storageService;
    @Autowired
    private TransactionRepository transactionRepository;
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private AttachmentRepository attachmentRepository;

    @PostMapping(value = "/transaction/create")
    public ResponseEntity<?> createTransaction(@RequestBody @Valid Transaction transaction, Authentication authentication) {
        statsDClient.incrementCounter("endpoint.createtransaction.http.post");
        if (!Transaction.isEmpty(transaction)) {
            String username = authentication.getName();
            transaction.setId(UUID.randomUUID().toString());
            transaction.setAccount(accountRepository.findUserByEmail(username));
            Transaction savedTransaction = transactionRepository.save(transaction);
            return new ResponseEntity<>(savedTransaction, HttpStatus.CREATED);
        }
        return new ResponseEntity<>("Invalid inputs", HttpStatus.BAD_REQUEST);
    }

    @GetMapping(value = "/transaction/view")
    public ResponseEntity<List<Transaction>> viewTransaction(Authentication authentication) {
        statsDClient.incrementCounter("endpoint.viewtransation.http.get");
        List<Transaction> transactionByAccount_email = transactionRepository.findTransactionByAccount_Email(authentication.getName());
        return new ResponseEntity<>(transactionByAccount_email, HttpStatus.OK);
    }

    @PutMapping(value = "/transaction/update/{id}")
    public ResponseEntity<?> updateTransaction(@PathVariable String id, Authentication authentication, @RequestBody @Valid Transaction transaction) {
        statsDClient.incrementCounter("endpoint.updatetransaction.http.put");
        statsDClient.increment("endpoint.updatetransaction.http.put");
        if (!Transaction.isEmpty(transaction)) {
            Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
            trans.setAmount(transaction.getAmount());
            trans.setMerchant(transaction.getMerchant());
            trans.setCategory(transaction.getCategory());
            trans.setDate(transaction.getDate());
            trans.setDescription(transaction.getDescription());
            transactionRepository.save(trans);
            return new ResponseEntity<>(trans, HttpStatus.CREATED);
        }
        return new ResponseEntity<>("Invalid Inputs", HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping(value = "/transaction/delete/{id}")
    public ResponseEntity<String> deleteTransaction(@PathVariable String id, Authentication authentication) {
        statsDClient.increment("endpoint.deletetransation.http.delete");
        Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
        if (trans == null)
            return new ResponseEntity<>("No transaction found", HttpStatus.BAD_REQUEST);
        for (Attachment attachment : trans.getAttachments()) {
            try {
                storageService.deleteFile(attachment.getUrl());
                attachmentRepository.delete(attachment);
            } catch (Exception e) {
                return new ResponseEntity<>(e.getMessage(), HttpStatus.EXPECTATION_FAILED);
            }
        }
        transactionRepository.delete(trans);
        return new ResponseEntity<>("Transaction successfully deleted", HttpStatus.NO_CONTENT);
    }

    @GetMapping(value = "/transaction/{id}/attachments")
    public ResponseEntity<?> getAttachments(@PathVariable String id, Authentication authentication) {
        statsDClient.increment("endpoint.getattachment.http.get");
        Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
        if (trans == null)
            return new ResponseEntity<>("No transaction found with id : " + id, HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(trans.getAttachments(), HttpStatus.OK);
    }

    @PostMapping(value = "transaction/{id}/attachments")
    public ResponseEntity<?> createAttachment(@PathVariable String id, Authentication authentication, @RequestParam("attachment") MultipartFile file) {
        statsDClient.increment("endpoint.createAttachment.http.post");
        Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
        if (trans == null) {
            return new ResponseEntity<>("No transaction found with id : " + id, HttpStatus.BAD_REQUEST);
        }
        List<Attachment> attachments = trans.getAttachments();
        String idAttachment = UUID.randomUUID().toString();
        String fileName = "";
        try {
            fileName = storageService.storeFile(file, idAttachment);
        } catch (Exception e) {
            LOGGER.error("File wasnt saved");
            e.printStackTrace();
            return new ResponseEntity<>(e.getMessage(), HttpStatus.PRECONDITION_FAILED);
        }
        Attachment attachment = new Attachment();
        attachment.setId(idAttachment);
        attachment.setUrl(fileName);
        if (attachments == null) {
            attachments = new ArrayList<>();
            trans.setAttachments(attachments);
        }
        attachments.add(attachment);
        attachmentRepository.save(attachment);
        transactionRepository.save(trans);
        return new ResponseEntity<>(attachment, HttpStatus.CREATED);
    }

    @PutMapping(value = "/transaction/{id}/attachments/{idAttachments}")
    public ResponseEntity<?> updateAttachments(@PathVariable String id, @PathVariable String idAttachments, Authentication authentication, @RequestParam("attachment") MultipartFile file) {
        statsDClient.increment("endpoint.updateattachment.http.put");
        Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
        if (trans == null) {
            return new ResponseEntity<>("No transaction found with id : " + id, HttpStatus.BAD_REQUEST);
        }
        Attachment updateAttachment = null;
        for (Attachment attachment : trans.getAttachments()) {
            if (attachment.getId().equals(idAttachments)) {
                updateAttachment = attachment;
                break;
            }
        }
        if (updateAttachment == null)
            return new ResponseEntity<>("Attachment not found with id : " + idAttachments, HttpStatus.BAD_REQUEST);
        try {
            storageService.storeFile(file, idAttachments);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.EXPECTATION_FAILED);
        }
        return new ResponseEntity<>(null, HttpStatus.CREATED);
    }

    @DeleteMapping(value = "/transaction/{id}/attachments/{idAttachments}")
    public ResponseEntity<String> deleteAttachments(@PathVariable String id, @PathVariable String idAttachments, Authentication authentication) {
        statsDClient.increment("endpoint.deleteAttachement.http.delete");
        Transaction trans = transactionRepository.findTransactionByIdAndAccount_Email(id, authentication.getName());
        if (trans == null)
            return new ResponseEntity<>("No transaction found with id : " + id, HttpStatus.BAD_REQUEST);
        List<Attachment> attachments = trans.getAttachments();
        Attachment deleteAttachment = null;
        if (attachments != null) {
            for (Attachment attachment : attachments) {
                if (attachment.getId().equals(idAttachments))
                    deleteAttachment = attachment;
            }
        }
        if (deleteAttachment == null)
            return new ResponseEntity<>("Attachment not found with id : " + idAttachments, HttpStatus.BAD_REQUEST);
        attachments.remove(deleteAttachment);
        attachmentRepository.delete(deleteAttachment);
        transactionRepository.save(trans);
        try {
            storageService.deleteFile(deleteAttachment.getUrl());
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.EXPECTATION_FAILED);
        }
        return new ResponseEntity<>("Deleted", HttpStatus.NO_CONTENT);
    }
}