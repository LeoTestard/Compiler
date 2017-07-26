#ifndef PROGRAM_39BY75NC
#define PROGRAM_39BY75NC

#include <memory>
#include <map>

namespace Compiler
{
    class Identifier;
    class Constant;

    /*
     * An intermediate representation of the program
     */
    class Program
    {
        std::map<std::shared_ptr<Identifier>, std::shared_ptr<Constant const>>
            globals;

    public:
        void addGlobal(std::shared_ptr<Identifier> id, 
                std::shared_ptr<Constant const> value);

        void writeProgram() const;
    };
}

#endif /* PROGRAM_39BY75NC */
