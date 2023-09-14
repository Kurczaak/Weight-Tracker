import 'dart:async';

class Debouncer {
  Debouncer(this.debounceTimeMs);

  Timer? _timer;

  final int debounceTimeMs;

  void debounce(void Function() action) {
    cancel();
    _timer = Timer(Duration(milliseconds: debounceTimeMs), action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
