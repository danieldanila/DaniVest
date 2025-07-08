class SessionCounterManager {
  static final SessionCounterManager _instance =
      SessionCounterManager._internal();
  factory SessionCounterManager() => _instance;
  SessionCounterManager._internal();

  static final Map<String, int> _counters = {};

  static int increment(String name) {
    _counters[name] = (_counters[name] ?? 0) + 1;
    return _counters[name]!;
  }

  static int get(String name) {
    return _counters[name] ?? 0;
  }

  static void reset(String name) {
    _counters[name] = 0;
  }

  static void resetAll() {
    _counters.clear();
  }
}
