Connects to Azure Time-series Insights from Ballerina.

# Module Overview

The Azure Insights connector allows you to query Azure Time-series Insights through the REST API. It also allows you to access metadata on environments along with querying for events and aggregates. It handles OAuth 2.0 authentication.

## Azure Insights Operations

The `ballerinax/azure.timeseries` module allows you to perform the following operations.

- Get all available environment meta data
- Get environment availability
- Get environment metadata
- Query environment for events
- Query environment for aggregates

## Compatibility

|                             |       Versions              |
|:---------------------------:|:---------------------------:|
| Ballerina Language          | 1.2.x                       |
| Azure Time-series Insights API          | 2016-12-12                  |

## Azure Insights Clients

There are 2 clients provided by Ballerina to interact with different API groups of the Timeseries Insights REST API.

1. **azure.timeseries:InsightsClient** - This client is the top-most client in the Timeseries module.
This can be used to get the relevant metadata associated with the environments available to the user.

2. **azure.timeseries:EnvironmentClient** - This client can be used to get metadata or query a specific environment.

## Sample

### Create an Environment client

First, import the `ballerinax/azure.timeseries` module into the Ballerina project.

```ballerina
import ballerinax/azure.timeseries;
```

Instantiate the `azure.timeseries:EnvironmentClient` by giving OAuth2 authentication details and environment FQDN.

You can define the Connection configuration and create the Environment client as mentioned below.

```ballerina
azure.timeseries:ConnectionConfiguration connConfig = {
    tenantId: <tenant Id>,
    clientId: <client id>,
    clientSecret: <client secret>
};
// Create the Environment client.
azure.timeseries:EnvironmentClient environmentClient = new(<envFQDN>, connConfig);
```

### Query Events

The `getEvents` remote function can be used to query events with a filter if needed.

```ballerina
EventsRequest eventsRequest = {
    searchSpan: {
        'from: {
            dateTime: "2019-12-30T00:00:00.000Z"
        },
        to: {
            dateTime: "2021-12-30T00:00:00.000Z"
        }
    },
    predicate: {
        eq: {
    'left: {
        property: "latitude",
        'type: "Double"
    },
    'right: 3.14
        }
    },
    top: {
        sort: [
            {
                input: {
                    builtInProperty: "$ts"
                },
                'order: ORDER_DESCENDING
            }
        ],
        count: 5
    }
};

var response = environmentClient->getEvents(eventsRequest);
if (response is EventsResponse) {
    io:println("Events " + response.events);
} else {
    io:println(response.message());
}
```

### Aggregate Events

The `getAggregates` remote function can be used to aggregate events.

```ballerina
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
                dimension: {
                    dateHistogram: {
                        input: {
                            builtInProperty: "$ts"
                        },
                        breaks: {
                            size: "1m"
                        }
                    }
                },
                measures: [{
                    count: {}
                }]
            }
        ]
    };

var response = environmentClient->getAggregates(aggregateRequest);

io:println(response);
if (response is AggregatesResponse) {
    io:println("Aggregates " + response.aggregates);
} else {
    io:println(response.message());
}

```
