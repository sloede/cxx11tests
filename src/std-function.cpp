// Check if we can store function pointers with std::function
#include <functional>

bool fun(int a, int b) { return a > b; }
std::function<bool(int, int)> myfun = fun;
