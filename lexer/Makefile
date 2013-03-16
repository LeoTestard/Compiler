SRC = lexer.l
C_SRC = $(SRC:.l=.cpp)
C_HDR = $(SRC:.l=.hpp)
TARGET = $(C_SRC:.cpp=.o)
INCS = -I../parser/

all: $(TARGET)

$(TARGET): $(C_SRC)
	$(CXX) $(CXXFLAGS) $(INCS) -c $^ -o $@

$(C_SRC): $(SRC)
	$(LEX) $(LFLAGS) --header-file=$(C_HDR) -o $@ $^

clean:
	rm -rf $(TARGET) $(C_SRC) $(C_HDR)
