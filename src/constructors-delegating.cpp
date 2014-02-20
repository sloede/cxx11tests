// Check if delegating constructors are supported
class Test {
  Test() : Test(5) {}
  Test(int d) : data(d) {}
  int data;
};
