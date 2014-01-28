// Check if the contextual keywords final and override are supported
class Base {
  virtual void f() {};
  virtual void g() final {};
};

class Derived : public Base {
  void f() override {};
};
