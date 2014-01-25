// Check if Unicode string literals are supported
#include <string>

std::basic_string<char16_t> s1(u"x");
std::basic_string<char32_t> s2(U"x");
