#include <string>
#include <sstream>

#include <tree.hpp>

bool Compiler::Type::matchTypes(Compiler::Type const &, Compiler::Type const &)
{
    return true;
}

Compiler::Type::operator std::string() const
{
    std::stringstream s;

    if(type == None)
        return "None";

    if(flags & Auto)
        s << "auto ";
    
    if(flags & Extern)
        s << "extern ";

    if(flags & Register)
        s << "register ";

    if(flags & Static)
        s << "static "; 

    if(flags & Signed)
        s << "signed ";

    if(flags & Unsigned)
        s << "unsigned ";

    switch(type)
    {
        case Void:
            s << "void";
            break;

        case Char:
            s << "char";
            break;

        case Short:
            s << "short";
            break;

        case Int:
            s << "int";
            break;

        case Long:
            s << "long";
            break;

        case Float:
            s << "float";
            break;

        case Double:
            s << "double";
            break;

        default:
            break;
    }

    return s.str();
}

Compiler::Type Compiler::AbstractSyntaxTree::exprType() const
{
    /* 
     * FIXME: by default something that is not an expression as no type
     * This method is useless and should only be defined in AbstractExpression
     * but in order to do polymorphism with subclasses we have to add a 
     * virtual method to AbstractSyntaxTree
     */
    Compiler::Type ret;

    ret.type = Compiler::Type::None;
    ret.flags = Compiler::Type::Any;

    return ret;
}
