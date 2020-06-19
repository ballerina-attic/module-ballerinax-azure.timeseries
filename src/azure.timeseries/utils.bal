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
import ballerina/http;

function processErrorResponse(error errorResponse, TIMESERIES_API apiName) returns @untainted error {
    return error("Error invoking '" + apiName.toString() + "'.", cause = errorResponse);
}

function processInvalidPayloadFormat(http:Response response, TIMESERIES_API apiName) returns @untainted error {
    return error("Invalid response format from '" + apiName.toString() + "', expecting 'JSON'. Payload: " + 
                response.getTextPayload().toString());
}

function processInvalidStatusCode(http:Response response, TIMESERIES_API apiName) returns @untainted error {
    return error("Invalid response from '" + apiName.toString() + "'. Status code: " + response.statusCode.toString() + 
                ", payload: " + response.getTextPayload().toString());
}

function createEnvironments(json jsonResponse) returns @untainted (Environment[] | error) {
    Environment[] environments = convertToEnvironments(<json[]>jsonResponse.environments);
    return environments;
}

function convertToEnvironments(json[] jsonEnv) returns Environment[] {
    int i = 0;
    Environment[] environments = [];
    foreach json environment in jsonEnv {

        json[] rolesJson = <json[]>environment.roles;

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


function createAvailabilityResponse(json jsonResponse) returns @untainted AvailabilityResponse {
    AvailabilityResponse response = {
        'from: <string>jsonResponse.range.'from,
        'to: <string>jsonResponse.range.'to,
        intervalSize: <string>jsonResponse.intervalSize,
        distribution: <map<json>>jsonResponse.distribution
    };
    return response;
}

function createPropertiesArray(json jsonResponse) returns @untainted (PropertyMetaData[] | error) {
    PropertyMetaData[] properties = convertToProperties(<json[]>jsonResponse.properties);
    return properties;
}

function convertToProperties(json[] jsonProperties) returns PropertyMetaData[] {
    int i = 0;
    PropertyMetaData[] properties = [];
    foreach json property in jsonProperties {
        properties[i] = {
            name: property.name.toString(),
            'type: <DataType> property.'type
        };
        i = i + 1;
    }
    return properties;
}

function createEventsResponse(json jsonResponse) returns @untainted (EventsResponse | error) {
    Warning[] warningsArray = !(jsonResponse.warnings is error)
    ? convertToWarnings(<json[]>jsonResponse.warnings) : [];
    EventsResponse eventsResponse = {
        warnings: warningsArray,
        category: convertToSchemaCategories(<json[]>jsonResponse.events)
    };
    return eventsResponse;
}

function convertToSchemaCategories(json[] jsonEvents) returns SchemaCategory[] {
    int i = 0;
    Event[] events = [];

    map <SchemaCategory> schemas = {};

    foreach json event in jsonEvents {
        // Cast to access fields with special characters i.e $
        map<json> eventObj = <map<json>>event;

        if (eventObj.schemaRid is error) {
            
            PropertyMetaData[] properties = convertToProperties(<json[]> eventObj.schema.properties);
            map<json> eventSchema = <map<json>> eventObj.schema;

            SchemaCategory schemaCategory = {
                rid: eventSchema.rid.toString(),
                esn: eventSchema["$esn"].toString(),
                properties: properties,
                events: []
            };
        
            schemaCategory.events.push(populateEvent(eventObj, properties));
            schemas[eventSchema.rid.toString()] = schemaCategory;

        } else {
            SchemaCategory schema = schemas.get(eventObj.schemaRid.toString());
            schema.events.push(populateEvent(eventObj, schema.properties));

        }
        i = i + 1;
    }
    return schemas.toArray();
}

function populateEvent(map<json> eventObj, PropertyMetaData[] properties) returns @untainted Event {
    map <anydata> eventValues = {};
    json[] values = <json[]> eventObj.values;

    int j = 0;
    foreach json value in values {
        string propertyName = properties[j].name;
        eventValues[propertyName] = value;
        j = j + 1;
    }

    Event eventValue = {
        timestamp: eventObj["$ts"].toString(),
        values: eventValues
    };
    
    return eventValue;
}

function createAggregateResponse(json jsonResponse) returns @untainted (AggregatesResponse | error) {
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
