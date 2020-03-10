// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/config;
import ballerina/io;
import ballerina/test;

InsightsConfiguration insightsConfig = {
    tenantId: config:getAsString("TENANT_ID"),
    clientId: config:getAsString("CLIENT_ID"),
    clientSecrect: config:getAsString("CLIENT_SECRET")
};

EnvironmentConfiguration config = {
    environmentFqdn: config:getAsString("ENV_FQDN"),
    tenantId: config:getAsString("TENANT_ID"),
    clientId: config:getAsString("CLIENT_ID"),
    clientSecrect: config:getAsString("CLIENT_SECRET")
};

InsightsClient insightsClient = new InsightsClient(insightsConfig);
EnvironmentClient environmentClient = new EnvironmentClient(config);


@test:Config {}
function testAzureInsightsEnvironemtns() {
    io:println("-----------------Test case for get Environment availability------------------");
    var response = insightsClient->getEnvironments();

    io:println(response);
    if (response is Environment[]) {
        test:assertTrue(true, "Availability Response received");
    } else {
        test:assertFail("Availability API call fails");
    }
}

@test:Config {
    dependsOn: ["testAzureInsightsEnvironemtns"]
}
function testAzureInsightsAPIAvailability() {
    io:println("-----------------Test case for get Environment availability------------------");
    var response = environmentClient->getAvailability();

    io:println(response);
    if (response is AvailabiltyResponse) {
        test:assertTrue(true, "Availability Response received");
    } else {
        test:assertFail("Availability API call fails");
    }
}

@test:Config {
    dependsOn: ["testAzureInsightsAPIAvailability"]
}
function testAzureInsightsGetMetaData() {
    io:println("-----------------Test case for get Environment MetaData------------------");

    SearchSpan request = {
        'from: {
            dateTime: "2019-12-30T00:00:00.000Z"
        },
        to: {
            dateTime: "2021-12-30T00:00:00.000Z"
        }
    };

    var response = environmentClient->getMetaData(request);

    io:println(response);
    if (response is PropertyMetaData[]) {
        test:assertTrue(true, "Availability Response received");
    } else {
        test:assertFail("Availability API call fails");
    }
}


@test:Config {
    dependsOn: ["testAzureInsightsGetMetaData"]
}
function testAzureInsightsGetEvents() {
    io:println("-----------------Test case for get Environment Events API------------------");

    BuiltInProperty timestamp = {
        builtInProperty: "$ts"
    };

    Property latitudeProperty = {
        property: "latitude",
        'type: "Double"
    };

    CompareExpression compareExp = {
        'left: latitudeProperty,
        'right: 3.14
    };

    EqualExpression equalLattitue = {
        eq: compareExp
    };

    EventsRequest eventsRequest = {
        searchSpan: {
            'from: {
                dateTime: "2019-12-30T00:00:00.000Z"
            },
            to: {
                dateTime: "2021-12-30T00:00:00.000Z"
            }
        },
        predicate: equalLattitue,
        top: {
            sort: [
                {
                    input: timestamp,
                    'order: ORDER_DESCENDING
                }
            ],
            count: 5
        }
    };

    var response = environmentClient->getEvents(eventsRequest);

    io:println(response);
    if (response is EventsResponse) {
        test:assertTrue(true, "Events received");
    } else {
        test:assertFail("Event API call fails");
    }
}


@test:Config {
    dependsOn: ["testAzureInsightsGetEvents"]
}
function testAzureInsightsGetAggregates() {
    io:println("-----------------Test case for get Environment Event Aggregates API------------------");

    BuiltInProperty timestamp = {
        builtInProperty: "$ts"
    };

    DateHistogramExpression dateHistorgram = {
        dateHistogram: {
            input: timestamp,
            breaks: {
                size: "1m"
            }
        }
    };

    CountMeasureExpression count = {
        count: {}
    };

    AggregateRequest aggregateRequest = {
        searchSpan: {
            'from: {
                dateTime: "2020-03-01T00:00:00.000Z"
            },
            to: {
                dateTime: "2020-03-09T00:00:00.000Z"
            }
        },
        aggregates: [
            {
                dimension: dateHistorgram,
                measures: [count]
            }
        ]
    };

    var response = environmentClient->getAggregates(aggregateRequest);

    io:println(response);
    if (response is AggregatesResponse) {
        test:assertTrue(true, "Events received");
    } else {
        test:assertFail("Event API call fails");
    }
}
