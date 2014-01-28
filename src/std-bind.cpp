// Check if binding functions is possible
#include <functional>

int fun(int a, int b) { return a + b; }

std::function<int(int)> f = std::bind(fun, 10, std::placeholders::_1);
