package com.neu.service;

import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.ListTopicsResult;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.Topic;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class SNSService {

    private AmazonSNS amazonSNS;
    private Topic emailTopic;
    private static final Log LOGGER = LogFactory.getLog(SNSService.class);

    @Value("${topicName}")
    private String topicName;

    public void sendMessageToTopic(String email) {
        PublishRequest publishRequest = new PublishRequest(emailTopic.getTopicArn(), email);
        amazonSNS.publish(publishRequest);
    }

    @PostConstruct
    public void setupClient() {
        InstanceProfileCredentialsProvider provider = new InstanceProfileCredentialsProvider(true);
        this.amazonSNS = AmazonSNSClientBuilder.standard().withCredentials(provider).withRegion(Regions.US_EAST_1)
                .build();
        ListTopicsResult topics = amazonSNS.listTopics();
        for(Topic topic : topics.getTopics()) {
            LOGGER.info(topic.toString() + " : " + topic.getTopicArn());
            if(topic.toString().contains(topicName)) {
                emailTopic = topic;
                return;
            }
        }
        LOGGER.error("The requested topic " + topicName + " was not found");
    }
}
