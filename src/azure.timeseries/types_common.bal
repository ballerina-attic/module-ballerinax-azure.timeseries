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

# Configuration for Insights Client
#
# + tenantId - TenantId of the environments that needs to be accessed
# + clientId - Client Id of the application that is used for authentication
# + clientSecrect - Client secret of the application that is used for authentication
# + timeoutInMillis - Timeout for the HTTP client used for communication
# + proxyConfig - Proxy config if needed
public type ConnectionConfiguration record {
    string tenantId;
    string clientId;
    string clientSecrect;
    int timeoutInMillis = 60000;
    http:ProxyConfig? proxyConfig = ();
};

# Environment record for the array of environment details returned in Get Environments API
#
# + displayName - Display name of the environment
# + environmentFqdn - Unique, fully-qualified domain name for the environment
# + environmentId - Unique id for the environment
# + resourceId - Resource Id
# + roles - Roles that are defined for the environment
public type Environment record {
    string displayName;
    string environmentFqdn;
    string environmentId;
    string resourceId;
    string[] roles;
};

public const BOOL_DATA_TYPE = "Bool";

public const STRING_DATA_TYPE = "String";

public const DOUBLE_DATA_TYPE = "Double";

public const DATETIME_DATA_TYPE = "DateTime";

public const TIMESPAN_DATA_TYPE = "TimeSpan";

public type DataType BOOL_DATA_TYPE| STRING_DATA_TYPE| DOUBLE_DATA_TYPE| DATETIME_DATA_TYPE|TIMESPAN_DATA_TYPE;

# DateTime datatype used in SearchSpan
#
# + dateTime - DateTime string
public type DateTime record {
    string dateTime;
};

# Search span record used to indicate time interval for the query
#
# + from - The start time of the interval
# + to - The end time of the interval
public type SearchSpan record {
    DateTime 'from;
    DateTime 'to;
};

# Metadata of the properties in the events present
#
# + name - Name of the property
# + type - Type of the property
public type PropertyMetaData record {
    string name;
    DataType 'type;
};

# Record mapped for the response form Environment Availability API
#
# + from - Environment created time
# + to - Last time the events were received
# + intervalSize - Interval size of the distribution of the events
# + distribution - Th distribution along with num of events
public type AvailabiltyResponse record {
    string 'from;
    string 'to;
    string intervalSize;
    map<json> distribution;
};

# Warnings available in the query response if any
#
# + code - predefined warning codes
# + message - A detailed warning message
# + target - A dot-separated JSON path to the JSON input payload entry causing the warning
# + warningDetails - Optional; additional warning details (for example, the position in predicate string)
public type Warning record {
    string code;
    string message;
    string target;
    map<json> warningDetails?;
};

# Schema of the event from Events API
#
# + rid - Unique id for the schema
# + esn - Event source name
# + properties - Metadata of the properties present in the event
public type Schema record {
    int rid;
    string esn;
    PropertyMetaData[] properties;
};

# Event record to map the event details from the Events API
#
# + schema - Schema of the events if present
# + schemaRid - Schema Rid is given if the schema is already defined in first event
# + timestamp - Timestamp of the event
# + values - Event values
public type Event record {
    Schema schema?;
    string schemaRid?;
    string timestamp;
    json[] values;
};

# EventRequest datatype that is used to invoke Environment Events API
#
# + searchSpan - Used to indicate time interval for the query
# + predicate - Filter conditions if any
# + top - Limit clause for the query
public type EventsRequest record {
    SearchSpan searchSpan;
    Predicate predicate?;
    LimitTop top;
};

# Record mapped to the Environment Events API
#
# + warnings - Warnings for the query if any
# + events - Events requested
public type EventsResponse record {
    Warning[] warnings;
    Event[] events;
};

# AggregateRequest datatype that is used to invoke Environment Aggregates API
#
# + searchSpan - Used to indicate time interval for the query
# + predicate - Filter conditions if any
# + aggregates - Aggregates clause
public type AggregateRequest record {
    SearchSpan searchSpan;
    Predicate predicate?;
    Aggregates[] aggregates;
};

# Record mapped to the Environment Aggregates API
#
# + warnings - Warnings for the query if any
# + aggregates - Events requested
public type AggregatesResponse record {
    Warning[] warnings;
    json[] aggregates;
};

# Record used to define Property in predicate/aggregates clause
#
# + property - Name of the propety
# + type - Data type of the property
public type Property record {
    string property;
    DataType 'type;
};

# Record used to define Built in Property in predicate/aggregates clause
#
# + builtInProperty - Name of the propety
public type BuiltInProperty record {
    string builtInProperty;
};
