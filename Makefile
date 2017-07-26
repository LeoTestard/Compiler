TARGET = main
SRCS = $(TARGET).cpp declarator.cpp declaration.cpp specifiers.cpp tree.cpp identifier.cpp constant.cpp errors.cpp program.cpp

LEXER = lexer/lexer.o
PARSER = parser/parser.o

OBJS = $(SRCS:.cpp=.o)
CXXFLAGS = -std=c++11 -Wall -Wextra -Werror
INCS = -Ilexer/ -Iparser/ -Iinc/
LIBS = -lstdc++

all: $(TARGET)

$(TARGET): $(PARSER) $(LEXER) $(OBJS)
	$(CXX) $(LIBS) $(LDFLAGS) $^ -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCS) -c $^ -o $@

$(LEXER): 
	make -C lexer/

$(PARSER):
	make -C parser/

clean:
	make -C parser/ clean
	make -C lexer/ clean
	rm -rf $(TARGET) $(OBJS)

