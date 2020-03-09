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

public type InsightsConfiguration record {
    string tenantId;
    string clientId;
    string clientSecrect;
    int timeoutInMillis = 60000;
    http:ProxyConfig? proxyConfig = ();
};

public type EnvironmentConfiguration record {
    string environmentFqdn;
    string tenantId;
    string clientId;
    string clientSecrect;
    int timeoutInMillis = 60000;
    http:ProxyConfig? proxyConfig = ();
};

public type Environment record {
    string displayName;
    string environmentFqdn;
    string environmentId;
    string resourceId;
    string[] roles;
};

public type DateTime record {
    string dateTime;
};

public type SearchSpan record {
    DateTime 'from;
    DateTime 'to;
};

public type Property record {
    string property;
    string 'type;
};

public type BuiltInProperty record {
    string builtInProperty;
};

public type Input record {
    Property | BuiltInProperty input;
    Property | BuiltInProperty orderBy?;
};

public type Order ORDER_ASECNDING | ORDER_DESCENDING;

public const ORDER_ASECNDING = "Asc";

public const ORDER_DESCENDING = "Desc";

public type Sort record {
    Property | BuiltInProperty input;
    Order 'order;
};

public type LimitTop record {
    Sort[] sort;
    int count;
};

public type LimitTake record {
    int take;
};

public type LimitSample record {
    int sample;
};


public type NumericBreaks record {
    int count;
};

public type DateBreaks record {
    string size;
    string 'from?;
    string 'to?;
};

public type UniqueValues record {
    Property | BuiltInProperty input;
    int take;
};

public type UniqueValuesExpression record {
    UniqueValues uniqueValues;
};

public type DateHistogram record {
    Property | BuiltInProperty input;
    DateBreaks breaks;
};

public type DateHistogramExpression record {
    DateHistogram dateHistogram;
};

public type NumericHistogram record {
    Property | BuiltInProperty input;
    NumericBreaks breaks;
};

public type NumericHistogramExpression record {
    NumericHistogram numericHistogram;
};

public type Dimension UniqueValuesExpression | DateHistogramExpression | NumericHistogramExpression;

public type CountMeasureExpression record {
    json count;
};

public type MinMeasureExpression record {
    Input min;
};

public type MaxMeasureExpression record {
    Input max;
};

public type AvgMeasureExpression record {
    Input avg;
};

public type SumMeasureExpression record {
    Input sum;
};

public type FirstMeasureExpression record {
    Input first;
};

public type LastMeasureExpression record {
    Input last;
};

public type Measure CountMeasureExpression | MinMeasureExpression | MaxMeasureExpression | AvgMeasureExpression
 | SumMeasureExpression | FirstMeasureExpression | LastMeasureExpression;

// todo Validate for either measures/aggregates
public type Aggregates record {
    Dimension dimension;
    Measure[] measures?;
    Aggregates aggregates?;
};

public type AvailabiltyResponse record {
    string 'from;
    string 'to;
    string intervalSize;
    map<json> distribution;
};

public type MetaDataRequest record {
    SearchSpan searchSpan;
};

public type PropertyMetaData record {
    string name;
    string 'type;
};

public type Warning record {
    string code;
    string message;
    string target;
    map<json> warningDetails?;
};

public type Schema record {
    int rid;
    string esn;
    PropertyMetaData[] properties;
};

//todo Either Schema or schemaRid
public type Event record {
    Schema schema?;
    string schemaRid?;
    string timestamp;
    json[] values;
};

public type EventsRequest record {
    SearchSpan searchSpan;
    Predicate predicate?;
    LimitTop top;
};

public type EventsResponse record {
    Warning[] warnings;
    Event[] events;
};


public type AggregateRequest record {
    SearchSpan searchSpan;
    Predicate predicate?;
    Aggregates[] aggregates;
};

public type AggregatesResponse record {
    Warning[] warnings;
    json[] aggregates;
};


