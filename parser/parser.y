    /* Tokens, accessible in Parser::parser::token */

%token Identifier IntConstant FloatConstant String SizeOf Ellipsis
%token StructDeref Inc Dec ShiftLeft ShiftRight LowerEqual GreaterEqual
%token Equal NotEqual And Or MulAssign DivAssign ModAssign AddAssign SubAssign
%token LeftShiftAssign RightShiftAssign AndAssign XorAssign OrAssign
%token Struct Enum Typedef Union Char Short Int Long Float Double Void
%token Unsigned Signed Static Const Register Restrict Extern Volatile Auto
%token If Else While Do For Break Continue Goto Return Switch Case Default

    /* access lexer functions */

%{
    #include <memory>

    #include <tree.hpp>
    #include <identifier.hpp>
    #include <constant.hpp>
    #include <specifiers.hpp>
    #include <declarator.hpp>
    #include <declaration.hpp>
    #include <program.hpp>

    using std::shared_ptr;
    using std::dynamic_pointer_cast;
    using namespace Compiler;

    int yylex(void *, ...);
    extern int yylex();
    extern char *yytext;

    #define YYSTYPE std::shared_ptr<AbstractSyntaxTree>
%}

    /* Yacc options, generate a C++ Parser */

%skeleton "lalr1.cc"
%define "namespace" "Parser"

%start translation_unit

%%

primary_expression
    : Identifier { $$ = shared_ptr<Identifier>(new Identifier(yytext)); }
    | IntConstant { $$ = shared_ptr<Constant>(new IntConstant(yytext)); }
    | FloatConstant
    | String
    | '(' expression ')'
    ;

postfix_expression
    : primary_expression { $$ = $1; }
    | postfix_expression '[' expression ']'
    | postfix_expression '(' ')'
    | postfix_expression '(' argument_expression_list ')'
    | postfix_expression '.' Identifier
    | postfix_expression StructDeref Identifier
    | postfix_expression Inc
    | postfix_expression Dec
    ;

unary_expression
    : postfix_expression { $$ = $1; }
    | Inc unary_expression
    | Dec unary_expression
    | unary_operator cast_expression
    | SizeOf unary_expression
    | SizeOf '(' type_name ')'
    ;

cast_expression
    : unary_expression { $$ = $1; }
    | '(' type_name ')' cast_expression
    ;

argument_expression_list
    : assignment_expression
    | argument_expression_list ',' assignment_expression
    ;

unary_operator
    : '&'
    | '*'
    | '+'
    | '-'
    | '~'
    | '!'
    ;

multiplicative_expression
    : cast_expression { $$ = $1; }
    | multiplicative_expression '*' cast_expression
    | multiplicative_expression '/' cast_expression
    | multiplicative_expression '%' cast_expression
    ;

additive_expression
    : multiplicative_expression { $$ = $1; }
    | additive_expression '+' multiplicative_expression
    | additive_expression '-' multiplicative_expression
    ;

shift_expression
    : additive_expression { $$ = $1; }
    | shift_expression ShiftLeft additive_expression
    | shift_expression ShiftRight additive_expression
    ;

relational_expression
    : shift_expression { $$ = $1; }
    | relational_expression '<' shift_expression
    | relational_expression '>' shift_expression
    | relational_expression LowerEqual shift_expression
    | relational_expression GreaterEqual shift_expression
    ;

equality_expression
    : relational_expression { $$ = $1; }
    | equality_expression Equal relational_expression
    | equality_expression NotEqual relational_expression
    ;

and_expression
    : equality_expression { $$ = $1; }
    | and_expression '&' equality_expression
    ;

exclusive_or_expression
    : and_expression { $$ = $1; }
    | exclusive_or_expression '^' and_expression
    ;

inclusive_or_expression
    : exclusive_or_expression { $$ = $1; }
    | inclusive_or_expression '|' exclusive_or_expression
    ;

logical_and_expression
    : inclusive_or_expression { $$ = $1; }
    | logical_and_expression And inclusive_or_expression
    ;

logical_or_expression
    : logical_and_expression { $$ = $1; }
    | logical_or_expression Or logical_and_expression
    ;

conditional_expression
    : logical_or_expression { $$ = $1; }
    | logical_or_expression '?' expression ':' conditional_expression
    ;

assignment_expression
    : conditional_expression { $$ = $1; }
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
    {
        auto s = std::dynamic_pointer_cast<DeclarationSpecifiers>($1);
        auto d = std::dynamic_pointer_cast<DeclaratorList>($2);

        auto dec = new Declaration(s, d);

        $$ = shared_ptr<Declaration>(dec);
    }
    ;

declaration_specifiers
    : storage_class_specifier
    {
        auto s = std::dynamic_pointer_cast<Specifier>($1);
        $$ = shared_ptr<DeclarationSpecifiers>(new DeclarationSpecifiers(s));
    }
    | storage_class_specifier declaration_specifiers
    {
        auto l = std::dynamic_pointer_cast<DeclarationSpecifiers>($2);
        l->addSpecifier(std::dynamic_pointer_cast<Specifier>($1));

        $$ = l;
    }
    | type_specifier
    {
        auto s = std::dynamic_pointer_cast<Specifier>($1);
        $$ = shared_ptr<DeclarationSpecifiers>(new DeclarationSpecifiers(s));
    }
    | type_specifier declaration_specifiers
    {
        auto l = std::dynamic_pointer_cast<DeclarationSpecifiers>($2);
        l->addSpecifier(std::dynamic_pointer_cast<Specifier>($1));

        $$ = l;
    }
    | type_qualifier
    {
        auto s = std::dynamic_pointer_cast<Specifier>($1);
        $$ = shared_ptr<DeclarationSpecifiers>(new DeclarationSpecifiers(s));
    }
    | type_qualifier declaration_specifiers
    {
        auto l = std::dynamic_pointer_cast<DeclarationSpecifiers>($2);
        l->addSpecifier(std::dynamic_pointer_cast<Specifier>($1));

        $$ = l;
    }
    ;

init_declarator_list
    : init_declarator
    {
        auto dec = dynamic_pointer_cast<InitDeclarator>($1);
        auto list = shared_ptr<DeclaratorList>(new DeclaratorList());
        list->list.push_front(dec);

        $$ = list;
    }
    | init_declarator_list ',' init_declarator
    {
        auto decl = std::dynamic_pointer_cast<InitDeclarator>($3);
        auto list = std::dynamic_pointer_cast<DeclaratorList>($1);
        list->list.push_front(decl);

        $$ = list;
    }
    ;

init_declarator
    : declarator { $$ = $1; }
    | declarator '=' initializer
    {
        auto init = dynamic_pointer_cast<Initializer>($3);
        auto dec = dynamic_pointer_cast<Declarator>($1);

        $$ = shared_ptr<InitDeclarator>(new InitDeclarator(dec, init));
    }
    ;

storage_class_specifier
    : Typedef  { $$ = shared_ptr<Specifier>(new Specifier(Type::Typedef)); }
    | Extern   { $$ = shared_ptr<Specifier>(new Specifier(Type::Extern));  }
    | Static   { $$ = shared_ptr<Specifier>(new Specifier(Type::Static));  }
    | Auto     { $$ = shared_ptr<Specifier>(new Specifier(Type::Auto));    }
    | Register { $$ = shared_ptr<Specifier>(new Specifier(Type::Register));}
    ;

type_specifier
    : Void     { $$ = shared_ptr<Specifier>(new Specifier(Type::Void));    }
    | Char     { $$ = shared_ptr<Specifier>(new Specifier(Type::Char));    }
    | Short    { $$ = shared_ptr<Specifier>(new Specifier(Type::Short));   }
    | Int      { $$ = shared_ptr<Specifier>(new Specifier(Type::Int));     }
    | Long     { $$ = shared_ptr<Specifier>(new Specifier(Type::Long));    }
    | Float    { $$ = shared_ptr<Specifier>(new Specifier(Type::Float));   }
    | Double   { $$ = shared_ptr<Specifier>(new Specifier(Type::Double));  }
    | Signed   { $$ = shared_ptr<Specifier>(new Specifier(Type::Signed));  }
    | Unsigned { $$ = shared_ptr<Specifier>(new Specifier(Type::Unsigned));}
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
    | direct_declarator { $$ = $1; }
    ;

direct_declarator
    : Identifier
    {
        auto id = shared_ptr<Identifier>(new Identifier(yytext));
        $$ = shared_ptr<IdDeclarator>(new IdDeclarator(id));
    }
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
    : assignment_expression { $$ = $1; }
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
    {
        Program t;
        auto dec = dynamic_pointer_cast<AbstractDeclaration>($1);
        dec->compile(t);

        t.writeProgram();
    }
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    {
        auto dec = dynamic_pointer_cast<Declaration>($1);
        dec->setGlobal(true);

        $$ = dec;
    }
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement
    | declaration_specifiers declarator compound_statement
    | declarator declaration_list compound_statement
    | declarator compound_statement
    {
        auto dec = dynamic_pointer_cast<Declarator>($1);
        auto bod = dynamic_pointer_cast<CompoundStatement>($2);
        auto ret = new FunctionDeclaration(dec, bod);

        $$ = shared_ptr<FunctionDeclaration>(ret);
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
int yylex(void *, ...)
{
    return yylex();
}

void Parser::parser::error(Parser::location const &, std::string const &) { }
