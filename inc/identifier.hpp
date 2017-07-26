#include <tree.hpp>
#include <expressions.hpp>

namespace Compiler
{
    class Identifier : public PrimaryExpression
    {
        std::string const m_name;
        Type type;

    public:
        explicit Identifier(std::string const &name);

        virtual void compile(Program &t) const;
        virtual Type exprType() const;
        virtual std::shared_ptr<Constant const> evalConstant() const;

        void setType(Type type);

        std::string const &name() const;

        bool operator<(Identifier const &other) const;
    };
}

