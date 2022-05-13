/// A function which works like enumerate in Python, this return an iterator map with the element index
/// @param [items] an iterable
/// @param [f] an anonymous function
/// @example
/// enumerate([1, 2, 3], (index, element) => { print("$elemenent at $index"); })
Iterable<E> enumerate<E, T>(Iterable<T> items, E Function(int index, T item) f) {
  var index = 0;
  return items.map((item) {
    final result = f(index, item);
    index = index + 1;
    return result;
  });
}

/// A constant regex to validate emails
final EMAIL_REGEX = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)$");

/// An enumerator which allow differentiate form types
enum FORM_TYPE { SAVE, SET }