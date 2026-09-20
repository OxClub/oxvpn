import 'package:flutter_riverpod/flutter_riverpod.dart';

final logStoreProvider = StateNotifierProvider<LogStore, List<String>>((_) => LogStore());

class LogStore extends StateNotifier<List<String>> {
  LogStore() : super(<String>[]);

  void add(String msg) {
    final ts = DateTime.now().toIso8601String().substring(11, 19);
    state = [...state, '[$ts] $msg'];
    if (state.length > 200) {
      state = state.sublist(state.length - 200);
    }
  }

  void clear() => state = [];
}
