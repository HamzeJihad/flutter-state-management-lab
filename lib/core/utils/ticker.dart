class Ticker {
  Stream<int> tick() => Stream.periodic(const Duration(seconds: 1), (i) => i + 1);
}
