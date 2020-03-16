## Module Overview

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
| Ballerina Language          | 1.1.x                       |
| Azure Time-series Insights API          | 2016-12-12                  |

## Feature Overview

### Azure Insights Clients

There are 2 clients provided by Ballerina to interact with different API groups of the Timeseries Insights REST API. 

1. **azure.timeseries:InsightsClient** - This client is the top-most client in the Timeseries module. 
This can be used to get the relevant metadata associated with the environments available to the user.

2. **azure.timeseries:EnvironmentClient** - This client can be used to get metadata or query a specific environment.

## Getting Started

### Prerequisites
Download and install [Ballerina](https://ballerinalang.org/downloads/).

### Pull the Module
Execute the below command to pull the `Azure.Timeseries` module from Ballerina Central:

```ballerina
$ ballerina pull ballerinax/azure.timeseries
```

## Sample

The EnvironmentClient `getEvents()` remote function can be used to query events available in the environment.

```ballerina
import ballerina/log;
import ballerinax/azure.timeseries;
azure.timeseries:ConnectionConfiguration connConfig = {
    tenantId: <tenant Id>,
    clientId: <client id>,
    clientSecrect: <client secrect>
};

public function main() {
    
    azure.timeseries:EnvironmentClient environmentClient = new(<envFQDN>, connConfig);
    
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
}
```
