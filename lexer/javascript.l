INT         [0-9]+[uUlL]?
HEX         0[xX][a-fA-F0-9]+[uUlL]?
FLOAT       ([0-9]+\.|[0-9]*\.[0-9]+)([eE][+-]?[0-9]+)?[fFlL]?
DEC_FLOAT   [0-9]+([eE][+-]?[0-9]+)[fFlL]?
HEX_FLOAT   0[xX][a-fA-F0-9]*\.[a-fA-F0-9]*([pP][0-9]+)?[fFlL]?
INTCONST    ({INT}|{HEX})
FLTCONST    ({FLOAT}|{HEX_FLOAT}|{DEC_FLOAT})
STRING      L?\"(\\.|[^\\"])*\"
ID          [a-zA-Z_][a-zA-Z0-9_]*

    /* get token definitions from parser */

%{
    #include <fstream>
    #include <iostream>

    #include <parser.hpp>
    using namespace Parser;

    int lineNo = 0;
%}

%option noyywrap
%s IN_COMMENT INLINE_COMMENT

%%
    
<INITIAL>
{
        /* eat up comments */
        
    "/*"        BEGIN IN_COMMENT;
    "//"        BEGIN INLINE_COMMENT;

        /* Keywords */
    
    char        return parser::token::Char;
    short       return parser::token::Short;
    int         return parser::token::Int;
    long        return parser::token::Long;
    float       return parser::token::Float;
    double      return parser::token::Double;
    void        return parser::token::Void;
    unsigned    return parser::token::Unsigned;
    signed      return parser::token::Signed;
    static      return parser::token::Static;
    const       return parser::token::Const;
    register    return parser::token::Register;
    extern      return parser::token::Extern;
    volatile    return parser::token::Volatile;
    auto        return parser::token::Auto;
    struct      return parser::token::Struct;
    enum        return parser::token::Enum;
    typedef     return parser::token::Typedef;
    union       return parser::token::Union;
    if          return parser::token::If;
    else        return parser::token::Else;
    while       return parser::token::While;
    do          return parser::token::Do;
    for         return parser::token::For;
    break       return parser::token::Break;
    continue    return parser::token::Continue;
    goto        return parser::token::Goto;
    return      return parser::token::Return;
    switch      return parser::token::Switch;
    case        return parser::token::Case;
    default     return parser::token::Default;
    sizeof      return parser::token::SizeOf;
        
        /* constants, strings and IDs */

    {ID}        return parser::token::Identifier;
    {INTCONST}  return parser::token::IntConstant;
    {FLTCONST}  return parser::token::FloatConstant;
    {STRING}    return parser::token::String; 

        /* operators */

    "..."       return parser::token::Ellipsis;
    ">>="       return parser::token::RightShiftAssign;
    "<<="       return parser::token::LeftShiftAssign;
    "+="        return parser::token::AddAssign;
    "-="        return parser::token::SubAssign;
    "*="        return parser::token::MulAssign;
    "/="        return parser::token::DivAssign;
    "%="        return parser::token::ModAssign;
    "&="        return parser::token::AndAssign;
    "^="        return parser::token::XorAssign;
    "|="        return parser::token::OrAssign;
    ">>"        return parser::token::ShiftRight;
    "<<"        return parser::token::ShiftLeft;
    "+"         return '+';
    "-"         return '-';
    "*"         return '*';
    "/"         return '/';
    "%"         return '%';
    "&"         return '&';
    "^"         return '^';
    "|"         return '|';
    "++"        return parser::token::Inc;
    "--"        return parser::token::Dec;
    "=="        return parser::token::Equal;
    "<="        return parser::token::LowerEqual;
    ">="        return parser::token::GreaterEqual;
    "!="        return parser::token::NotEqual;
    "->"        return parser::token::StructDeref;
    "="         return '=';
    "<"         return '<';
    ">"         return '>';
    "!"         return '!';
    "."         return '.';
    "~"         return '~';
    "?"         return '?';
    "("         return '(';
    ")"         return ')';
    "["|"<:"    return '[';
    "]"|":>"    return ']';
    "{"|"<%"    return '{';
    "}"|"%>"    return '}';
    ";"         return ';';
    ":"         return ':';
    ","         return ',';

        /* spaces */

    [ \t\v\r\f] /* ignore */ ;
    \n          lineNo ++;

        /* unknown */

    .           /* error: stray "..." in program */ ;
}

<IN_COMMENT>
{
    "*/"        BEGIN INITIAL;
    \n          lineNo ++;
    [^*\n]      /* eat */ ;
    \*          /* eat */ ;
}

<INLINE_COMMENT>
{
    \n {
                lineNo ++;
                BEGIN INITIAL;
    }

    [^\n]       /* eat */ ;
}
