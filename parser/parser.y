    /* Tokens, accessible in Parser::parser::token */

%token Identifier Constant String SizeOf Ellipsis
%token StructDeref Inc Dec ShiftLeft ShiftRight LowerEqual GreaterEqual
%token Equal NotEqual And Or MulAssign DivAssign ModAssign AddAssign SubAssign
%token LeftShiftAssign RightShiftAssign AndAssign XorAssign OrAssign
%token Struct Enum Typedef Union Char Short Int Long Float Double Void
%token Unsigned Signed Static Const Register Restrict Extern Volatile Auto
%token If Else While Do For Break Continue Goto Return Switch Case Default 

    /* access lexer functions */

%{
    int yylex(void *, ...);
    extern int yylex();
%}

    /* Yacc options, generate a C++ Parser */

%skeleton "lalr1.cc"
%define "namespace" "Parser"

%start translation_unit

%%

primary_expression
    : Identifier
    | Constant
    | String
    | '(' expression ')'
    ;

postfix_expression
    : primary_expression
    | postfix_expression '[' expression ']'
    | postfix_expression '(' ')'
    | postfix_expression '(' argument_expression_list ')'
    | postfix_expression '.' Identifier
    | postfix_expression StructDeref Identifier
    | postfix_expression Inc
    | postfix_expression Dec
    ;

argument_expression_list
    : assignment_expression
    | argument_expression_list ',' assignment_expression
    ;

unary_expression
    : postfix_expression
    | Inc unary_expression
    | Dec unary_expression
    | unary_operator cast_expression
    | SizeOf unary_expression
    | SizeOf '(' type_name ')'
    ;

unary_operator
    : '&'
    | '*'
    | '+'
    | '-'
    | '~'
    | '!'
    ;

cast_expression
    : unary_expression
    | '(' type_name ')' cast_expression
    ;

multiplicative_expression
    : cast_expression
    | multiplicative_expression '*' cast_expression
    | multiplicative_expression '/' cast_expression
    | multiplicative_expression '%' cast_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression
    | additive_expression '-' multiplicative_expression
    ;

shift_expression
    : additive_expression
    | shift_expression ShiftLeft additive_expression
    | shift_expression ShiftRight additive_expression
    ;

relational_expression
    : shift_expression
    | relational_expression '<' shift_expression
    | relational_expression '>' shift_expression
    | relational_expression LowerEqual shift_expression
    | relational_expression GreaterEqual shift_expression
    ;

equality_expression
    : relational_expression
    | equality_expression Equal relational_expression
    | equality_expression NotEqual relational_expression
    ;

and_expression
    : equality_expression
    | and_expression '&' equality_expression
    ;

exclusive_or_expression
    : and_expression
    | exclusive_or_expression '^' and_expression
    ;

inclusive_or_expression
    : exclusive_or_expression
    | inclusive_or_expression '|' exclusive_or_expression
    ;

logical_and_expression
    : inclusive_or_expression
    | logical_and_expression And inclusive_or_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression Or logical_and_expression
    ;

conditional_expression
    : logical_or_expression
    | logical_or_expression '?' expression ':' conditional_expression
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression
    ;

assignment_operator
    : '='
    | MulAssign
    | DivAssign
    | ModAssign
    | AddAssign
    | SubAssign
    | LeftShiftAssign
    | RightShiftAssign
    | AndAssign
    | XorAssign
    | OrAssign
    ;

expression
    : assignment_expression
    | expression ',' assignment_expression
    ;

constant_expression
    : conditional_expression
    ;

declaration
    : declaration_specifiers ';'
    | declaration_specifiers init_declarator_list ';'
    ;

declaration_specifiers
    : storage_class_specifier
    | storage_class_specifier declaration_specifiers
    | type_specifier
    | type_specifier declaration_specifiers
    | type_qualifier
    | type_qualifier declaration_specifiers
    ;

init_declarator_list
    : init_declarator
    | init_declarator_list ',' init_declarator
    ;

init_declarator
    : declarator
    | declarator '=' initializer
    ;

storage_class_specifier
    : Typedef
    | Extern
    | Static
    | Auto
    | Register
    ;

type_specifier
    : Void
    | Char
    | Short
    | Int
    | Long
    | Float
    | Double
    | Signed
    | Unsigned
    | struct_or_union_specifier
    | enum_specifier
    ;

struct_or_union_specifier
    : struct_or_union Identifier '{' struct_declaration_list '}'
    | struct_or_union '{' struct_declaration_list '}'
    | struct_or_union Identifier
    ;

struct_or_union
    : Struct
    | Union
    ;

struct_declaration_list
    : struct_declaration
    | struct_declaration_list struct_declaration
    ;

struct_declaration
    : specifier_qualifier_list struct_declarator_list ';'
    ;

specifier_qualifier_list
    : type_specifier specifier_qualifier_list
    | type_specifier
    | type_qualifier specifier_qualifier_list
    | type_qualifier
    ;

struct_declarator_list
    : struct_declarator
    | struct_declarator_list ',' struct_declarator
    ;

struct_declarator
    : declarator
    | ':' constant_expression
    | declarator ':' constant_expression
    ;

enum_specifier
    : Enum '{' enumerator_list '}'
    | Enum Identifier '{' enumerator_list '}'
    | Enum Identifier
    ;

enumerator_list
    : enumerator
    | enumerator_list ',' enumerator
    ;

enumerator
    : Identifier
    | Identifier '=' constant_expression
    ;

type_qualifier
    : Const
    | Volatile
    ;

declarator
    : pointer direct_declarator
    | direct_declarator
    ;

direct_declarator
    : Identifier
    | '(' declarator ')'
    | direct_declarator '[' constant_expression ']'
    | direct_declarator '[' ']'
    | direct_declarator '(' parameter_type_list ')'
    | direct_declarator '(' identifier_list ')'
    | direct_declarator '(' ')'
    ;

pointer
    : '*'
    | '*' type_qualifier_list
    | '*' pointer
    | '*' type_qualifier_list pointer
    ;

type_qualifier_list
    : type_qualifier
    | type_qualifier_list type_qualifier
    ;


parameter_type_list
    : parameter_list
    | parameter_list ',' Ellipsis
    ;

parameter_list
    : parameter_declaration
    | parameter_list ',' parameter_declaration
    ;

parameter_declaration
    : declaration_specifiers declarator
    | declaration_specifiers abstract_declarator
    | declaration_specifiers
    ;

identifier_list
    : Identifier
    | identifier_list ',' Identifier
    ;

type_name
    : specifier_qualifier_list
    | specifier_qualifier_list abstract_declarator
    ;

abstract_declarator
    : pointer
    | direct_abstract_declarator
    | pointer direct_abstract_declarator
    ;

direct_abstract_declarator
    : '(' abstract_declarator ')'
    | '[' ']'
    | '[' constant_expression ']'
    | direct_abstract_declarator '[' ']'
    | direct_abstract_declarator '[' constant_expression ']'
    | '(' ')'
    | '(' parameter_type_list ')'
    | direct_abstract_declarator '(' ')'
    | direct_abstract_declarator '(' parameter_type_list ')'
    ;

initializer
    : assignment_expression
    | '{' initializer_list '}'
    | '{' initializer_list ',' '}'
    ;

initializer_list
    : initializer
    | initializer_list ',' initializer
    ;

statement
    : labeled_statement
    | compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;

labeled_statement
    : Identifier ':' statement
    | Case constant_expression ':' statement
    | Default ':' statement
    ;

compound_statement
    : '{' '}'
    | '{' statement_list '}'
    | '{' declaration_list '}'
    | '{' declaration_list statement_list '}'
    ;

declaration_list
    : declaration
    | declaration_list declaration
    ;

statement_list
    : statement
    | statement_list statement
    ;

expression_statement
    : ';'
    | expression ';'
    ;

selection_statement
    : If '(' expression ')' statement
    | If '(' expression ')' statement Else statement
    | Switch '(' expression ')' statement
    ;

iteration_statement
    : While '(' expression ')' statement
    | Do statement While '(' expression ')' ';'
    | For '(' expression_statement expression_statement ')' statement
    | For '(' expression_statement expression_statement expression ')' statement
    ;

jump_statement
    : Goto Identifier ';'
    | Continue ';'
    | Break ';'
    | Return ';'
    | Return expression ';'
    ;

translation_unit
    : external_declaration
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement
    | declaration_specifiers declarator compound_statement
    | declarator declaration_list compound_statement
    | declarator compound_statement
    {
        printf("Found a function\n");
    }
    ;

%%

/*
 * For some strange reason, the parser can't find yylex when linking to the 
 * lexer. yylex(void *) is called by parse(). This is a workaround using C++
 * polymorphism to ensure the good yylex() is called.
 * Since we don't use llval, this hasn't much importance, but one could find 
 * a clean way to do this anyway...
 */
int yylex(void *llval, ...)
{
    return yylex();
}

void Parser::parser::error(Parser::location const &, std::string const &) { }
