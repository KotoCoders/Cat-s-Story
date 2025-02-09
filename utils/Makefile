INCLUDES := $(shell python3 -m pybind11 --includes)
all:
	c++ -O3 -Wall -shared -std=c++11 -fPIC $(INCLUDES) linager.cpp -o linear.so


