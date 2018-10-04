package com.neu.pojo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.json.JSONPropertyIgnore;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
public class Transaction {

    @Id
    private String id;

    @Column(nullable = false)
    @NotNull
    private String description;

    @Column(nullable = false)
    @NotNull
    private String merchant;

    @Column(nullable = false)
    @NotNull
    private String amount;

    @DateTimeFormat(pattern = "mm/dd/yyyy")
    @NotNull
    private String date;

    @Column(nullable = false)
    @NotNull
    private String category;

    @JsonIgnore
    @ManyToOne
    private Account account;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMerchant() {
        return merchant;
    }

    public void setMerchant(String merchant) {
        this.merchant = merchant;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public static boolean isEmpty(Transaction trans) {

        if (trans.getAmount().isEmpty())
            return true;
        else if (trans.getCategory().isEmpty())
            return true;
        else if (trans.getDate().isEmpty())
            return true;
        else if (trans.getDescription().isEmpty())
            return true;
        else if (trans.getMerchant().isEmpty())
            return true;
        return false;
    }
}
