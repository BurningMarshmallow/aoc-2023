import 'dart:convert';
import 'dart:io';

int calculate() {
  return 6 * 7;
}

void solve() {
  solveInternal();
}

Future<void> solveInternal() async {
  final lines = utf8.decoder
      .bind(File("input.txt").openRead())
      .transform(const LineSplitter());
  await for (final line in lines) {
    stdout.writeln(line);
  }
}
