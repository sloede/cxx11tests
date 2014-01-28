// Check if delete'd member functions are supported
class Test {
  public:
    Test(const Test& t) = delete;

  private:
    int data;
};
