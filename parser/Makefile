SRC = parser.y
C_SRC = $(SRC:.y=.cpp)
C_HDR = $(SRC:.y=.hpp)
TARGET = $(C_SRC:.cpp=.o)

all: $(TARGET)

$(TARGET): $(C_SRC)
	$(CXX) $(CXXFLAGS) -c $^ -o $@

$(C_SRC): $(SRC)
	$(YACC) $(YFLAGS) -d -o $@ $^

clean:
	rm -rf $(TARGET) $(C_SRC) $(C_HDR) *.hh
