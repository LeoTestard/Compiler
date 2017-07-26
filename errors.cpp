#include <string>
#include <errors.hpp>

Compiler::CompileError::CompileError(Compiler::CompileError::Severity s, 
        std::string const &what) throw() : str(what), s(s) { }

char const* Compiler::CompileError::what() const noexcept
{
    return str.c_str();
}
