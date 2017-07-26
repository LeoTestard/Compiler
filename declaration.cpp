#include <declaration.hpp>
#include <declarator.hpp>
#include <errors.hpp>
#include <initializer.hpp>
#include <constant.hpp>
#include <specifiers.hpp>
#include <program.hpp>
#include <identifier.hpp>

using std::shared_ptr;
using std::dynamic_pointer_cast;
using Compiler::CompileError;

void Compiler::FunctionDeclaration::compile(Compiler::Program &t) const
{
    auto fun = new Function(specs->exprType);

}

Compiler::Declaration::Declaration(shared_ptr<DeclarationSpecifiers> const s, 
        shared_ptr<DeclaratorList> const d) : specs(s), decls(d) { }

void Compiler::Declaration::compile(Compiler::Program &t) const
{
    if(global)
    {
        for(auto d : decls->list)
        {
            auto constant = d->expr->evalConstant();
            auto idec = dynamic_pointer_cast<IdDeclarator>(d->decl);

            if(!idec) // ??
                throw "";

            if(Type::matchTypes(constant->exprType(), specs->exprType()))
            {
                t.addGlobal(idec->id, constant);
                idec->id->setType(specs->exprType());
            }

            else
                throw CompileError(CompileError::Severity::Error,
                        std::string("invalid assignment of type ") 
                        + (std::string) constant->exprType()
                        + " to " + (std::string) specs->exprType());
        }
    }
}

void Compiler::Declaration::setGlobal(bool global)
{
    this->global = global;
}
