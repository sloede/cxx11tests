// Check if a static const variable can be initialized by a constexpr function
constexpr int f(int a) { return a * a; }

static const int i = f(7);
