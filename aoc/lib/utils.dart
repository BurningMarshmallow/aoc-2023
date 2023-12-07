extension StringExtensions on String {
  Iterable<String> splitNotEmpty() {
    return split(' ').where((x) => x.isNotEmpty);
  }

  int compareToByChar(String other, int Function(String char) selector) {
    if (length != other.length) {
      throw UnsupportedError("Strings should be same length");
    }

    for (var i = 0; i < length; i++) {
      if (selector(this[i]) < selector(other[i])) {
        return -1;
      }
      if (selector(this[i]) > selector(other[i])) {
        return 1;
      }
    }
    return 0;
  }
}
