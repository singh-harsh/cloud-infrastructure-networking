package com.neu.service;

import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.neu.exception.InvalidFileException;
import com.neu.pojo.Metadata;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@Component
@Profile("aws")
public class S3Service extends StorageService {

    private static final Log LOGGER = LogFactory.getLog(S3Service.class);
    @Autowired
    private ResourceLoader resourceLoader;

    @Value("${aws.bucketName}")
    private String bucketName;

    @Value("${aws.endpointUrl}")
    private String endpointUrl;

    private AmazonS3 amazonS3;

    public S3Service() {

    }

    @Override
    public String storeFile(MultipartFile file, String idAttachments) throws Exception {
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
        String[] split = fileName.split("\\.");
        try {
            if (!validateFile(fileName))
                throw new InvalidFileException("File extension not valid");
            String extension = split[split.length - 1];
            File newFile = new File(idAttachments + "." + extension);
            FileOutputStream fos = new FileOutputStream(newFile);
            fos.write(file.getBytes());
            fos.close();
            PutObjectRequest objectRequest = new PutObjectRequest(this.bucketName, idAttachments + "." + extension, newFile);
            this.amazonS3.putObject(objectRequest);
            newFile.delete();

            Metadata metadata = new Metadata();
            metadata.setId(idAttachments);
            metadata.setExtension(extension);
            metadata.setSize(file.getSize());
            metadataRepository.save(metadata);
            return endpointUrl + "/" + bucketName + "/" + idAttachments + "." + extension;
        } catch (IOException ex) {
            throw new Exception("Could not store file " + fileName + ". Please try again!", ex);
        }
    }

    @PostConstruct
    public void setupClient() {
        this.amazonS3 = AmazonS3ClientBuilder.standard().withRegion(Regions.US_EAST_1)
                .build();
    }

    @Override
    public void deleteFile(String file) throws Exception {
        String[] fileUrl = file.split("/");
        String fileName = fileUrl[fileUrl.length - 1];
        this.amazonS3.deleteObject(new DeleteObjectRequest(bucketName, fileName));
        Metadata metadataById = metadataRepository.getMetadataById(fileName.split("\\.")[0]);
        metadataRepository.delete(metadataById);
    }
}
