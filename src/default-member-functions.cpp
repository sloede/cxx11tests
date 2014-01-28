// Check if default'd member functions are supported
class Test {
  public:
    Test() = default;
    Test(const Test& t) { data = t.data; }

  private:
    int data;
};
