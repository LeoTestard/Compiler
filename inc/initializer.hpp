#ifndef INITIALIZER_7IZ5JSWG
#define INITIALIZER_7IZ5JSWG

#include <tree.hpp>

namespace Compiler
{
    class Constant;

    class Initializer : public AbstractExpression
    {
    public:
        virtual std::shared_ptr<Constant const> evalConstant() const = 0;
    };

    class InitializeList : public Initializer
    {
    };
}

#endif /* INITIALIZER_7IZ5JSWG */
