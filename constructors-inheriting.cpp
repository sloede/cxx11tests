// Check if inheriting constructors are supported
class Base {
  public:
    explicit Base(int d) : data(d) {}
    int data;
};

class Derived : public Base {
  public:
    using Base::Base;
};

Derived d(5);
