SRC = parser.y
C_SRC = $(SRC:.y=.cpp)
C_HDR = $(SRC:.y=.hpp)
TARGET = $(C_SRC:.cpp=.o)

CXXFLAGS = -std=c++11 -Wall -Wextra -Werror
INCS = -I../inc

all: $(TARGET)

$(TARGET): $(C_SRC)
	$(CXX) $(CXXFLAGS) $(INCS) -c $^ -o $@

$(C_SRC): $(SRC)
	$(YACC) $(YFLAGS) -d -o $@ $^

clean:
	rm -rf $(TARGET) $(C_SRC) $(C_HDR) *.hh
