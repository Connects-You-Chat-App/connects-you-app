extension DefaultMap<Key, Value> on Map<Key, Value> {
  Value? get(Key key, [Value? defaultValue]) {
    return containsKey(key) ? this[key] ?? defaultValue : defaultValue;
  }
}
