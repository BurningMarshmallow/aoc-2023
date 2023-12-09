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

Iterable<List<int>> neighbours8(List<int> pos, int n, int m) sync* {
  for (var dx in [-1, 0, 1]) {
    for (var dy in [-1, 0, 1]) {
      if (dx == 0 && dy == 0) {
        continue;
      }
      if (pos[0] + dx < 0 || pos[0] + dx >= n) {
        continue;
      }
      if (pos[1] + dy < 0 || pos[1] + dy >= m) {
        continue;
      }

      yield [pos[0] + dx, pos[1] + dy];
    }
  }
}

Iterable<List<int>> neighbours4(List<int> pos, int n, int m) sync* {
  for (var dx in [-1, 0, 1]) {
    for (var dy in [-1, 0, 1]) {
      if (dx == 0 && dy == 0) {
        continue;
      }
      if (dx != 0 && dy != 0) {
        continue;
      }
      if (pos[0] + dx < 0 || pos[0] + dx >= n) {
        continue;
      }
      if (pos[1] + dy < 0 || pos[1] + dy >= m) {
        continue;
      }

      yield [pos[0] + dx, pos[1] + dy];
    }
  }
}
