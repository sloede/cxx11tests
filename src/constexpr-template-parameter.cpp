// Check if a constexpr function may specify an non-type template parameter
constexpr int f(int a) { return 2 * a; }
template <int num>
struct MyContainer { int data[num]; };

MyContainer<f(2)> c;
