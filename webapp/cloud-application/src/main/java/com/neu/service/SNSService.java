package com.neu.service;

import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.route53.AmazonRoute53;
import com.amazonaws.services.route53.AmazonRoute53ClientBuilder;
import com.amazonaws.services.route53.model.HostedZone;
import com.amazonaws.services.route53.model.ListHostedZonesRequest;
import com.amazonaws.services.route53.model.ListHostedZonesResult;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.ListTopicsResult;
import com.amazonaws.services.sns.model.MessageAttributeValue;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.Topic;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.HashMap;

@Component
public class SNSService {

    private AmazonSNS amazonSNS;
    private AmazonRoute53 amazonRoute53;
    private String domainName;
    private Topic emailTopic;
    private static final Log LOGGER = LogFactory.getLog(SNSService.class);

    @Value("${topicName}")
    private String topicName;

    public void sendMessageToTopic(String email) {
        PublishRequest publishRequest = new PublishRequest(emailTopic.getTopicArn(), "Sending reset mail");
        HashMap<String, MessageAttributeValue> msgAttr = new HashMap<>();
        MessageAttributeValue emailValue = new MessageAttributeValue();
        emailValue.setStringValue(email);
        MessageAttributeValue domain = new MessageAttributeValue();
        domain.setStringValue(domainName);
        msgAttr.put("email", emailValue);
        msgAttr.put("domainName", domain);
        publishRequest.setMessageAttributes(msgAttr);
        amazonSNS.publish(publishRequest);
    }

    @PostConstruct
    public void setupClient() {
        InstanceProfileCredentialsProvider provider = new InstanceProfileCredentialsProvider(true);
        this.amazonSNS = AmazonSNSClientBuilder.standard().withCredentials(provider).withRegion(Regions.US_EAST_1)
                .build();
        this.amazonRoute53 = AmazonRoute53ClientBuilder.standard().withCredentials(provider).withRegion(Regions.US_EAST_1).build();
        ListHostedZonesResult hostedZone = amazonRoute53.listHostedZones();
        if (hostedZone.getHostedZones() != null && !hostedZone.getHostedZones().isEmpty())
            domainName = hostedZone.getHostedZones().get(0).getName();
        else
            LOGGER.error("No Domain name found");
        ListTopicsResult topics = amazonSNS.listTopics();
        for (Topic topic : topics.getTopics()) {
            LOGGER.info(topic.toString() + " : " + topic.getTopicArn());
            if (topic.toString().contains(topicName)) {
                emailTopic = topic;
                return;
            }
        }
        LOGGER.error("The requested topic " + topicName + " was not found");
    }
}
