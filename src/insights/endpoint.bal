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
    private InsightsConfiguration config;

    public function __init(InsightsConfiguration insightsConfig) {
        self.config = insightsConfig;

        string BASE_URL = "https://api.timeseries.azure.com/environments";

        oauth2:OutboundOAuth2Provider oauth2Provider = new ({
            tokenUrl: "https://login.microsoftonline.com/" + insightsConfig.tenantId + "/oauth2/v2.0/token",
            clientId: insightsConfig.clientId,
            clientSecret: insightsConfig.clientSecrect,
            scopes: ["https://api.timeseries.azure.com//.default"]

        });
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);

        self.insightsClient = new (BASE_URL, {
            timeoutInMillis: insightsConfig.timeoutInMillis,
            auth: {
                authHandler: bearerHandler
            },
            http1Settings: {
                proxy: insightsConfig.proxyConfig
            }
        });
    }


    # Get details of all the available environments
    #
    # + return - Array of environment records or error
    public remote function getEnvironments() returns @tainted (Environment[] | error) {
        var httpResponse = self.insightsClient->get(VERSION);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createEnvironments(jsonResponse);
                }
                return processResBodyError(jsonResponse);
            }
            return error(ERROR_CODE, message = "Error occurred while accessing the JSON payload of the response");
        } else {
            return processResError(httpResponse);
        }
    }

    # Initiate and get an environment Client
    #
    # + environmentFqdn - FQDN of the environment
    # + return - Environment client
    public function getEnvironment(string environmentFqdn) returns EnvironmentClient | error {
        EnvironmentConfiguration environConfig = {
            environmentFqdn: environmentFqdn,
            tenantId: self.config.tenantId,
            clientId: self.config.clientId,
            clientSecrect: self.config.clientSecrect,
            timeoutInMillis: self.config.timeoutInMillis,
            proxyConfig: self.config.proxyConfig
        };

        EnvironmentClient environmentClient = new EnvironmentClient(environConfig);
        return environmentClient;
    }

};

public type EnvironmentClient client object {

    public http:Client environmentClient;
    public string BASE_URL;

    public function __init(EnvironmentConfiguration environmentConfiguration) {
        self.BASE_URL = "https://" + environmentConfiguration.environmentFqdn;

        oauth2:OutboundOAuth2Provider oauth2Provider = new ({
            tokenUrl: "https://login.microsoftonline.com/" + environmentConfiguration.tenantId + "/oauth2/v2.0/token",
            clientId: environmentConfiguration.clientId,
            clientSecret: environmentConfiguration.clientSecrect,
            scopes: ["https://api.timeseries.azure.com//.default"]

        });
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);

        self.environmentClient = new (self.BASE_URL, {
            timeoutInMillis: environmentConfiguration.timeoutInMillis,
            auth: {
                authHandler: bearerHandler
            },
            http1Settings: {
                proxy: environmentConfiguration.proxyConfig
            }
        });
    }

    # Get the availability details of the environment
    #
    # + return - AvailabiltyResponse record if successful else an error
    public remote function getAvailability() returns @tainted (AvailabiltyResponse | error) {

        var httpResponse = self.environmentClient->get("/availability" + VERSION);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createAvailabilityResponse(jsonResponse);
                }
                return processResBodyError(jsonResponse);
            }
            return error(ERROR_CODE, message = "Error occurred while accessing the JSON payload of the response");
        } else {
            return processResError(httpResponse);
        }
    }


    # Get the Environment Metadata i.e. all properties metadata for a specific timeperiod
    #
    # + searchSpan - Search time interval
    # + return - Array of property records or error
    public remote function getMetaData(SearchSpan searchSpan) returns @tainted (PropertyMetaData[] | error) {

        MetaDataRequest metaDataRequest = {
            searchSpan: searchSpan
        };
        json eventsReqPayload = check json.constructFrom(metaDataRequest);

        http:Request request = new;
        request.setJsonPayload(eventsReqPayload);

        var httpResponse = self.environmentClient->post("/metadata" + VERSION, request);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createPropertiesArray(jsonResponse);
                }
                return processResBodyError(jsonResponse);

            }
            return error(ERROR_CODE, message = "Error occurred while accessing the JSON payload of the response");
        } else {
            return processResError(httpResponse);
        }
    }

    # Get the Events for a specific time interval based on any filter if needed 
    #
    # + eventRequest - EventRequest Record
    # + return - Event Response record which will contain returned events and metadata or error
    public remote function getEvents(EventsRequest eventRequest) returns @tainted (EventsResponse | error) {

        json eventsReqPayload = check json.constructFrom(eventRequest);

        http:Request request = new;
        request.setJsonPayload(eventsReqPayload);

        var httpResponse = self.environmentClient->post("/events" + VERSION, request);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createEventsResponse(jsonResponse);
                }
                return processResBodyError(jsonResponse);
            }
            return error(ERROR_CODE, message = "Error occurred while accessing the JSON payload of the response");
        } else {
            return processResError(httpResponse);
        }
    }

    # Get the aggregates of the data based on aggregation rules within a time interval
    #
    # + aggregateRequest - Aggregate Request Record
    # + return - Aggregate Response record which will contain aggregates events
    public remote function getAggregates(AggregateRequest aggregateRequest) returns @tainted (AggregatesResponse | error) {

        json eventsReqPayload = check json.constructFrom(aggregateRequest);

        http:Request request = new;
        request.setJsonPayload(eventsReqPayload);

        var httpResponse = self.environmentClient->post("/aggregates" + VERSION, request);

        if (httpResponse is http:Response) {
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {

                if (httpResponse.statusCode == http:STATUS_OK) {
                    return createAggregateResponse(jsonResponse);
                }
                return processResBodyError(jsonResponse);
            }
            return error(ERROR_CODE, message = "Error occurred while accessing the JSON payload of the response");
        } else {
            return processResError(httpResponse);
        }
    }

};

