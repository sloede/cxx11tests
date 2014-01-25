// Check if uniform initialization is supported in initializer lists
class Dummy {
  Dummy() : data{1.0, 2.0, 3.0} {};
  const float data[3];
};
