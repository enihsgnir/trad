# Variables
<pre>
⟨finalConstVarOrType⟩ ::=
    <b>late</b>? <b>final</b> ⟨type⟩?
  | <b>const</b> ⟨type⟩?
  | <b>late</b>? ⟨varOrType⟩

⟨varOrType⟩ ::=
    <b>var</b>
  | ⟨type⟩

⟨initializedVariableDeclaration⟩ ::=
    ⟨declaredIdentifier⟩ (‘=’ ⟨expression⟩)? (‘,’ ⟨initializedIdentifier⟩)*

⟨initializedIdentifier⟩ ::=
    ⟨identifier⟩ (‘=’ ⟨expression⟩)?

⟨initializedIdentifierList⟩ ::=
    ⟨initializedIdentifier⟩ (‘,’ ⟨initializedIdentifier⟩)*
</pre>

# Functions
<pre>
⟨functionSignature⟩ ::=
    ⟨type⟩? ⟨identifier⟩ ⟨formalParameterPart⟩

⟨formalParameterPart⟩ ::=
    ⟨typeParameters⟩? ⟨formalParameterList⟩

⟨functionBody⟩ ::=
    <b>async</b>? ‘=>’ ⟨expression⟩ ‘;’
  | (<b>async</b> ‘*’? | <b>sync</b> ‘*’)? ⟨block⟩

⟨block⟩ ::=
    ‘{’ ⟨statements⟩ ‘}’
</pre>

## Formal Parameters
<pre>
⟨formalParameterList⟩ ::=
    ‘(’ ‘)’
  | ‘(’ ⟨normalFormalParameters⟩ ‘,’? ‘)’
  | ‘(’ ⟨normalFormalParameters⟩ ‘,’ ⟨optionalOrNamedFormalParameters⟩ ‘)’
  | ‘(’ ⟨optionalOrNamedFormalParameters⟩ ‘)’

⟨normalFormalParameters⟩ ::=
    ⟨normalFormalParameter⟩ (‘,’ ⟨normalFormalParameter⟩)*

⟨optionalOrNamedFormalParameters⟩ ::=
    ⟨optionalPositionalFormalParameters⟩
  | ⟨namedFormalParameters⟩

⟨optionalPositionalFormalParameters⟩ ::=
    ‘[’ ⟨defaultFormalParameter⟩ (‘,’ ⟨defaultFormalParameter⟩)* ‘,’? ‘]’

⟨namedFormalParameters⟩ ::=
    ‘{’ ⟨defaultNamedParameter⟩ (‘,’ ⟨defaultNamedParameter⟩)* ‘,’? ‘}’
</pre>

### Required Formals
<pre>
⟨normalFormalParameter⟩ ::=
    ⟨metadata⟩ ⟨normalFormalParameterNoMetadata⟩

⟨normalFormalParameterNoMetadata⟩ ::=
    ⟨functionFormalParameter⟩
  | ⟨fieldFormalParameter⟩
  | ⟨simpleFormalParameter⟩

⟨functionFormalParameter⟩ ::=
    <b>covariant</b>? ⟨type⟩? ⟨identifier⟩ ⟨formalParameterPart⟩ ‘?’?

⟨simpleFormalParameter⟩ ::=
    ⟨declaredIdentifier⟩
  | <b>covariant</b>? ⟨identifier⟩

⟨declaredIdentifier⟩ ::=
    <b>covariant</b>? ⟨finalConstVarOrType⟩ ⟨identifier⟩

⟨fieldFormalParameter⟩ ::=
    ⟨finalConstVarOrType⟩? <b>this</b> ‘.’ ⟨identifier⟩ (⟨formalParameterPart⟩ ‘?’?)?
</pre>

### Optional Formals
<pre>
⟨defaultFormalParameter⟩ ::=
    ⟨normalFormalParameter⟩ (‘=’ ⟨expression⟩)?

⟨defaultNamedParameter⟩ ::=
    ⟨metadata⟩ <b>required</b>? ⟨normalFormalParameterNoMetadata⟩ ((‘=’ | ‘:’) ⟨expression⟩)?
</pre>

# Classes
<pre>
⟨classDeclaration⟩ ::=
    <b>abstract</b>? <b>class</b> ⟨typeIdentifier⟩ ⟨typeParameters⟩? ⟨superclass⟩? ⟨interfaces⟩? ‘{’ (⟨metadata⟩ ⟨classMemberDeclaration⟩)* ‘}’
  | <b>abstract</b>? <b>class</b> ⟨mixinApplicationClass⟩

⟨typeNotVoidList⟩ ::=
    ⟨typeNotVoid⟩ (‘,’ ⟨typeNotVoid⟩)*

⟨classMemberDeclaration⟩ ::=
    ⟨declaration⟩ ‘;’
  | ⟨methodSignature⟩ ⟨functionBody⟩

⟨methodSignature⟩ ::=
    ⟨constructorSignature⟩ ⟨initializers⟩?
  | ⟨factoryConstructorSignature⟩
  | <b>static</b>? ⟨functionSignature⟩
  | <b>static</b>? ⟨getterSignature⟩
  | <b>static</b>? ⟨setterSignature⟩
  | ⟨operatorSignature⟩

⟨declaration⟩ ::=
    <b>external</b> ⟨factoryConstructorSignature⟩
  | <b>external</b> ⟨constantConstructorSignature⟩
  | <b>external</b> ⟨constructorSignature⟩
  | (<b>external</b> <b>static</b>?)? ⟨getterSignature⟩
  | (<b>external</b> <b>static</b>?)? ⟨setterSignature⟩
  | (<b>external</b> <b>static</b>?)? ⟨functionSignature⟩
  | <b>external</b>? ⟨operatorSignature⟩
  | <b>static</b> <b>const</b> ⟨type⟩? ⟨staticFinalDeclarationList⟩
  | <b>static</b> <b>final</b> ⟨type⟩? ⟨staticFinalDeclarationList⟩
  | <b>static</b> <b>late</b> <b>final</b> ⟨type⟩? ⟨initializedIdentifierList⟩
  | <b>static</b> <b>late</b>? ⟨varOrType⟩ ⟨initializedIdentifierList⟩
  | <b>covariant</b> <b>late</b> <b>final</b> ⟨type⟩? ⟨identifierList⟩
  | <b>covariant</b> <b>late</b>? ⟨varOrType⟩ ⟨initializedIdentifierList⟩
  | <b>late</b>? <b>final</b> ⟨type⟩? ⟨initializedIdentifierList⟩
  | <b>late</b>? ⟨varOrType⟩ ⟨initializedIdentifierList⟩
  | ⟨redirectingFactoryConstructorSignature⟩
  | ⟨constantConstructorSignature⟩ (⟨redirection⟩ | ⟨initializers⟩)?
  | ⟨constructorSignature⟩ (⟨redirection⟩ | ⟨initializers⟩)?

⟨staticFinalDeclarationList⟩ ::=
    ⟨staticFinalDeclaration⟩ (‘,’ ⟨staticFinalDeclaration⟩)*

⟨staticFinalDeclaration⟩ ::=
    ⟨identifier⟩ ‘=’ ⟨expression⟩
</pre>

## Instance Methods

### Operators
<pre>
⟨operatorSignature⟩ ::=
    ⟨type⟩? <b>operator</b> ⟨operator⟩ ⟨formalParameterList⟩

⟨operator⟩ ::=
    ‘~’
  | ⟨binaryOperator⟩
  | ‘[]’
  | ‘[]=’

⟨binaryOperator⟩ ::=
    ⟨multiplicativeOperator⟩
  | ⟨additiveOperator⟩
  | ⟨shiftOperator⟩
  | ⟨relationalOperator⟩
  | ‘==’
  | ⟨bitwiseOperator⟩
</pre>

## Getters
<pre>
⟨getterSignature⟩ ::=
    ⟨type⟩? <b>get</b> ⟨identifier⟩
</pre>

## Setters
<pre>
⟨setterSignature⟩ ::=
    ⟨type⟩? <b>set</b> ⟨identifier⟩ ⟨formalParameterList⟩
</pre>

## Constructors

### Generative Constructors
<pre>
⟨constructorSignature⟩ ::=
    ⟨constructorName⟩ ⟨formalParameterList⟩

⟨constructorName⟩ ::=
    ⟨typeIdentifier⟩ (‘.’ ⟨identifier⟩)?
</pre>

#### Redirecting Generative Constructors
<pre>
⟨redirection⟩ ::=
    ‘:’ <b>this</b> (‘.’ ⟨identifier⟩)? ⟨arguments⟩
</pre>

#### Initializer Lists
<pre>
⟨initializers⟩ ::=
    ‘:’ ⟨initializerListEntry⟩ (‘,’ ⟨initializerListEntry⟩)*

⟨initializerListEntry⟩ ::=
    <b>super</b> ⟨arguments⟩
  | <b>super</b> ‘.’ ⟨identifier⟩ ⟨arguments⟩
  | ⟨fieldInitializer⟩
  | ⟨assertion⟩

⟨fieldInitializer⟩ ::=
    (<b>this</b> ‘.’)? ⟨identifier⟩ ‘=’ ⟨initializerExpression⟩

⟨initializerExpression⟩ ::=
    ⟨assignableExpression⟩ ⟨assignmentOperator⟩ ⟨expression⟩
  | ⟨conditionalExpression⟩
  | ⟨cascade⟩
  | ⟨throwExpression⟩
</pre>

### Factories
<pre>
⟨factoryConstructorSignature⟩ ::=
    <b>const</b>? <b>factory</b> ⟨constructorName⟩ ⟨formalParameterList⟩
</pre>

#### Redirecting Factory Constructors
<pre>
⟨redirectingFactoryConstructorSignature⟩ ::=
    <b>const</b>? <b>factory</b> ⟨constructorName⟩ ⟨formalParameterList⟩ ‘=’ ⟨constructorDesignation⟩

⟨constructorDesignation⟩ ::=
    ⟨typeIdentifier⟩
  | ⟨qualifiedName⟩
  | ⟨typeName⟩ ⟨typeArguments⟩ (‘.’ ⟨identifier⟩)?
</pre>

### Constant Constructors
<pre>
⟨constantConstructorSignature⟩ ::=
    <b>const</b> ⟨constructorName⟩ ⟨formalParameterList⟩
</pre>

## Superclasses
<pre>
⟨superclass⟩ ::=
    <b>extends</b> ⟨typeNotVoid⟩ ⟨mixins⟩?
  | ⟨mixins⟩

⟨mixins⟩ ::=
    <b>with</b> ⟨typeNotVoidList⟩
</pre>

## Superinterfaces
<pre>
⟨interfaces⟩ ::=
    <b>implements</b> ⟨typeNotVoidList⟩
</pre>

# Mixins

## Mixin Classes
<pre>
⟨mixinApplicationClass⟩ ::=
    ⟨identifier⟩ ⟨typeParameters⟩? ‘=’ ⟨mixinApplication⟩ ‘;’

⟨mixinApplication⟩ ::=
    ⟨typeNotVoid⟩ ⟨mixins⟩ ⟨interfaces⟩?
</pre>

## Mixin Declaration
<pre>
⟨mixinDeclaration⟩ ::=
    <b>mixin</b> ⟨typeIdentifier⟩ ⟨typeParameters⟩? (<b>on</b> ⟨typeNotVoidList⟩)? ⟨interfaces⟩? ‘{’ (⟨metadata⟩ ⟨classMemberDeclaration⟩)* ‘}’
</pre>

# Extensions
<pre>
⟨extensionDeclaration⟩ ::=
    <b>extension</b> ⟨typeIdentifierNotType⟩? ⟨typeParameters⟩? <b>on</b> ⟨type⟩ ‘{’ (⟨metadata⟩ ⟨classMemberDeclaration⟩)* ‘}’
</pre>

# Enums
<pre>
⟨enumType⟩ ::=
    <b>enum</b> ⟨identifier⟩ ‘{’ ⟨enumEntry⟩ (‘,’ ⟨enumEntry⟩)* (‘,’)? ‘}’

⟨enumEntry⟩ ::=
    ⟨metadata⟩ ⟨identifier⟩
</pre>

# Generics
<pre>
⟨typeParameter⟩ ::=
    ⟨metadata⟩ ⟨identifier⟩ (<b>extends</b> ⟨typeNotVoid⟩)?

⟨typeParameters⟩ ::=
    ‘<’ ⟨typeParameter⟩ (‘,’ ⟨typeParameter⟩)* ‘>’
</pre>

# Metadata
<pre>
⟨metadata⟩ ::=
    (‘@’ ⟨metadatum⟩)*

⟨metadatum⟩ ::=
    ⟨identifier⟩
  | ⟨qualifiedName⟩
  | ⟨constructorDesignation⟩ ⟨arguments⟩
</pre>

# Expressions
<pre>
⟨expression⟩ ::=
    ⟨assignableExpression⟩ ⟨assignmentOperator⟩ ⟨expression⟩
  | ⟨conditionalExpression⟩
  | ⟨cascade⟩
  | ⟨throwExpression⟩

⟨expressionWithoutCascade⟩ ::=
    ⟨assignableExpression⟩ ⟨assignmentOperator⟩ ⟨expressionWithoutCascade⟩
  | ⟨conditionalExpression⟩
  | ⟨throwExpressionWithoutCascade⟩

⟨expressionList⟩ ::=
    ⟨expression⟩ (‘,’ ⟨expression⟩)*

⟨primary⟩ ::=
    ⟨thisExpression⟩
  | <b>super</b> ⟨unconditionalAssignableSelector⟩
  | <b>super</b> ⟨argumentPart⟩
  | ⟨functionExpression⟩
  | ⟨literal⟩
  | ⟨identifier⟩
  | ⟨newExpression⟩
  | ⟨constObjectExpression⟩
  | ⟨constructorInvocation⟩
  | ‘(’ ⟨expression⟩ ‘)’

⟨literal⟩ ::=
    ⟨nullLiteral⟩
  | ⟨booleanLiteral⟩
  | ⟨numericLiteral⟩
  | ⟨stringLiteral⟩
  | ⟨symbolLiteral⟩
  | ⟨listLiteral⟩
  | ⟨setOrMapLiteral⟩
</pre>

## Null
<pre>
⟨nullLiteral⟩ ::=
    <b>null</b>
</pre>

## Numbers
<pre>
⟨numericLiteral⟩ ::=
    ⟨NUMBER⟩
  | ⟨HEX_NUMBER⟩

⟨NUMBER⟩ ::=
    ⟨DIGIT⟩+ (‘.’ ⟨DIGIT⟩+)? ⟨EXPONENT⟩?
  | ‘.’ ⟨DIGIT⟩+ ⟨EXPONENT⟩?

⟨EXPONENT⟩ ::=
    (‘e’ | ‘E’) (‘+’ | ‘-’)? ⟨DIGIT⟩+

⟨HEX_NUMBER⟩ ::=
    ‘0x’ ⟨HEX_DIGIT⟩+
  | ‘0X’ ⟨HEX_DIGIT⟩+

⟨HEX_DIGIT⟩ ::=
    ‘a’ .. ‘f’
  | ‘A’ .. ‘F’
  | ⟨DIGIT⟩
</pre>

## Booleans
<pre>
⟨booleanLiteral⟩ ::=
    <b>true</b>
  | <b>false</b>
</pre>

## Strings
<pre>
⟨stringLiteral⟩ ::=
    (⟨multilineString⟩ | ⟨singleLineString⟩)+

⟨singleLineString⟩ ::=
    ⟨RAW_SINGLE_LINE_STRING⟩
  | ⟨SINGLE_LINE_STRING_SQ_BEGIN_END⟩
  | ⟨SINGLE_LINE_STRING_SQ_BEGIN_MID⟩ ⟨expression⟩ (⟨SINGLE_LINE_STRING_SQ_MID_MID⟩ ⟨expression⟩)* ⟨SINGLE_LINE_STRING_SQ_MID_END⟩
  | ⟨SINGLE_LINE_STRING_DQ_BEGIN_END⟩
  | ⟨SINGLE_LINE_STRING_DQ_BEGIN_MID⟩ ⟨expression⟩ (⟨SINGLE_LINE_STRING_DQ_MID_MID⟩ ⟨expression⟩)* ⟨SINGLE_LINE_STRING_DQ_MID_END⟩

⟨RAW_SINGLE_LINE_STRING⟩ ::=
    ‘r’ ‘'’ (~(‘'’ | ‘\r’ | ‘\n’))* ‘'’
  | ‘r’ ‘"’ (~(‘"’ | ‘\r’ | ‘\n’))* ‘"’

⟨STRING_CONTENT_COMMON⟩ ::=
    ~(‘\’ | ‘'’ | ‘"’ | ‘$’ | ‘\r’ | ‘\n’)
  | ⟨ESCAPE_SEQUENCE⟩
  | ‘\’ ~(‘n’ | ‘r’ | ‘b’ | ‘t’ | ‘v’ | ‘x’ | ‘u’ | ‘\r’ | ‘\n’)
  | ⟨SIMPLE_STRING_INTERPOLATION⟩

⟨STRING_CONTENT_SQ⟩ ::=
    ⟨STRING_CONTENT_COMMON⟩
  | ‘"’

⟨SINGLE_LINE_STRING_SQ_BEGIN_END⟩ ::=
    ‘'’ ⟨STRING_CONTENT_SQ⟩* ‘'’

⟨SINGLE_LINE_STRING_SQ_BEGIN_MID⟩ ::=
    ‘'’ ⟨STRING_CONTENT_SQ⟩* ‘${’

⟨SINGLE_LINE_STRING_SQ_MID_MID⟩ ::=
    ‘}’ ⟨STRING_CONTENT_SQ⟩* ‘${’

⟨SINGLE_LINE_STRING_SQ_MID_END⟩ ::=
    ‘}’ ⟨STRING_CONTENT_SQ⟩* ‘'’

⟨STRING_CONTENT_DQ⟩ ::=
    ⟨STRING_CONTENT_COMMON⟩
  | ‘'’

⟨SINGLE_LINE_STRING_DQ_BEGIN_END⟩ ::=
    ‘"’ ⟨STRING_CONTENT_DQ⟩* ‘"’

⟨SINGLE_LINE_STRING_DQ_BEGIN_MID⟩ ::=
    ‘"’ ⟨STRING_CONTENT_DQ⟩* ‘${’

⟨SINGLE_LINE_STRING_DQ_MID_MID⟩ ::=
    ‘}’ ⟨STRING_CONTENT_DQ⟩* ‘${’

⟨SINGLE_LINE_STRING_DQ_MID_END⟩ ::=
    ‘}’ ⟨STRING_CONTENT_DQ⟩* ‘"’

⟨multilineString⟩ ::=
    ⟨RAW_MULTI_LINE_STRING⟩
  | ⟨MULTI_LINE_STRING_SQ_BEGIN_END⟩
  | ⟨MULTI_LINE_STRING_SQ_BEGIN_MID⟩ ⟨expression⟩ (⟨MULTI_LINE_STRING_SQ_MID_MID⟩ ⟨expression⟩)* ⟨MULTI_LINE_STRING_SQ_MID_END⟩
  | ⟨MULTI_LINE_STRING_DQ_BEGIN_END⟩
  | ⟨MULTI_LINE_STRING_DQ_BEGIN_MID⟩ ⟨expression⟩ (⟨MULTI_LINE_STRING_DQ_MID_MID⟩ ⟨expression⟩)* ⟨MULTI_LINE_STRING_DQ_MID_END⟩

⟨RAW_MULTI_LINE_STRING⟩ ::=
    ‘r’ ‘'''’ .*? ‘'''’
  | ‘r’ ‘"""’ .*? ‘"""’

⟨QUOTES_SQ⟩ ::= | ‘'’ | ‘''’

⟨STRING_CONTENT_TSQ⟩ ::=
    ⟨QUOTES_SQ⟩ (⟨STRING_CONTENT_COMMON⟩ | ‘"’ | ‘\r’ | ‘\n’)

⟨MULTI_LINE_STRING_SQ_BEGIN_END⟩ ::=
    ‘'''’ ⟨STRING_CONTENT_TSQ⟩* ‘'''’

⟨MULTI_LINE_STRING_SQ_BEGIN_MID⟩ ::=
    ‘'''’ ⟨STRING_CONTENT_TSQ⟩* ⟨QUOTES_SQ⟩ ‘${’

⟨MULTI_LINE_STRING_SQ_MID_MID⟩ ::=
    ‘}’ ⟨STRING_CONTENT_TSQ⟩* ⟨QUOTES_SQ⟩ ‘${’

⟨MULTI_LINE_STRING_SQ_MID_END⟩ ::=
    ‘}’ ⟨STRING_CONTENT_TSQ⟩* ‘'''’

⟨QUOTES_DQ⟩ ::= | ‘"’ | ‘""’

⟨STRING_CONTENT_TDQ⟩ ::=
    ⟨QUOTES_DQ⟩ (⟨STRING_CONTENT_COMMON⟩ | ‘'’ | ‘\r’ | ‘\n’)

⟨MULTI_LINE_STRING_DQ_BEGIN_END⟩ ::=
    ‘"""’ ⟨STRING_CONTENT_TDQ⟩* ‘"""’

⟨MULTI_LINE_STRING_DQ_BEGIN_MID⟩ ::=
    ‘"""’ ⟨STRING_CONTENT_TDQ⟩* ⟨QUOTES_DQ⟩ ‘${’

⟨MULTI_LINE_STRING_DQ_MID_MID⟩ ::=
    ‘}’ ⟨STRING_CONTENT_TDQ⟩* ⟨QUOTES_DQ⟩ ‘${’

⟨MULTI_LINE_STRING_DQ_MID_END⟩ ::=
    ‘}’ ⟨STRING_CONTENT_TDQ⟩* ‘"""’

⟨ESCAPE_SEQUENCE⟩ ::=
    ‘\n’
  | ‘\r’
  | ‘\f’
  | ‘\b’
  | ‘\t’
  | ‘\v’
  | ‘\x’ ⟨HEX_DIGIT⟩ ⟨HEX_DIGIT⟩
  | ‘\u’ ⟨HEX_DIGIT⟩ ⟨HEX_DIGIT⟩ ⟨HEX_DIGIT⟩ ⟨HEX_DIGIT⟩
  | ‘\u{’ ⟨HEX_DIGIT_SEQUENCE⟩ ‘}’

⟨HEX_DIGIT_SEQUENCE⟩ ::=
    ⟨HEX_DIGIT⟩ ⟨HEX_DIGIT⟩? ⟨HEX_DIGIT⟩? ⟨HEX_DIGIT⟩? ⟨HEX_DIGIT⟩? ⟨HEX_DIGIT⟩?

⟨LINE_BREAK⟩ ::=
    ‘\n’
  | ‘\r\n’
  | ‘\r’
</pre>

### String Interpolation
<pre>
⟨stringInterpolation⟩ ::=
    ⟨SIMPLE_STRING_INTERPOLATION⟩
  | ‘${’ ⟨expression⟩ ‘}’

⟨SIMPLE_STRING_INTERPOLATION⟩ ::=
    ‘$’ (⟨IDENTIFIER_NO_DOLLAR⟩ | ⟨BUILT_IN_IDENTIFIER⟩ | <b>this</b>)
</pre>

## Symbols
<pre>
⟨symbolLiteral⟩ ::=
    ‘#’ (⟨identifier⟩ (‘.’ ⟨identifier⟩)* | ⟨operator⟩ | <b>void</b>)
</pre>

## Collection Literals
<pre>
⟨listLiteral⟩ ::=
    <b>const</b>? ⟨typeArguments⟩? ‘[’ ⟨elements⟩? ‘]’

⟨setOrMapLiteral⟩ ::=
    <b>const</b>? ⟨typeArguments⟩? ‘{’ ⟨elements⟩? ‘}’

⟨elements⟩ ::=
    ⟨element⟩ (‘,’ ⟨element⟩)* ‘,’?

⟨element⟩ ::=
    ⟨expressionElement⟩
  | ⟨mapElement⟩
  | ⟨spreadElement⟩
  | ⟨ifElement⟩
  | ⟨forElement⟩

⟨expressionElement⟩ ::=
    ⟨expression⟩

⟨mapElement⟩ ::=
    ⟨expression⟩ ‘:’ ⟨expression⟩

⟨spreadElement⟩ ::=
    (‘...’ | ‘...?’) ⟨expression⟩

⟨ifElement⟩ ::=
    <b>if</b> ‘(’ ⟨expression⟩ ‘)’ ⟨element⟩ (<b>else</b> ⟨element⟩)?

⟨forElement⟩ ::=
    <b>await</b>? <b>for</b> ‘(’ ⟨forLoopParts⟩ ‘)’ ⟨element⟩
</pre>

## Throw
<pre>
⟨throwExpression⟩ ::=
    <b>throw</b> ⟨expression⟩

⟨throwExpressionWithoutCascade⟩ ::=
    <b>throw</b> ⟨expressionWithoutCascade⟩
</pre>

## Function Expressions
<pre>
⟨functionExpression⟩ ::=
    ⟨formalParameterPart⟩ ⟨functionExpressionBody⟩

⟨functionExpressionBody⟩ ::=
    <b>async</b>? ‘=>’ ⟨expression⟩
  | (<b>async</b> ‘*’? | <b>sync</b> ‘*’)? ⟨block⟩
</pre>

## This
<pre>
⟨thisExpression⟩ ::=
    <b>this</b>
</pre>

## Instance Creation

### New
<pre>
⟨newExpression⟩ ::=
    <b>new</b> ⟨constructorDesignation⟩ ⟨arguments⟩
</pre>

### Const
<pre>
⟨constObjectExpression⟩ ::=
    <b>const</b> ⟨constructorDesignation⟩ ⟨arguments⟩
</pre>

## Function Invocation

### Actual Argument Lists
<pre>
⟨arguments⟩ ::=
    ‘(’ (⟨argumentList⟩ ‘,’?)? ‘)’

⟨argumentList⟩ ::=
    ⟨namedArgument⟩ (‘,’ ⟨namedArgument⟩)*
  | ⟨expressionList⟩ (‘,’ ⟨namedArgument⟩)*

⟨namedArgument⟩ ::=
    ⟨label⟩ ⟨expression⟩
</pre>

## Method Invocation

### Cascades
<pre>
⟨cascade⟩ ::=
    ⟨cascade⟩ ‘..’ ⟨cascadeSection⟩
  | ⟨conditionalExpression⟩ (‘?..’ | ‘..’) ⟨cascadeSection⟩

⟨cascadeSection⟩ ::=
    ⟨cascadeSelector⟩ ⟨cascadeSectionTail⟩

⟨cascadeSelector⟩ ::=
    ‘[’ ⟨expression⟩ ‘]’
  | ⟨identifier⟩

⟨cascadeSectionTail⟩ ::=
    ⟨cascadeAssignment⟩
  | ⟨selector⟩* (⟨assignableSelector⟩ ⟨cascadeAssignment⟩)?

⟨cascadeAssignment⟩ ::=
    ⟨assignmentOperator⟩ ⟨expressionWithoutCascade⟩
</pre>

## Assignment
<pre>
⟨assignmentOperator⟩ ::=
    ‘=’
  | ⟨compoundAssignmentOperator⟩

⟨compoundAssignmentOperator⟩ ::=
    ‘*=’
  | ‘/=’
  | ‘~/=’
  | ‘%=’
  | ‘+=’
  | ‘-=’
  | ‘<<=’
  | ‘>>>=’
  | ‘>>=’
  | ‘&=’
  | ‘^=’
  | ‘|=’
  | ‘??=’
</pre>

## Conditional
<pre>
⟨conditionalExpression⟩ ::=
    ⟨ifNullExpression⟩ (‘?’ ⟨expressionWithoutCascade⟩ ‘:’ ⟨expressionWithoutCascade⟩)?
</pre>

## If-null Expressions
<pre>
⟨ifNullExpression⟩ ::=
    ⟨logicalOrExpression⟩ (‘??’ ⟨logicalOrExpression⟩)*
</pre>

## Logical Boolean Expressions
<pre>
⟨logicalOrExpression⟩ ::=
    ⟨logicalAndExpression⟩ (‘||’ ⟨logicalAndExpression⟩)*

⟨logicalAndExpression⟩ ::=
    ⟨equalityExpression⟩ (‘&&’ ⟨equalityExpression⟩)*
</pre>

## Equality
<pre>
⟨equalityExpression⟩ ::=
    ⟨relationalExpression⟩ (⟨equalityOperator⟩ ⟨relationalExpression⟩)?
  | <b>super</b> ⟨equalityOperator⟩ ⟨relationalExpression⟩

⟨equalityOperator⟩ ::=
    ‘==’
  | ‘!=’
</pre>

## Relational Expressions
<pre>
⟨relationalExpression⟩ ::=
    ⟨bitwiseOrExpression⟩ (⟨typeTest⟩ | ⟨typeCast⟩ | ⟨relationalOperator⟩ ⟨bitwiseOrExpression⟩)?
  | <b>super</b> ⟨relationalOperator⟩ ⟨bitwiseOrExpression⟩

⟨relationalOperator⟩ ::=
    ‘>=’
  | ‘>’
  | ‘<=’
  | ‘<’
</pre>

## Bitwise Expressions
<pre>
⟨bitwiseOrExpression⟩ ::=
    ⟨bitwiseXorExpression⟩ (‘|’ ⟨bitwiseXorExpression⟩)*
  | <b>super</b> (‘|’ ⟨bitwiseXorExpression⟩)+

⟨bitwiseXorExpression⟩ ::=
    ⟨bitwiseAndExpression⟩ (‘^’ ⟨bitwiseAndExpression⟩)*
  | <b>super</b> (‘^’ ⟨bitwiseAndExpression⟩)+

⟨bitwiseAndExpression⟩ ::=
    ⟨shiftExpression⟩ (‘&’ ⟨shiftExpression⟩)*
  | <b>super</b> (‘&’ ⟨shiftExpression⟩)+

⟨bitwiseOperator⟩ ::=
    ‘&’
  | ‘^’
  | ‘|’
</pre>

## Shift
<pre>
⟨shiftExpression⟩ ::=
    ⟨additiveExpression⟩ (⟨shiftOperator⟩ ⟨additiveExpression⟩)*
  | <b>super</b> (⟨shiftOperator⟩ ⟨additiveExpression⟩)+

⟨shiftOperator⟩ ::=
    ‘<<’
  | ‘>>>’
  | ‘>>’
</pre>

## Additive Expressions
<pre>
⟨additiveExpression⟩ ::=
    ⟨multiplicativeExpression⟩ (⟨additiveOperator⟩ ⟨multiplicativeExpression⟩)*
  | <b>super</b> (⟨additiveOperator⟩ ⟨multiplicativeExpression⟩)+

⟨additiveOperator⟩ ::=
    ‘+’
  | ‘-’
</pre>

## Multiplicative Expressions
<pre>
⟨multiplicativeExpression⟩ ::=
    ⟨unaryExpression⟩ (⟨multiplicativeOperator⟩ ⟨unaryExpression⟩)*
  | <b>super</b> (⟨multiplicativeOperator⟩ ⟨unaryExpression⟩)+

⟨multiplicativeOperator⟩ ::=
    ‘*’
  | ‘/’
  | ‘%’
  | ‘~/’
</pre>

## Unary Expressions
<pre>
⟨unaryExpression⟩ ::=
    ⟨prefixOperator⟩ ⟨unaryExpression⟩
  | ⟨awaitExpression⟩
  | ⟨postfixExpression⟩
  | (⟨minusOperator⟩ | ⟨tildeOperator⟩) <b>super</b>
  | ⟨incrementOperator⟩ ⟨assignableExpression⟩

⟨prefixOperator⟩ ::=
    ⟨minusOperator⟩
  | ⟨negationOperator⟩
  | ⟨tildeOperator⟩

⟨minusOperator⟩ ::=
    ‘-’

⟨negationOperator⟩ ::=
    ‘!’

⟨tildeOperator⟩ ::=
    ‘~’
</pre>

## Await Expressions
<pre>
⟨awaitExpression⟩ ::=
    <b>await</b> ⟨unaryExpression⟩
</pre>

## Postfix Expressions
<pre>
⟨postfixExpression⟩ ::=
    ⟨assignableExpression⟩ ⟨postfixOperator⟩
  | ⟨primary⟩ ⟨selector⟩*

⟨postfixOperator⟩ ::=
    ⟨incrementOperator⟩

⟨constructorInvocation⟩ ::=
    ⟨typeName⟩ ⟨typeArguments⟩ ‘.’ ⟨identifier⟩ ⟨arguments⟩

⟨selector⟩ ::=
    ‘!’
  | ⟨assignableSelector⟩
  | ⟨argumentPart⟩

⟨argumentPart⟩ ::=
    ⟨typeArguments⟩? ⟨arguments⟩

⟨incrementOperator⟩ ::=
    ‘++’
  | ‘--’
</pre>

## Assignable Expressions
<pre>
⟨assignableExpression⟩ ::=
    ⟨primary⟩ ⟨assignableSelectorPart⟩
  | <b>super</b> ⟨unconditionalAssignableSelector⟩
  | ⟨identifier⟩

⟨assignableSelectorPart⟩ ::=
    ⟨selector⟩* ⟨assignableSelector⟩

⟨unconditionalAssignableSelector⟩ ::=
    ‘[’ ⟨expression⟩ ‘]’
  | ‘.’ ⟨identifier⟩

⟨assignableSelector⟩ ::=
    ⟨unconditionalAssignableSelector⟩
  | ‘?.’ ⟨identifier⟩
  | ‘?’ ‘[’ ⟨expression⟩ ‘]’

</pre>

## Identifier Reference
<pre>
⟨identifier⟩ ::=
    ⟨IDENTIFIER⟩
  | ⟨BUILT_IN_IDENTIFIER⟩
  | ⟨OTHER_IDENTIFIER⟩

⟨typeIdentifierNotType⟩ ::=
    ⟨IDENTIFIER⟩
  | ⟨OTHER_IDENTIFIER_NOT_TYPE⟩
  | <b>dynamic</b>

⟨typeIdentifier⟩ ::=
    ⟨typeIdentifierNotType⟩
  | <b>type</b>

⟨qualifiedName⟩ ::=
    ⟨typeIdentifier⟩ ‘.’ ⟨identifier⟩
  | ⟨typeIdentifier⟩ ‘.’ ⟨typeIdentifier⟩ ‘.’ ⟨identifier⟩

⟨BUILT_IN_IDENTIFIER⟩ ::=
    <b>abstract</b>
  | <b>as</b>
  | <b>covariant</b>
  | <b>deferred</b>
  | <b>dynamic</b>
  | <b>export</b>
  | <b>external</b>
  | <b>extension</b>
  | <b>factory</b>
  | <b>function</b>
  | <b>get</b>
  | <b>implements</b>
  | <b>import</b>
  | <b>interface</b>
  | <b>late</b>
  | <b>library</b>
  | <b>mixin</b>
  | <b>operator</b>
  | <b>part</b>
  | <b>required</b>
  | <b>set</b>
  | <b>static</b>
  | <b>typedef</b>

⟨OTHER_IDENTIFIER_NOT_TYPE⟩ ::=
    <b>async</b>
  | <b>hide</b>
  | <b>of</b>
  | <b>on</b>
  | <b>show</b>
  | <b>sync</b>
  | <b>await</b>
  | <b>yield</b>

⟨OTHER_IDENTIFIER⟩ ::=
    ⟨OTHER_IDENTIFIER_NOT_TYPE⟩
  | <b>type</b>

⟨IDENTIFIER_NO_DOLLAR⟩ ::=
    ⟨IDENTIFIER_START_NO_DOLLAR⟩ ⟨IDENTIFIER_PART_NO_DOLLAR⟩*

⟨IDENTIFIER_START_NO_DOLLAR⟩ ::=
    ⟨LETTER⟩
  | ‘_’

⟨IDENTIFIER_PART_NO_DOLLAR⟩ ::=
    ⟨IDENTIFIER_START_NO_DOLLAR⟩
  | ⟨DIGIT⟩

⟨IDENTIFIER⟩ ::=
    ⟨IDENTIFIER_START⟩ ⟨IDENTIFIER_PART⟩*

⟨IDENTIFIER_START⟩ ::=
    ⟨IDENTIFIER_START_NO_DOLLAR⟩
  | ‘$’

⟨IDENTIFIER_PART⟩ ::=
    ⟨IDENTIFIER_START⟩
  | ⟨DIGIT⟩

⟨LETTER⟩ ::=
    ‘a’ .. ‘z’
  | ‘A’ .. ‘Z’

⟨DIGIT⟩ ::=
    ‘0’ .. ‘9’

⟨WHITESPACE⟩ ::=
    (‘\t’ | ‘ ’ | ⟨LINE_BREAK⟩)+
</pre>

## Type Test
<pre>
⟨typeTest⟩ ::=
    ⟨isOperator⟩ ⟨typeNotVoid⟩

⟨isOperator⟩ ::=
    <b>is</b> ‘!’?
</pre>

## Type Cast
<pre>
⟨typeCast⟩ ::=
    ⟨asOperator⟩ ⟨typeNotVoid⟩

⟨asOperator⟩ ::=
    <b>as</b>
</pre>

# Statements
<pre>
⟨statements⟩ ::=
    ⟨statement⟩*

⟨statement⟩ ::=
    ⟨label⟩* ⟨nonLabelledStatement⟩

⟨nonLabelledStatement⟩ ::=
    ⟨block⟩
  | ⟨localVariableDeclaration⟩
  | ⟨forStatement⟩
  | ⟨whileStatement⟩
  | ⟨doStatement⟩
  | ⟨switchStatement⟩
  | ⟨ifStatement⟩
  | ⟨rethrowStatement⟩
  | ⟨tryStatement⟩
  | ⟨breakStatement⟩
  | ⟨continueStatement⟩
  | ⟨returnStatement⟩
  | ⟨yieldStatement⟩
  | ⟨yieldEachStatement⟩
  | ⟨expressionStatement⟩
  | ⟨assertStatement⟩
  | ⟨localFunctionDeclaration⟩
</pre>

## Expression Statements
<pre>
⟨expressionStatement⟩ ::=
    ⟨expression⟩? ‘;’
</pre>

## Local Variable Declaration
<pre>
⟨localVariableDeclaration⟩ ::=
    ⟨metadata⟩ ⟨initializedVariableDeclaration⟩ ‘;’
</pre>

## Local Function Declaration
<pre>
⟨localFunctionDeclaration⟩ ::=
    ⟨metadata⟩ ⟨functionSignature⟩ ⟨functionBody⟩
</pre>

## If
<pre>
⟨ifStatement⟩ ::=
    <b>if</b> ‘(’ ⟨expression⟩ ‘)’ ⟨statement⟩ (<b>else</b> ⟨statement⟩)?
</pre>

## For
<pre>
⟨forStatement⟩ ::=
    <b>await</b>? <b>for</b> ‘(’ ⟨forLoopParts⟩ ‘)’ ⟨statement⟩

⟨forLoopParts⟩ ::=
    ⟨forInitializerStatement⟩ ⟨expression⟩? ‘;’ ⟨expressionList⟩?
  | ⟨forInLoopPrefix⟩ <b>in</b> ⟨expression⟩

⟨forInLoopPrefix⟩ ::=
    ⟨metadata⟩ ⟨declaredIdentifier⟩
  | ⟨identifier⟩

⟨forInitializerStatement⟩ ::=
    ⟨localVariableDeclaration⟩
  | ⟨expression⟩? ‘;’
</pre>

## While
<pre>
⟨whileStatement⟩ ::=
    <b>while</b> ‘(’ ⟨expression⟩ ‘)’ ⟨statement⟩
</pre>

## Do
<pre>
⟨doStatement⟩ ::=
    <b>do</b> ⟨statement⟩ <b>while</b> ‘(’ ⟨expression⟩ ‘)’ ‘;’
</pre>

## Switch
<pre>
⟨switchStatement⟩ ::=
    <b>switch</b> ‘(’ ⟨expression⟩ ‘)’ ‘{’ ⟨switchCase⟩* ⟨defaultCase⟩? ‘}’

⟨switchCase⟩ ::=
    ⟨label⟩* <b>case</b> ⟨expression⟩ ‘:’ ⟨statements⟩

⟨defaultCase⟩ ::=
    ⟨label⟩* <b>default</b> ‘:’ ⟨statements⟩
</pre>

## Rethrow
<pre>
⟨rethrowStatement⟩ ::=
    <b>rethrow</b> ‘;’
</pre>

## Try
<pre>
⟨tryStatement⟩ ::=
    <b>try</b> ⟨block⟩ (⟨onPart⟩+ ⟨finallyPart⟩? | ⟨finallyPart⟩)

⟨onPart⟩ ::=
    ⟨catchPart⟩ ⟨block⟩
  | <b>on</b> ⟨typeNotVoid⟩ ⟨catchPart⟩? ⟨block⟩

⟨catchPart⟩ ::=
    <b>catch</b> ‘(’ ⟨identifier⟩ (‘,’ ⟨identifier⟩)? ‘)’

⟨finallyPart⟩ ::=
    <b>finally</b> ⟨block⟩
</pre>

## Return
<pre>
⟨returnStatement⟩ ::=
    <b>return</b> ⟨expression⟩? ‘;’
</pre>

## Labels
<pre>
⟨label⟩ ::=
    ⟨identifier⟩ ‘:’
</pre>

## Break
<pre>
⟨breakStatement⟩ ::=
    <b>break</b> ⟨identifier⟩? ‘;’
</pre>

## Continue
<pre>
⟨continueStatement⟩ ::=
    <b>continue</b> ⟨identifier⟩? ‘;’
</pre>

## Yield
<pre>
⟨yieldStatement⟩ ::=
    <b>yield</b> ⟨expression⟩ ‘;’
</pre>

## Yield-Each
<pre>
⟨yieldEachStatement⟩ ::=
    <b>yield</b> ‘*’ ⟨expression⟩ ‘;’
</pre>

## Assert
<pre>
⟨assertStatement⟩ ::=
    ⟨assertion⟩ ‘;’

⟨assertion⟩ ::=
    <b>assert</b> ‘(’ ⟨expression⟩ (‘,’ ⟨expression⟩ )? ‘,’? ‘)’
</pre>

# Libraries and Scripts
<pre>
⟨topLevelDeclaration⟩ ::=
    ⟨classDeclaration⟩
  | ⟨mixinDeclaration⟩
  | ⟨extensionDeclaration⟩
  | ⟨enumType⟩
  | ⟨typeAlias⟩
  | <b>external</b> ⟨functionSignature⟩ ‘;’
  | <b>external</b> ⟨getterSignature⟩ ‘;’
  | <b>external</b> ⟨setterSignature⟩ ‘;’
  | ⟨functionSignature⟩ ⟨functionBody⟩
  | ⟨getterSignature⟩ ⟨functionBody⟩
  | ⟨setterSignature⟩ ⟨functionBody⟩
  | (<b>final</b> | <b>const</b>) ⟨type⟩? ⟨staticFinalDeclarationList⟩ ‘;’
  | <b>late</b> <b>final</b> ⟨type⟩? ⟨initializedIdentifierList⟩ ‘;’
  | <b>late</b>? ⟨varOrType⟩ ⟨initializedIdentifierList⟩ ‘;’

⟨libraryDeclaration⟩ ::=
    ⟨scriptTag⟩? ⟨libraryName⟩? ⟨importOrExport⟩* ⟨partDirective⟩* (⟨metadata⟩ ⟨topLevelDeclaration⟩)* ⟨EOF⟩

⟨scriptTag⟩ ::=
    ‘#!’ (~(‘\r’ | ‘\n’))* ⟨LINE_BREAK⟩

⟨libraryName⟩ ::=
    ⟨metadata⟩ <b>library</b> ⟨dottedIdentifierList⟩ ‘;’

⟨importOrExport⟩ ::=
    ⟨libraryImport⟩
  | ⟨libraryExport⟩

⟨dottedIdentifierList⟩ ::=
    ⟨identifier⟩ (‘.’ ⟨identifier⟩)*
</pre>

## Imports
<pre>
⟨libraryImport⟩ ::=
    ⟨metadata⟩ ⟨importSpecification⟩

⟨importSpecification⟩ ::=
    <b>import</b> ⟨configurableUri⟩ (<b>deferred</b>? <b>as</b> ⟨typeIdentifier⟩)? ⟨combinator⟩* ‘;’
</pre>

## Exports
<pre>
⟨libraryExport⟩ ::=
    ⟨metadata⟩ <b>export</b> ⟨configurableUri⟩ ⟨combinator⟩* ‘;’
</pre>

## Namespace Combinators
<pre>
⟨combinator⟩ ::=
    <b>show</b> ⟨identifierList⟩
  | <b>hide</b> ⟨identifierList⟩

⟨identifierList⟩ ::=
    ⟨identifier⟩ (‘,’ ⟨identifier⟩)*
</pre>

## Parts
<pre>
⟨partDirective⟩ ::=
    ⟨metadata⟩ <b>part</b> ⟨uri⟩ ‘;’

⟨partHeader⟩ ::=
    ⟨metadata⟩ <b>part</b> <b>of</b> (⟨dottedIdentifierList⟩ | ⟨uri⟩) ‘;’

⟨partDeclaration⟩ ::=
    ⟨partHeader⟩ (⟨metadata⟩ ⟨topLevelDeclaration⟩)* ⟨EOF⟩
</pre>

## URIs
<pre>
⟨uri⟩ ::=
    ⟨stringLiteral⟩

⟨configurableUri⟩ ::=
    ⟨uri⟩ ⟨configurationUri⟩*

⟨configurationUri⟩ ::=
    <b>if</b> ‘(’ ⟨uriTest⟩ ‘)’ ⟨uri⟩

⟨uriTest⟩ ::=
    ⟨dottedIdentifierList⟩ (‘==’ ⟨stringLiteral⟩)?
</pre>

# Types

## Static Types
<pre>

⟨type⟩ ::=
    ⟨functionType⟩ ‘?’?
  | ⟨typeNotFunction⟩

⟨typeNotVoid⟩ ::=
    ⟨functionType⟩ ‘?’?
  | ⟨typeNotVoidNotFunction⟩ ‘?’?

⟨typeNotFunction⟩ ::=
    <b>void</b>
  | ⟨typeNotVoidNotFunction⟩ ‘?’?

⟨typeNotVoidNotFunction⟩ ::=
    ⟨typeName⟩ ⟨typeArguments⟩?
  | (⟨typeIdentifier⟩ '.')? <b>function</b>

⟨typeName⟩ ::=
    ⟨typeIdentifier⟩ (‘.’ ⟨typeIdentifier⟩)?

⟨typeArguments⟩ ::=
    ‘<’ ⟨typeList⟩ ‘>’

⟨typeList⟩ ::=
    ⟨type⟩ (‘,’ ⟨type⟩)*

⟨typeNotVoidNotFunctionList⟩ ::=
    ⟨typeNotVoidNotFunction⟩ (‘,’ ⟨typeNotVoidNotFunction⟩)*

⟨functionType⟩ ::=
    ⟨functionTypeTails⟩
  | ⟨typeNotFunction⟩ ⟨functionTypeTails⟩

⟨functionTypeTails⟩ ::=
    ⟨functionTypeTail⟩ ‘?’? ⟨functionTypeTails⟩
  | ⟨functionTypeTail⟩

⟨functionTypeTail⟩ ::=
    <b>function</b> ⟨typeParameters⟩? ⟨parameterTypeList⟩

⟨parameterTypeList⟩ ::=
    ‘(’ ‘)’
  | ‘(’ ⟨normalParameterTypes⟩ ‘,’ ⟨optionalParameterTypes⟩ ‘)’
  | ‘(’ ⟨normalParameterTypes⟩ ‘,’? ‘)’
  | ‘(’ ⟨optionalParameterTypes⟩ ‘)’

⟨normalParameterTypes⟩ ::=
    ⟨normalParameterType⟩ (‘,’ ⟨normalParameterType⟩)*

⟨normalParameterType⟩ ::=
    ⟨metadata⟩ ⟨typedIdentifier⟩
  | ⟨metadata⟩ ⟨type⟩

⟨optionalParameterTypes⟩ ::=
    ⟨optionalPositionalParameterTypes⟩
  | ⟨namedParameterTypes⟩

⟨optionalPositionalParameterTypes⟩ ::=
    ‘[’ ⟨normalParameterTypes⟩ ‘,’? ‘]’

⟨namedParameterTypes⟩ ::=
    ‘{’ ⟨namedParameterType⟩ (‘,’ ⟨namedParameterType⟩)* ‘,’? ‘}’

⟨namedParameterType⟩ ::=
    ⟨metadata⟩ <b>required</b>? ⟨typedIdentifier⟩

⟨typedIdentifier⟩ ::=
    ⟨type⟩ ⟨identifier⟩
</pre>

## Type Aliases
<pre>
⟨typeAlias⟩ ::=
    <b>typedef</b> ⟨typeIdentifier⟩ ⟨typeParameters⟩? ‘=’ ⟨type⟩ ‘;’
  | <b>typedef</b> ⟨functionTypeAlias⟩

⟨functionTypeAlias⟩ ::=
    ⟨functionPrefix⟩ ⟨formalParameterPart⟩ ‘;’

⟨functionPrefix⟩ ::=
    ⟨type⟩? ⟨identifier⟩
</pre>

# Reference

## Lexical Rules

### Reserved Words
<pre>
⟨RESERVED_WORD⟩ ::=
    <b>assert</b>
  | <b>break</b>
  | <b>case</b>
  | <b>catch</b>
  | <b>class</b>
  | <b>const</b>
  | <b>continue</b>
  | <b>default</b>
  | <b>do</b>
  | <b>else</b>
  | <b>enum</b>
  | <b>extends</b>
  | <b>false</b>
  | <b>final</b>
  | <b>finally</b>
  | <b>for</b>
  | <b>if</b>
  | <b>in</b>
  | <b>is</b>
  | <b>new</b>
  | <b>null</b>
  | <b>rethrow</b>
  | <b>return</b>
  | <b>super</b>
  | <b>switch</b>
  | <b>this</b>
  | <b>throw</b>
  | <b>true</b>
  | <b>try</b>
  | <b>var</b>
  | <b>void</b>
  | <b>while</b>
  | <b>with</b>
</pre>

### Comments
<pre>
⟨SINGLE_LINE_COMMENT⟩ ::=
    ‘//’ ~(⟨LINE_BREAK⟩)* (⟨LINE_BREAK⟩)?

⟨MULTI_LINE_COMMENT⟩ ::=
    ‘/*’ (⟨MULTI_LINE_COMMENT⟩ | ~ ‘*/’)* ‘*/’
</pre>
