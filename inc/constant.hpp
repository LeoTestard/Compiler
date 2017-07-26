#ifndef CONSTANT_8V6GPCMA
#define CONSTANT_8V6GPCMA

#include <expressions.hpp>

namespace Compiler
{
    class Constant : public UnaryExpression
    {
    public:
        virtual Type exprType() const = 0;
        virtual void compile(Program &t) const = 0;
        virtual std::shared_ptr<Constant const> evalConstant() const = 0;

        virtual operator std::string() const = 0;
    };

    class IntConstant : public Constant
    {
        long long value;

    public:
        IntConstant(std::string const &str);

        virtual Type exprType() const;
        virtual void compile(Program &t) const;
        virtual std::shared_ptr<Constant const> evalConstant() const;

        operator std::string() const;
    };
}

#endif /* CONSTANT_8V6GPCMA */
