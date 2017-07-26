#include <iostream>
#include <fstream>

#include <lexer.hpp>
#include <parser.hpp>

int main(int argc, char *argv[])
{
    argc --;
    argv ++;

    yyin = argc ? fopen(argv[0], "r") : stdin;

    int ret;
    Parser::parser p;

    try
    {
        ret = p.parse();
    }

    catch(std::exception const &e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return ret;
}
