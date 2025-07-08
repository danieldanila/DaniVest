import 'package:shared_preferences/shared_preferences.dart';

class SessionTracker {
  static const String _sessionCountKey = 'session_count';

  static Future<int> incrementSessionCount() async {
    final prefs = await SharedPreferences.getInstance();

    int currentCount = prefs.getInt(_sessionCountKey) ?? 0;
    int newCount = currentCount + 1;

    await prefs.setInt(_sessionCountKey, newCount);

    return newCount;
  }

  static Future<int> getSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionCountKey) ?? 0;
  }
}
