Connects to Azure Time-series Insights from Ballerina.

# Module Overview

The Azure Insights connector allows you to query Azure Time-series Insights through the  REST API. It also allows you access metadata on environments along with querying for events and aggregates. It handles OAuth 2.0 authentication.

## Azure Insights Operations

The `ballerinax/azure.timeseries` module allows you to perform following operations,

- Get all available environment meta data
- Get Environment availability
- Get Environment metadata
- Query environment for events
- Query environment for aggregates

## Compatibility

|                             |       Versions              |
|:---------------------------:|:---------------------------:|
| Ballerina Language          | 1.1.x                       |
| Azure Time-series Insights API          | 2016-12-12                  |

## Sample

### Create Insights client

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
    clientSecrect: <client secrect>
};
// Create the Environment client.
azure.timeseries:EnvironmentClient envClient = new(<envFQDN>, connConfig);
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
            property: "lattitude",
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
        io:println(response.detail()?.message.toString());
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
        io:println("Aggregates " + response.aggregaaggregatestes);
    } else {
        io:println(response.detail()?.message.toString());
    }

```
