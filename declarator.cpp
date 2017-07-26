#include <declarator.hpp>

using std::shared_ptr;

Compiler::IdDeclarator::IdDeclarator(shared_ptr<Identifier> const id) : id(id)
{
}

Compiler::InitDeclarator::InitDeclarator(shared_ptr<Declarator> const d,
        shared_ptr<Initializer> const e) : decl(d), expr(e) { }
