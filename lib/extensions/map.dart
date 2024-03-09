extension DefaultMap<Key, Value> on Map<Key, Value> {
  Value? get(final Key key, [final Value? defaultValue]) {
    return containsKey(key) ? this[key] ?? defaultValue : defaultValue;
  }
}
