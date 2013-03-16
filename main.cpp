#include <iostream>
#include <fstream>

#include <lexer.hpp>
#include <parser.hpp>

int main(int argc, char *argv[])
{
    argc --;
    argv ++;

    yyin = argc ? fopen(argv[0], "r") : stdin;
    Parser::parser p;

    std::cout << p.parse() << std::endl;
}
