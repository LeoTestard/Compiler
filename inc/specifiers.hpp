#include <list>

#include <tree.hpp>

namespace Compiler
{
    class Specifier : public AbstractSyntaxTree
    {
        Type type;

    public:
        explicit Specifier(Type::PrimitiveType t);
        explicit Specifier(Type::TypeModifier t);

        virtual Type exprType() const;
    };

    /*
     * Represents a list of declaration specifiers, which can be storage type
     * or type specifiers, applied to a declaration.
     */
    class DeclarationSpecifiers : public AbstractSyntaxTree
    {
        std::list<std::shared_ptr<Specifier>> specs;

    public:
        explicit DeclarationSpecifiers(std::shared_ptr<Specifier> const &s);
        void addSpecifier(std::shared_ptr<Specifier> const &s);

        /* Compute the type specified by the specifiers */
        virtual Type exprType() const;
    };
}
