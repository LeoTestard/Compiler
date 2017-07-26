#include <string>
#include <constant.hpp>

using std::shared_ptr;

Compiler::IntConstant::IntConstant(std::string const &str)
{
    auto base = 10;

    if(str.compare(0, 2, "0x"))
        base = 16;

    value = std::stoll(str, 0, base);
}

Compiler::Type Compiler::IntConstant::exprType() const
{
    Compiler::Type t;
    t.type = Compiler::Type::Int;
    t.flags = Compiler::Type::Any;

    return t;
}

void Compiler::IntConstant::compile(Compiler::Program &) const
{
}

shared_ptr<Compiler::Constant const> Compiler::IntConstant::evalConstant() const
{
    return shared_ptr<Constant const>(new IntConstant(*this));
}

Compiler::IntConstant::operator std::string() const
{
    return std::to_string(value);
}
