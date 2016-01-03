.PHONY: all
all: 01_cpp_scope haskell

01_cpp_scope: 01_cpp_scope.cpp
	$(CXX) -std=c++11 -Wall -o $@ $^

.PHONY: haskell
haskell:
	cabal configure
	cabal build
