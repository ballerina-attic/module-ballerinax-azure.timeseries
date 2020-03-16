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

# Record used to indicate Arithmetic expression with operands of type Double
#
# + left - Left operand
# + right - Right operand
public type DoubleArithmeticExpression record {
    Property | BuiltInProperty | float 'left;
    Property | BuiltInProperty | float 'right;
};

# Record used to indicate Arithmetic expression with operands of type DateTime/Timespan
#
# + left - Left operand
# + right - Right operand
public type StringArithmeticExpression record {
    Property | BuiltInProperty | DateTime | TimeSpan | string 'left;
    Property | BuiltInProperty | DateTime | TimeSpan | string 'right;
};

# Add Arithmetic Expression
#
# + add - Add expression
public type AddExpression record {
    DoubleArithmeticExpression | StringArithmeticExpression add;
};

# Subtract Arithmetic Expression
#
# + sub - Subtract expression
public type SubExpression record {
    DoubleArithmeticExpression | StringArithmeticExpression sub;
};

# Division Arithmetic Expression
#
# + div - Division expression
public type DivExpression record {
    DoubleArithmeticExpression div;
};

# Multiplication Arithmetic Expression
#
# + mul - Multiplication expression
public type MulExpression record {
    DoubleArithmeticExpression mul;
};

# Arithmetic Expression type
public type ArithmeticExpression AddExpression | SubExpression | DivExpression | MulExpression;


# Constant used to indicate to consider case when comparing strings
public const ORDINAL_STRING_COMPARISON = "Ordinal";

# Constant used to indicate to ignore case when comparing strings
public const ORDINAL_IGNORECASE_STRING_COMPARISON = "OrdinalIgnoreCase";

# Record for string comparision element in string compare expression
public type StringComparision ORDINAL_STRING_COMPARISON | ORDINAL_IGNORECASE_STRING_COMPARISON;

# Compare expression for string datatype
#
# + left - Left Operand
# + right - Right Operand
# + stringComparison - Indicate whether to consider/ignore case when comparing
public type StringCompareExpression record {
    Property | BuiltInProperty | string 'left;
    Property | BuiltInProperty | string 'right;
    StringComparision stringComparison = ORDINAL_IGNORECASE_STRING_COMPARISON;
};

# Ends with compare expression
#
# + endsWith - A string compare expression
public type EndsWithExpression record {
    StringCompareExpression endsWith;
};

# Starts with compare expression
#
# + startsWith - A string compare expression
public type StartsWithExpression record {
    StringCompareExpression startsWith;
};

# Regex compare expression
#
# + regex - A string compare expression
public type RegexExpression record {
    StringCompareExpression regex;
};

# Phrase compare expression
#
# + phrase - A string compare expression
public type PhraseExpression record {
    StringCompareExpression phrase;
};

# Basic Compare expression without boolean type
#
# + left - Left Operand
# + right - Right Operand
public type BasicCompareExpression record {
    Property | BuiltInProperty | DateTime | TimeSpan | float | string 'left;
    Property | BuiltInProperty | DateTime | TimeSpan | float | string 'right;
};

# Greater than or equal compare expression
#
# + gte - A basic compare expression
public type GreaterThanOrEqualExpression record {
    BasicCompareExpression | ArithmeticExpression gte;
};

# Greater than compare expression
#
# + gt - A basic compare expression
public type GreaterThanExpression record {
    BasicCompareExpression | ArithmeticExpression gt;
};

# Less than or equal compare expression
#
# + lte - A basic compare expression
public type LessThanOrEqualExpression record {
    BasicCompareExpression | ArithmeticExpression lte;
};

# Less than compare expression
#
# + lt - A basic compare expression
public type LessThanExpression record {
    BasicCompareExpression | ArithmeticExpression lt;
};

# Compare expression including boolean type
#
# + left - Left Operand
# + right - Right Operand
public type CompareExpression record {
    Property | BuiltInProperty | boolean | float | string 'left;
    Property | BuiltInProperty | boolean | float | string 'right;
};

# Equal Any (in) compare expression
#
# + in - A compare expression
public type EqualAnyExpression record {
    CompareExpression | ArithmeticExpression 'in;
};

# Equal compare expression
#
# + eq - A compare expression
public type EqualExpression record {
    CompareExpression | ArithmeticExpression eq;
};

# ComparisonExpression Expression type
public type ComparisonExpression
 EqualExpression | EqualAnyExpression | LessThanExpression | LessThanOrEqualExpression |
 GreaterThanExpression | GreaterThanOrEqualExpression | PhraseExpression | RegexExpression |
 StartsWithExpression | EndsWithExpression;

# And logical expression
#
# + and - A comparision expression
public type AndExpression record {
    ComparisonExpression[] and;
};

# Or logical expression
#
# + or - A comparision expression
public type OrExpression record {
    ComparisonExpression[] or;
};

# Not logical expression
#
# + not - A comparision expression
public type NotExpression record {
    ComparisonExpression not;
};

# LogicalExpression Expression type
public type LogicalExpression AndExpression | OrExpression | NotExpression;

# Predicate Clause type
public type Predicate LogicalExpression | ComparisonExpression;


