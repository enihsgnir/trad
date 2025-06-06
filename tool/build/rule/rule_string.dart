/// LALR(1) grammar
const ruleString = """
start
  : definitions
  ;

definitions
  : definitions definition
  |
  ;

definition
  : variableDeclaration
  | functionDeclaration
  ;

variableDeclaration
  : type id ';'
  | type id '=' expression ';'
  ;

functionDeclaration
  : type id '(' parameterList ')' functionBody
  ;

parameterList
  : parameters
  |
  ;

parameters
  : parameters ',' parameter
  | parameter
  ;

parameter
  : type id
  ;

functionBody
  : block
  | '=>' expression ';'
  ;

type
  : 'int'
  | 'String'
  | 'bool'
  | 'List' '<' type '>'
  | 'void'
  ;

block
  : '{' statements '}'
  ;

statements
  : statements statement
  |
  ;

statement
  : block
  | expressionStatement
  | returnStatement
  | ifStatement
  | forStatement
  | whileStatement
  | breakStatement
  | variableDeclaration
  ;

expressionStatement
  : expression ';'
  ;

returnStatement
  : 'return' expression ';'
  | 'return' ';'
  ;

ifStatement
  : 'if' '(' expression ')' block elseStatement
  ;

elseStatement
  : 'else' ifStatement
  | 'else' block
  |
  ;

forStatement
  : 'for' '(' variableDeclaration expression ';' expression ')' block
  ;

whileStatement
  : 'while' '(' expression ')' block
  ;

breakStatement
  : 'break' ';'
  | 'continue' ';'
  ;

expression
  : assignmentExpression
  | conditionalExpression
  ;

assignmentExpression
  : id '=' expression
  // | id '[' expression ']' '=' expression
  ;

conditionalExpression
  : logicalOrExpression '?' expression ':' expression
  | logicalOrExpression
  ;

logicalOrExpression
  : logicalOrExpression '||' logicalAndExpression
  | logicalAndExpression
  ;

logicalAndExpression
  : logicalAndExpression '&&' equalityExpression
  | equalityExpression
  ;

equalityExpression
  : relationalExpression '==' relationalExpression
  | relationalExpression '!=' relationalExpression
  | relationalExpression
  ;

relationalExpression
  : additiveExpression '<=' additiveExpression
  | additiveExpression '>=' additiveExpression
  | additiveExpression '<' additiveExpression
  | additiveExpression '>' additiveExpression
  | additiveExpression
  ;

additiveExpression
  : additiveExpression '+' multiplicativeExpression
  | additiveExpression '-' multiplicativeExpression
  | multiplicativeExpression
  ;

multiplicativeExpression
  : multiplicativeExpression '*' unaryExpression
  | multiplicativeExpression '~/' unaryExpression
  | multiplicativeExpression '%' unaryExpression
  | unaryExpression
  ;

unaryExpression
  : '-' unaryExpression
  | '!' unaryExpression
  | primary
  ;

primary
  : literal
  | id
  | '(' expression ')'
  | functionInvocation
  ;

literal
  : num
  | str
  | 'true'
  | 'false'
  | listLiteral
  ;

listLiteral
  : '[' ']'
  | '[' expressionList ']'
  ;

expressionList
  : expressionList ',' expression
  | expression
  ;

functionInvocation
  : id arguments
  ;

arguments
  : '(' expressionList ')'
  | '(' ')'
  ;
""";
