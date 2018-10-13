package com.neu.service;

import com.neu.data.MetadataRepository;
import com.neu.pojo.Metadata;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.util.Arrays;
import java.util.List;

public abstract class StorageService {

    protected static final List<String> validExtensions = Arrays.asList("png", "jpg", "jpeg");
    public abstract String storeFile(MultipartFile file, String idAttachments) throws Exception;
    public abstract void deleteFile(String file) throws Exception;

    @Autowired
    protected MetadataRepository metadataRepository;

    public boolean validateFile(String fileName) {
        String[] split = fileName.split("\\.");
        String extension = split[split.length - 1];
        if(!validExtensions.contains(extension)) {
            return false;
        }
        return true;
    }
}
