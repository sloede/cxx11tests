// Check if alias templates are supported
#include <string>

template <class T, int size>
struct MyContainer { T data[size]; };

template <int N>
using MyStringContainer = MyContainer<std::string, N>;
