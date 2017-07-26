#ifndef TREE_JN7JODF8
#define TREE_JN7JODF8

#include <memory>

namespace Compiler
{
    class Identifier;
    class Program;

    struct Type
    {
        enum PrimitiveType
        {
            None = 0,
            Void,
            Char,
            Short,
            Int,
            Long,
            Float,
            Double,
            Typedef
        };
    
        enum TypeModifier
        {
            Any = 0x0,
            Auto = 0x1,
            Extern = 0x2,
            Register = 0x4,
            Signed = 0x8,
            Static = 0x10,
            Unsigned = 0x20
        };

        PrimitiveType type;
        TypeModifier flags; 

        static bool matchTypes(Type const &t1, Type const &t2);

        operator std::string() const;
    };

    class AbstractSyntaxTree
    {
    public:
        virtual Type exprType() const;
    };

    class CompilableExpression : public AbstractSyntaxTree
    {
    public:
        virtual void compile(Program &t) const = 0;
    };

    class AbstractExpression : public CompilableExpression
    {
    public:
        virtual Type exprType() const = 0;
    };
}

#endif /* TREE_JN7JODF8 */
