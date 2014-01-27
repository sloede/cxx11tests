// Check if lambda expressions may be stored as function pointers
int (* fptr)(int, int) = [](int a, int b) { return a + b; };
