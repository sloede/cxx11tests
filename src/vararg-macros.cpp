// Check if macros with variable argument length are supported
// Example from http://www.stroustrup.com/C++11FAQ.html
#define report(test, ...) ((test)?puts(#test):printf(_ _VA_ARGS_ _))
