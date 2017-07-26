#include <program.hpp>
#include <errors.hpp>
#include <identifier.hpp>
#include <constant.hpp>
#include <iostream>

using std::shared_ptr;

void Compiler::Program::addGlobal(shared_ptr<Compiler::Identifier> id,
        shared_ptr<Compiler::Constant const> value)
{
    auto &c = globals[id];

    if(c)
    {
        throw CompileError(CompileError::Severity::Warning,
                std::string("Redifinition of symbol : ")
                + id->name());
    }

    c = value;
}

void Compiler::Program::writeProgram() const
{
    /* write globals */
    for(auto f : globals)
    {
        auto id = f.first;
        auto value = f.second;

        std::cout << "\tglobal _" << id->name() << std::endl;
        std::cout << "_" << id->name() << ":" << std::endl;

        switch(id->exprType().type)
        {
            case Type::Char:
                std::cout << "db\t";
                break;

            case Type::Short:
                std::cout << "dw\t";
                break;

            case Type::Int:
                std::cout << "dd\t";
                break;

            default:
                std::cout << "dd\t";
                break;
        }

        std::cout << (std::string) *value << std::endl; 
        std::cout << std::endl;
    }
}
