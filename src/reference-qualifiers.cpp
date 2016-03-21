// check if reference qualifiers for member functions are supported
// http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2439.htm
struct X
{
   void f() &;
   void f() &&;
};
