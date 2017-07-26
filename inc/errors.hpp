#include <exception>
#include <string>

namespace Compiler
{
    class CompileError : public std::exception
    {
    public:
        enum class Severity
        {
            Error,
            Warning,
            Note
        };

        CompileError(Severity s, std::string const &what) throw();
        virtual char const* what() const noexcept;

    private:
        std::string str;
        Severity s;
    };
}
