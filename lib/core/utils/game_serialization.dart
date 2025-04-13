Map<String, Set<int>> deserializeRevealed(String input) {
  final map = <String, Set<int>>{};
  if (input.isEmpty) return map;

  for (var entry in input.split(';')) {
    final parts = entry.split(':');
    if (parts.length != 2) continue;
    final word = parts[0];
    final indices =
        parts[1].split(',').where((e) => e.isNotEmpty).map(int.parse).toSet();
    map[word] = indices;
  }

  return map;
}

String serializeRevealed(Map<String, Set<int>> map) {
  return map.entries.map((e) => '${e.key}:${e.value.join(",")}').join(';');
}
