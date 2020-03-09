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

// todo Differentiate dateTime & Timespan?
public type BasicExpression record {
    Property | BuiltInProperty | boolean | float | string 'left;
    Property | BuiltInProperty | boolean | float | string 'right;
};

public type CompareExpression record {
    Property | BuiltInProperty | float | string 'left;
    Property | BuiltInProperty | float | string 'right;
};

public const ORDINAL_STRING_COMPARRISON = "Ordinal";

public const ORDINAL_IGNORECASE_STRING_COMPARRISON = "OrdinalIgnoreCase";

public type StringComparission ORDINAL_STRING_COMPARRISON | ORDINAL_IGNORECASE_STRING_COMPARRISON;

public type StringCompareExpression record {
    Property | BuiltInProperty | string 'left;
    Property | BuiltInProperty | string 'right;
    StringComparission stringComparison = ORDINAL_IGNORECASE_STRING_COMPARRISON;
};

public type DoubleArithmeticExpression record {
    Property | BuiltInProperty | float 'left;
    Property | BuiltInProperty | float 'right;
};

public type StringArithmeticExpression record {
    Property | BuiltInProperty | float | string 'left;
    Property | BuiltInProperty | float | string 'right;
};

public type AddExpression record {
    DoubleArithmeticExpression add;
};

public type SubExpression record {
    DoubleArithmeticExpression sub;
};

public type DivExpression record {
    DoubleArithmeticExpression div;
};

public type MulExpression record {
    DoubleArithmeticExpression mul;
};

public type ArithmeticExpression AddExpression | SubExpression | DivExpression | MulExpression;


public type EndsWithExpression record {
    StringCompareExpression endsWith;
};

public type StartsWithExpression record {
    StringCompareExpression startsWith;
};

public type RegexExpression record {
    StringCompareExpression regex;
};

public type PhraseExpression record {
    StringCompareExpression phrase;
};

public type GreaterThanOrEqualExpression record {
    CompareExpression | ArithmeticExpression gte;
};

public type GreaterThanExpression record {
    CompareExpression | ArithmeticExpression gt;
};

public type LessThanOrEqualExpression record {
    CompareExpression | ArithmeticExpression lte;
};

public type LessThanExpression record {
    CompareExpression | ArithmeticExpression lt;
};

public type EqualAnyExpression record {
    BasicExpression | ArithmeticExpression 'in;
};

public type EqualExpression record {
    BasicExpression | ArithmeticExpression eq;
};

public type ComparisonExpression
 EqualExpression | EqualAnyExpression | LessThanExpression | LessThanOrEqualExpression |
 GreaterThanExpression | GreaterThanOrEqualExpression | PhraseExpression | RegexExpression |
 StartsWithExpression | EndsWithExpression;

public type AndExpression record {
    ComparisonExpression[] and;
};

public type OrExpression record {
    ComparisonExpression[] or;
};

public type NotExpression record {
    ComparisonExpression not;
};

public type LogicalExpression AndExpression | OrExpression | NotExpression;

public type Predicate LogicalExpression | ComparisonExpression;


