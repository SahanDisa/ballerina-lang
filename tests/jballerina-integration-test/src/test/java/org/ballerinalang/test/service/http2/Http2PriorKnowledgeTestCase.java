/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.test.service.http2;

import org.ballerinalang.test.util.HttpClientRequest;
import org.ballerinalang.test.util.HttpResponse;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;

/**
 * Test case for HTTP/2 prior knowledge.
 */
@Test(groups = "http2-test")
public class Http2PriorKnowledgeTestCase extends Http2BaseTest {

    @Test
    public void testPriorKnowledgeOn() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9097, "priorKnowledge/on"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        String responseData = response.getData();
        Assert.assertEquals(responseData, "Connection and upgrade headers are not present--Prior knowledge is enabled",
                            "HTTP/2 prior knowledge enabled scenario failed");
    }

    @Test
    public void testPriorKnowledgeOff() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9097, "priorKnowledge/off"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        String responseData = response.getData();
        Assert.assertEquals(responseData, "HTTP2-Settings,upgrade--h2c--Prior knowledge is disabled",
                            "HTTP/2 prior knowledge disabled scenario failed");
    }
}
