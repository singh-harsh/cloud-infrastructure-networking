package com.neu.service;

import com.neu.exception.InvalidFileException;
import com.neu.pojo.Metadata;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;


@Component
@Profile("!aws")
public class FileService extends StorageService {

    @Value("${dev.fileStoragePath}")
    private String FILE_STORAGE_PATH;

    public FileService() {

    }

    public String storeFile(MultipartFile file, String idAttachment) throws Exception {

        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
        String[] split = fileName.split("\\.");
        String extension = split[split.length - 1];
        try {
            // Copy file to the target location (Replacing existing file with the same name)
            if (!validateFile(fileName)) {
                throw new InvalidFileException("File extension not valid");
            }
            byte[] bytes = file.getBytes();
            Path path = Paths.get(FILE_STORAGE_PATH + idAttachment + "." + extension);
            Files.write(path, bytes);
            Files.write(path, bytes, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);

            Metadata metadata = new Metadata();
            metadata.setId(idAttachment);
            metadata.setExtension(extension);
            metadata.setSize(file.getSize());
            metadataRepository.save(metadata);
            return FILE_STORAGE_PATH + idAttachment + "." + extension;
        } catch (IOException ex) {
            throw new Exception("Could not store file " + fileName + ". Please try again!", ex);
        }

    }

    public void deleteFile(String file) throws Exception {
        Files.deleteIfExists(Paths.get(file));
        String[] split = file.split("/");
        metadataRepository.deleteMetadataById(split[split.length - 1].split("\\.")[0]);
    }
}
