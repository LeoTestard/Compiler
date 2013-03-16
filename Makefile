TARGET = main
SRCS = $(TARGET).cpp

LEXER = lexer/lexer.o
PARSER = parser/parser.o

OBJS = $(SRCS:.cpp=.o)
CXXFLAGS = -Wall -Wextra -Wall
INCS = -Ilexer/ -Iparser/
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

