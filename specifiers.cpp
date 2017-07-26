#include <string>

#include <specifiers.hpp>
#include <errors.hpp>

using std::list;
using std::shared_ptr;
using Compiler::Type;
using Compiler::CompileError;

/* Implementation for Compiler::Speficier */

Compiler::Specifier::Specifier(Type::PrimitiveType t)
{
    type.type = t;
    type.flags = Type::Any;
}

Compiler::Specifier::Specifier(Type::TypeModifier t)
{
    type.type = Type::None;
    type.flags = t;
}

Type Compiler::Specifier::exprType() const
{
    return type;
}

/* Implementation for Compiler::DeclarationSpecifiers */

Compiler::DeclarationSpecifiers::DeclarationSpecifiers(
        shared_ptr<Compiler::Specifier> const &s)
{
    addSpecifier(s);
}

void Compiler::DeclarationSpecifiers::addSpecifier(
        shared_ptr<Compiler::Specifier> const &s)
{
    specs.push_front(s);
}

Type Compiler::DeclarationSpecifiers::exprType() const
{
    Type ret;

    ret.flags = Type::Any;
    ret.type = Type::None;

    for(auto s : specs)
    {
        auto t = s->exprType();

        if(t.type != Type::None)
        {
            if(ret.type != Type::None)
                throw CompileError(CompileError::Severity::Error,
                        "Error: two primitive types specified");

            ret.type = t.type;
        }
        
        ret.flags = (Type::TypeModifier) ((int) t.flags | (int) ret.flags);
    }

    /* no type is implicitly int */
    ret.type = ret.type == Type::None ? Type::Int : ret.type;

    return ret;
}

