// Check if an implicit call to a non-initializer_list ctor is supported
class Point2D {
 public:
  Point2D(int x1, int x2) { x=x1; y=x2; }
  int x, y;
};

Point2D p{1, 2};
