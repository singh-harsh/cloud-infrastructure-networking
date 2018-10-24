import com.neu.CloudApplicationMain;
import io.restassured.RestAssured;

import static io.restassured.RestAssured.given;

import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.junit4.SpringRunner;


import java.util.Date;

//@RunWith(SpringRunner.class)
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {"management.server.port=0", "management.context-path=/admin"}, classes = CloudApplicationMain.class)
//@DirtiesContext
public class UserLoginTest {

    @LocalServerPort
    private int port;



    public void testUserLoginSuccess() {
        given().port(port).auth().basic("singh.har@husky.neu.edu", "singh.har").expect().statusCode(200).when().get("/");
    }


    public void testUserRegisterSuccess() {
        RequestSpecification request = RestAssured.given();
        JSONObject requestParams = new JSONObject();
        requestParams.put("email", "singh.har@husky.neu.edu");
        // Add a header stating the Request body is a JSON
        request.header("Content-Type", "application/json");

        // Add the Json to the body of the request
        request.body(requestParams.toString());

        request.port(port);
        // Post the request and check the response
        Response response = request.post("/user/register");

        int statusCode = response.getStatusCode();
        Assert.assertEquals("Account already exists!!", response.body().asString());
        Assert.assertEquals(statusCode, 200);

    }
}
