extension StringExt on String {
  String camelCase() {
    final words = _intoWords(this)
        .map((w) =>
            '${w.substring(0, 1).toUpperCase()}${w.substring(1).toLowerCase()}')
        .toList();
    words[0] = words[0].toLowerCase();
    return words.join();
  }
}

List<String> _intoWords(String path) {
  const symbols = [
    ' ',
    '.',
    '/',
    '_',
    '\\',
    '-',
    '@',
  ];
  final upperAlphaRegex = RegExp(r'[A-Z]');
  final lowerAlphaRegex = RegExp(r'[a-z]');
  final buffer = StringBuffer();
  final words = <String>[];

  for (var i = 0; i < path.length; i++) {
    final char = String.fromCharCode(path.codeUnitAt(i));
    final nextChar = i + 1 == path.length
        ? null
        : String.fromCharCode(path.codeUnitAt(i + 1));

    if (symbols.contains(char)) {
      continue;
    }

    buffer.write(char);

    final isEndOfWord = nextChar == null ||
        (upperAlphaRegex.hasMatch(nextChar) &&
            path.contains(lowerAlphaRegex)) ||
        symbols.contains(nextChar);

    if (isEndOfWord) {
      words.add(buffer.toString());
      buffer.clear();
    }
  }

  return words;
}