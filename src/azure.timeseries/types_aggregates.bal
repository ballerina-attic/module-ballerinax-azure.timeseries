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

# Input type used to define property in aggregate clause
#
# + input - Property used for aggregates
# + orderBy - Order by property
public type Input record {
    Property | BuiltInProperty input;
    Property | BuiltInProperty orderBy?;
};

# Ascending order type
public const ORDER_ASECNDING = "Asc";

# Descending order type
public const ORDER_DESCENDING = "Desc";

# Order record
public type Order ORDER_ASECNDING | ORDER_DESCENDING;

# Sort type used to sort the returned results
#
# + input - property used to sort
# + order - Asc/Desc
public type Sort record {
    Property | BuiltInProperty input;
    Order 'order;
};

# Clause to limit specified number of values in either ascending or descending order.
# The number of values is limited as per the specified count.
#
# + sort - Property used for sorting before limit
# + count - Number of events to return
public type LimitTop record {
    Sort[] sort;
    int count;
};

# Clause used in histogram expressions to specify how a numeric range should be divided.
# 
# + count - Number of events per break
public type NumericBreaks record {
    int count;
};

# Clause used in histogram expressions to specify how a date range should be divided.
# 
# + size - Size of the interval
# + from - Start time for the breaks
# + to - End time for the breaks
public type DateBreaks record {
    string size;
    string 'from?;
    string 'to?;
};

# Dimension for aggregates based on unique values
# 
# + input - Property used to get unique values
# + take - Limit of the unique values
public type UniqueValues record {
    Property | BuiltInProperty input;
    int take;
};

# Unique Value Expression to be passed to dimension
# 
# + uniqueValues - UniqueValues record
public type UniqueValuesExpression record {
    UniqueValues uniqueValues;
};


# Dimension for aggregates based on datetime breaks
# 
# + input - Property used to get datetime values
# + breaks - Break information
public type DateHistogram record {
    Property | BuiltInProperty input;
    DateBreaks breaks;
};

# Date Histogram Expression to be passed to dimension
# 
# + dateHistogram - DateHistogram record
public type DateHistogramExpression record {
    DateHistogram dateHistogram;
};

# Dimension for aggregates based on event count breaks
# 
# + input - Property used to get datetime values
# + breaks - Break information
public type NumericHistogram record {
    Property | BuiltInProperty input;
    NumericBreaks breaks;
};

# Numeric Histogram Expression to be passed to dimension
# 
# + numericHistogram - NumericHistogram record
public type NumericHistogramExpression record {
    NumericHistogram numericHistogram;
};

# Dimensions record type
public type Dimension UniqueValuesExpression | DateHistogramExpression | NumericHistogramExpression;

# Count mesure expression
# 
# + count - Empty json
public type CountMeasureExpression record {
    json count = {};
};

# Min mesure expression
# 
# + min - Property for which min is to be found
public type MinMeasureExpression record {
    Input min;
};

# Max mesure expression
# 
# + max - Property for which max is to be found
public type MaxMeasureExpression record {
    Input max;
};

# Avg mesure expression
# 
# + avg - Property for which avg is to be found
public type AvgMeasureExpression record {
    Input avg;
};

# Sum mesure expression
# 
# + sum - Property for which sum is to be found
public type SumMeasureExpression record {
    Input sum;
};

# First mesure expression
# 
# + first - Property for which first is to be found
public type FirstMeasureExpression record {
    Input first;
};

# Last mesure expression
# 
# + last - Property for which last is to be found
public type LastMeasureExpression record {
    Input last;
};

# Measure record type
public type Measure CountMeasureExpression | MinMeasureExpression | MaxMeasureExpression | AvgMeasureExpression
 | SumMeasureExpression | FirstMeasureExpression | LastMeasureExpression;

# Aggregates record type 
# 
# + dimension - Dimensions on which aggregates to be calculated
# + measures - Aggregates functions
# + aggregates - Inner aggregate clause
public type Aggregates record {
    Dimension dimension;
    Measure[] measures?;
    Aggregates aggregates?;
};
