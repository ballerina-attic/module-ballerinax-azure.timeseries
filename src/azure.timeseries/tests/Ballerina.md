# Compatibility

| Ballerina Language Version  | Azure Insights API Version |
| ----------------------------| -------------------------------|
|  swan-lake-preview1                      |   2016-12-12                           |

## Prerequisites

1. Create an environment in Azure Time-series Insights as mentioned in the [tutorial](https://docs.microsoft.com/en-us/azure/time-series-insights/tutorial-create-populate-tsi-environment)

2. Register new application in Azure AD as mentioned in [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) and configure it to work with client credentials grant type.

3. Configure Azure time-series insights environment to grant access to the application. Refer [Documentation](https://docs.microsoft.com/en-us/azure/time-series-insights/time-series-insights-data-access)

4. Ensure that the environment has events with property `tags.http.status_code` of type `Double`.

## Running Samples

You can use the `test.bal` file to test all the connector actions by following the below steps:

1. Create ballerina.conf file in module-ballerinax-azure.timeseries.
2. Obtain the environment fqdn, client Id, client secret, and tenant id (available in azure portal after prerequisites) and add those values in the ballerina.conf file.

    ```conf
    ENV_FQDN = "<Environment FQDN>"
    TENANT_ID = "<TENANT_ID>"
    CLIENT_ID = "<CLIENT_ID>"
    CLIENT_SECRET = "<CLIENT_SECRET>"
    ```

3. Navigate to the folder `module-ballerinax-azure.timeseries`.
4. Run the following commands to execute the tests.

    ```cmd
    ballerina test azure.timeseries  
    ```
