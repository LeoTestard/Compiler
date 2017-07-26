#ifndef DECLARATION_V8ODR9L9
#define DECLARATION_V8ODR9L9

#include <tree.hpp>

namespace Compiler
{
    class DeclarationSpecifiers;
    class DeclaratorList;
    class Declaration;
    class Program;

    class AbstractDeclaration : public CompilableExpression
    {
    };

    class FunctionDeclaration : public AbstractDeclaration
    {
    };

    class Declaration : public AbstractDeclaration
    {
        bool global = false;

        std::shared_ptr<DeclarationSpecifiers> const specs;
        std::shared_ptr<DeclaratorList> const decls;

    public:
        Declaration(decltype(specs) s, decltype(decls) d);

        virtual void compile(Program &t) const;
        void setGlobal(bool global);
    };
};

#endif /* DECLARATION_V8ODR9L9 */
