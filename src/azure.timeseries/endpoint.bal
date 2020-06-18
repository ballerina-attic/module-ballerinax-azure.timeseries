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

import ballerina/http;
import ballerina/oauth2;

public type InsightsClient client object {
    private http:Client insightsClient;
    private ConnectionConfiguration config;

    public function init(ConnectionConfiguration connConfig) {
        self.config = connConfig;

        oauth2:OutboundOAuth2Provider oauth2Provider = new ({
            tokenUrl: AZURE_LOGIN_BASE_URL + connConfig.tenantId + "/oauth2/v2.0/token",
            clientId: connConfig.clientId,
            clientSecret: connConfig.clientSecret,
            scopes: [AZURE_TSI_DEFAULT_SCOPE]

        });
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);

        self.insightsClient = new (INSIGHTS_BASE_URL, {
            timeoutInMillis: connConfig.timeoutInMillis,
            auth: {
                authHandler: bearerHandler
            },
            http1Settings: {
                proxy: connConfig.proxyConfig
            }
        });
    }

    # Get details of all the available environments.
    #
    # + return - Array of environment records or error
    public remote function getEnvironments() returns Environment[] | error {
        var httpResponse = self.insightsClient->get(VERSION);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createEnvironments(jsonResponse);
                }
                return processInvalidStatusCode(httpResponse, ENVIRONMENTS_API);
            }
            return processInvalidPayloadFormat(httpResponse, ENVIRONMENTS_API);
        } else {
            return processErrorResponse(httpResponse, ENVIRONMENTS_API);
        }
    }

    # Initiate and get an environment Client.
    #
    # + environmentFqdn - FQDN of the environment
    # + return - Environment client
    public function getEnvironment(string environmentFqdn) returns EnvironmentClient | error {

        EnvironmentClient environmentClient = new EnvironmentClient(environmentFqdn, self.config);
        return environmentClient;
    }

};

public type EnvironmentClient client object {

    public http:Client environmentClient;
    public string BASE_URL;

    public function init(string envFQDN, ConnectionConfiguration connConfig) {
        self.BASE_URL = "https://" + envFQDN;

        oauth2:OutboundOAuth2Provider oauth2Provider = new ({
            tokenUrl: AZURE_LOGIN_BASE_URL + connConfig.tenantId + "/oauth2/v2.0/token",
            clientId: connConfig.clientId,
            clientSecret: connConfig.clientSecret,
            scopes: [AZURE_TSI_DEFAULT_SCOPE]

        });
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);

        self.environmentClient = new (self.BASE_URL, {
            timeoutInMillis: connConfig.timeoutInMillis,
            auth: {
                authHandler: bearerHandler
            },
            http1Settings: {
                proxy: connConfig.proxyConfig
            }
        });
    }

    # Get the availability details of the environment.
    #
    # + return - the `AvailabilityResponse` record if successful or an error
    public remote function getAvailability() returns AvailabilityResponse | error {

        var httpResponse = self.environmentClient->get("/availability" + VERSION);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createAvailabilityResponse(jsonResponse);
                }
                return processInvalidStatusCode(httpResponse, AVAILABILITY_API);
            }
            return processInvalidPayloadFormat(httpResponse, AVAILABILITY_API);
        } else {
            return processErrorResponse(httpResponse, AVAILABILITY_API);
        }
    }

    # Get the Environment Metadata i.e., all properties metadata for a specific time period.
    #
    # + searchSpan - Search time interval
    # + return - Array of property records or error
    public remote function getMetaData(SearchSpan searchSpan) returns PropertyMetaData[] | error {

        MetaDataRequest metaDataRequest = {
            searchSpan: searchSpan
        };
        json eventsReqPayload = check metaDataRequest.cloneWithType(json);

        http:Request request = new;
        request.setJsonPayload(eventsReqPayload);

        var httpResponse = self.environmentClient->post("/metadata" + VERSION, request);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createPropertiesArray(jsonResponse);
                }
                return processInvalidStatusCode(httpResponse, METADATA_API);
            }
            return processInvalidPayloadFormat(httpResponse, METADATA_API);
        } else {
            return processErrorResponse(httpResponse, METADATA_API);
        }
    }

    # Get the Events for a specific time interval based on any filter if needed.
    #
    # + eventRequest - the `EventRequest` Record
    # + return - Event Response record which will contain returned events and metadata or error
    public remote function getEvents(EventsRequest eventRequest) returns EventsResponse | error {

        json eventsReqPayload = check eventRequest.cloneWithType(json);

        http:Request request = new;
        request.setJsonPayload(eventsReqPayload);

        var httpResponse = self.environmentClient->post("/events" + VERSION, request);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createEventsResponse(jsonResponse);
                }
                return processInvalidStatusCode(httpResponse, EVENTS_API);
            }
            return processInvalidPayloadFormat(httpResponse, EVENTS_API);
        } else {
            return processErrorResponse(httpResponse, EVENTS_API);
        }
    }

    # Get the aggregates of the data based on aggregation rules within a time interval.
    #
    # + aggregateRequest - Aggregate Request Record
    # + return - Aggregate Response record, which will contain aggregates events
    public remote function getAggregates(AggregateRequest aggregateRequest) returns AggregatesResponse | error {

        if (aggregateRequest.aggregates.length() != 1) {
            return error("Aggregate request only supports one aggregate clause. More than" +
            "one aggregate clause has to be added as inner aggregates.");
        }

        // todo Validate for either measure/aggregates clause.

        json eventsReqPayload = check aggregateRequest.cloneWithType(json);

        http:Request request = new;
        request.setJsonPayload(eventsReqPayload);

        var httpResponse = self.environmentClient->post("/aggregates" + VERSION, request);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {

                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createAggregateResponse(jsonResponse);
                }
                return processInvalidStatusCode(httpResponse, AGGREGATES_API);
            } 
            return processInvalidPayloadFormat(httpResponse, AGGREGATES_API);
        } else {
            return processErrorResponse(httpResponse, AGGREGATES_API);
        }
    }

};

public type MetaDataRequest record {
    SearchSpan searchSpan;
};
