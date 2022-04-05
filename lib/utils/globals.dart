Iterable<E> enumerate<E, T>(Iterable<T> items, E Function(int index, T item) f) {
  var index = 0;
  return items.map((item) {
    final result = f(index, item);
    index = index + 1;
    return result;
  });
}

final EMAIL_REGEX = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)$");

enum FORM_TYPE { SAVE, SET }