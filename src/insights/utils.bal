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

function processResError(error errorResponse) returns error {
    error err = error(ERROR_CODE, message = <string> errorResponse.detail()?.message);
    return err;
}

function processResBodyError(json errorResponse) returns error {
    error err = error(ERROR_CODE, message = errorResponse.toString());
    return err;
}

function createEnvironments(json jsonResponse) returns Environment[] | error {
    Environment[] environments = convertToEnvironments(<json[]>jsonResponse.environments);
    return environments;
}

function convertToEnvironments(json[] jsonEnv) returns Environment[] {
    int i = 0;
    Environment[] environments = [];
    foreach json environment in jsonEnv {

        json[] rolesJson = <json[]> environment.roles;

        int j = 0;
        string[] roles = [];
        foreach json role in rolesJson {
            roles[j] = rolesJson[j].toString();
        }

        environments[i] = {
            displayName: environment.displayName.toString(),
            environmentFqdn: environment.environmentFqdn.toString(),
            environmentId: environment.environmentId.toString(),
            resourceId: environment.resourceId.toString(),
            roles: roles
        };
        i = i + 1;
    }
    return environments;
}


function createAvailabilityResponse(json jsonResponse) returns AvailabiltyResponse {
    AvailabiltyResponse response = {
        'from: <string>jsonResponse.range.'from,
        'to: <string>jsonResponse.range.'to,
        intervalSize: <string>jsonResponse.intervalSize,
        distribution: <map<json>>jsonResponse.distribution
    };
    return response;
}

function createPropertiesArray(json jsonResponse) returns PropertyMetaData[] | error {
    PropertyMetaData[] properties = convertToProperties(<json[]>jsonResponse.properties);
    return properties;
}

function convertToProperties(json[] jsonProperties) returns PropertyMetaData[] {
    int i = 0;
    PropertyMetaData[] properties = [];
    foreach json property in jsonProperties {
        properties[i] = {
            name: property.name.toString(),
            'type: property.'type.toString()
        };
        i = i + 1;
    }
    return properties;
}

function createEventsResponse(json jsonResponse) returns EventsResponse | error {
    Warning[] warningsArray = !(jsonResponse.warnings is error)
    ? convertToWarnings(<json[]>jsonResponse.warnings) : [];
    EventsResponse eventsResponse = {
        warnings: warningsArray,
        events: convertToEvents(<json[]>jsonResponse.events)
    };
    return eventsResponse;
}

function convertToEvents(json[] jsonEvents) returns Event[] {
    int i = 0;
    Event[] events = [];
    foreach json event in jsonEvents {
        // Casted to access fields with special characters i.e $
        map<json> eventObj = <map<json>> event;

        events[i] = {
            timestamp: eventObj["$ts"].toString(),
            values: <json[]> event.values
        };

        if (i == 0) {
            PropertyMetaData[] properties = convertToProperties(<json[]>event.schema.properties);
            map<json> eventScema = <map<json>> event.schema;

            events[i].schema = {
                rid: <int> eventScema.rid,
                esn: eventScema["$esn"].toString(),
                properties: properties
            };
        } else {
            events[i].schemaRid = event.schemaRid.toString();
        }
        i = i + 1;
    }
    return events;
}

function createAggregateResponse(json jsonResponse) returns AggregatesResponse | error {
    Warning[] warningsArray = !(jsonResponse.warnings is error)
    ? convertToWarnings(<json[]>jsonResponse.warnings) : [];
    AggregatesResponse aggregateResponse = {
        warnings: warningsArray,
        aggregates: <json[]>jsonResponse.aggregates
    };

    return aggregateResponse;
}

function convertToWarnings(json[] jsonWarning) returns Warning[] {
    int i = 0;
    Warning[] warnings = [];
    foreach json warning in jsonWarning {
        warnings[i] = {
            code: warning.code.toString(),
            message: warning.message.toString(),
            target: warning.target.toString(),
            warningDetails: <map<json>>warning.warningDetails
        };
        i = i + 1;
    }
    return warnings;
}


