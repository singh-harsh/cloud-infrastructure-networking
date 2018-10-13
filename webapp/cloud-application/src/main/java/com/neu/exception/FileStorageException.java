package com.neu.exception;

public class FileStorageException  extends Exception{

    public FileStorageException(String message, Throwable cause) {
        super(message, cause);
    }

    public FileStorageException(String message) {
        super(message);
    }
}
