#ifndef EXPRESSIONS_P8DAIDJU
#define EXPRESSIONS_P8DAIDJU

#include <initializer.hpp>

namespace Compiler
{
    class AssignmentExpression : public Initializer
    {
    };

    class ConditionalExpression : public AssignmentExpression
    {
    };

    class LogicalOrExpression : public ConditionalExpression
    {
    };

    class LogicalAndExpression : public LogicalOrExpression
    {
    };

    class OrExpression : public LogicalAndExpression
    {
    };

    class XorExpression : public OrExpression
    {
    };

    class AndExpression : public XorExpression
    {
    };

    class EqualityExpression : public AndExpression
    {
    };

    class RelationalExpression : public EqualityExpression
    {
    };

    class ShiftExpression : public RelationalExpression
    {
    };

    class AdditiveExpression : public ShiftExpression
    {
    };

    class MultiplicativeExpression : public AdditiveExpression
    {
    };

    class CastExpression : public MultiplicativeExpression
    {
    };

    class UnaryExpression : public CastExpression
    {
    };

    class PostfixExpression : public UnaryExpression
    {
    };

    class PrimaryExpression : public PostfixExpression
    {
    };
}

#endif /* EXPRESSIONS_P8DAIDJU */
