# Core Syntax of the Quingo Language

## Programs
```
<program>               ::= <program head>
                          | <function declarations>
                          | <program head> <function declarations>

<program head>          ::= <package declaration>
                          | <import declarations>
                          | <package declaration> <import declarations>

<function declarations> ::= <function declaration>
                          | <function declarations> <function declaration>
```

## Declarations
```
<package declaration>   ::= package <package name>

<import declarations>   ::= <import declaration>
                          | <import declarations> <import declaration>

<import declaration>    ::= import <package name> ;

<package name>          ::= <identifier>
                          | <package name> . <identifier>

<function declaration>  ::= <function modifier> <function header> <function body>

<function modifier>     ::= operation | opaque

<function header>       ::=  <function declarator> : <type>

<function declarator>   ::= <identifier> ( )
                          | <identifier> ( <formal parameter list>? )

<formal parameter list> ::= <formal parameter>
                          | <formal parameter list> , <formal parameter>

<formal parameter>      ::= <identifier> : <type>
                          | <identifier> : <type> = <expression>

<function body>         ::= <block> | ;
```

## Types
```
<type>              ::= <primitive type>
                      | <tuple type>
                      | <array type>
                      | <function type>

<primitive type>    ::= int
                      | bool
                      | double
                      | unit
                      | qubit
					  | time
					  | timer

<tuple type>        ::= (<type list>)

<type list>         ::= <type>
                      | <type list>, <type>

<array type>        ::= <type> [ ]
                      | <type> [ <expression> ]

<function type>     ::= <type> -> <type>

<id tuple>          ::= (<id list>)

<id list>           ::= <identifier>
                      | <id list>, <identifier>
```

## Blocks and Structures
```
<block>                 ::= { }
                          | { <statements> }

<statements>            ::= <statement>
                          | <statements> <statement>

<statement>             ::= <atomic structure>
                          | <variable declaration>
                          | <if structure>
                          | <if-else structure>
                          | <while structure>
                          | <switch structure>

<atomic structure>      ::= <block>
                          | <empty statement>
                          | <break statement>
                          | <continue statement>
                          | <return statement>
                          | <using structure>
                          | <assignment>
                          | <function call statement>

<variable declaration>  ::= <type> <identifier> ;

<if structure>          ::= if ( <expression> ) <block>
<if-else structure>     ::= if ( <expression> ) <block> else <block>
<while structure>       ::= while ( <expression> ) <block>

<switch structure>      ::= switch ( <expression> ) <switch block>

<switch block>          ::= { <labeled block groups> }

<labeled block groups>  ::= <labeled block group>
                          | <labeled block groups> <labeled block group>

<labeled block group>   ::= <switch labels> <block>

<switch labels>         ::= <switch label>
                          | <switch labels> <switch label>

<switch label>          ::= case <expression> :
                          | default :

<empty statement>       ::= ;
<break statement>       ::= break;
<continue statement>    ::= continue;
<return statement>      ::= return ;
                          | return <expression> ;

<using structure>       ::= using ( <formal parameter list> ) <block>

<assignment>            ::= <left hand side> = <expression> ;

<function call statement> ::= <function with timer> ;

<function with timer>   ::= <function invocation>
                          | <function invocation> @{ <constraints> }
                          | <function invocation> !{ <id list> }
                          | <function invocation> @{ <constraints> } !{ <id list> }

<constraints>           ::= <constraint>
                          | <constraints> && <constraint>
                          | <constraints> || <constraint>
                          | (<constraints>)
                          | !<constraints>

<constraint>            ::= <id> <equal operator>  <expression>
                          | <id> <partial order operator> <expression>

<left hand side>        ::= <identifier>
                          | <array access>
                          | <id tuple>

<array access>          ::= <identifier> <dim expressions>

<function invocation>   ::= <identifier> ( )
                          | <identifier> ( <expression list> )

<expression list>       ::= <expression>
                          | <expression list> , <expression>
```

## Expressions
```
<expression>                ::= <and expression>
                              | <expression> || <and expression>

<and expression>            ::= <equal expression>
			                  | <and expression> && <equal expression>

<equal expression>           ::= <partial order expression>
                              | <equal expression> <equal operator> <partial order expression>

<partial order expression>  ::= <additive expression>
					          | <partial order expression> <partial order operator> <additive expression>

<additive expression>		::= <mult expression>
					          | <additive expression> <additive operator> <mult expression>

<mult expression>           ::= <unary expression>
					          | <mult expression> <multiplicative operator> <unary expression>

<unary expression>          ::= <primary>
                              | <unary operator> <unary expression>

<primary>                   ::= <identifier>
                              | <literal>
                              | <literal> <time unit>
                              | ( <expression list> )
                              | { <expression list> }
                              | <function with timer>
                              | <array access>
                              | <identifier>.length
```

## Dimension Operators
```
<dim expressions> ::= <dim expression>
                    | <dim expressions> <dim expression>

<dim expression>  ::= [ <expression> ]
                    | [ <expression> : <expression> ]
```

## Tokens
```
<equal operator>            ::= ==
                              | !=

<partial order operator>    ::= <
                              | <=
                              | >=
                              | >

<additive operator>         ::= +
                              | -

<multiplicative operator>   ::= *
                              | /
                              | %

<unary operator>            ::= +
                              | -
                              | !

<literal>                   ::= <integer literal>
                              | <boolean literal>
							  | <double literal>

<double literal>            ::= <integer literal> . <integer literal>

<integer literal>           ::= 0 | <non zero digit> <digits>?

<digits>                    ::= <digit>
                              | <digits> <digit>

<digit>                     ::= 0 | <non zero digit>

<non zero digit>            ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

<time unit>                 ::= ps | ns | us | ms | sec

<boolean literal>           ::= true | false
```
