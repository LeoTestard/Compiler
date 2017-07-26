#include <string>

#include <identifier.hpp>
#include <errors.hpp>

using std::shared_ptr;
using Compiler::CompileError;

Compiler::Identifier::Identifier(std::string const &name) : m_name(name)
{
    type.type = Compiler::Type::None;
    type.flags = Compiler::Type::Any;
}

void Compiler::Identifier::compile(Compiler::Program &) const
{
    /* read from memory and put on stack */
}

Compiler::Type Compiler::Identifier::exprType() const
{
    return type;
}

shared_ptr<Compiler::Constant const> Compiler::Identifier::evalConstant() const
{
    throw CompileError(CompileError::Severity::Error, "Expression not constant");
}

void Compiler::Identifier::setType(Compiler::Type type)
{
    this->type = type;
}

std::string const &Compiler::Identifier::name() const
{
    return m_name;
}

bool Compiler::Identifier::operator<(Compiler::Identifier const &other) const
{
    return m_name.compare(other.name()) < 0;
}
