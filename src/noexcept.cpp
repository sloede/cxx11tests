// Check if noexcept is supported
void f() noexcept;

void g() noexcept(true);

void h() noexcept(false);

template <typename T>
void x() noexcept(sizeof(T) == 4);
