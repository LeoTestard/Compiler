#include <list>

#include <tree.hpp>

namespace Compiler
{
    class DeclarationSpecifiers;
    class Initializer;
    class Identifier;

    /*
     * Represents the declarator of a single symbol. The symbol can be a 
     * primary identifier, a pointer, an array or a function.
     */
    class Declarator : public AbstractSyntaxTree
    {
    public:

        /*
         * abstract method to generate code that performs code generation
         * for the declaration of the symbol.
         * Implementation differs following the symbol type
         */
    //    virtual void compile(Initializer const &expr, DeclarationSpecifiers
    //           const &specs, SymbolTable &t) const = 0;
    };

    class IdDeclarator : public Declarator
    {
    public:
        IdDeclarator(std::shared_ptr<Identifier> const id);
        
        std::shared_ptr<Identifier> const id;
    };

    class InitDeclarator : public AbstractSyntaxTree
    {
    public:
        std::shared_ptr<Declarator> const decl;
        std::shared_ptr<Initializer> const expr;

        InitDeclarator(decltype(decl) d, decltype(expr) e);
    };
    
    class DeclaratorList : public AbstractSyntaxTree
    {
    public:
        std::list<std::shared_ptr<InitDeclarator>> list;
    };
}

