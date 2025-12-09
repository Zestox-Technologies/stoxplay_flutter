import 'dart:async';

class CountdownBloc {
  final StreamController<Duration> _countdownController =
  StreamController<Duration>();
  Stream<Duration> get countdownStream => _countdownController.stream;

  Timer? _timer;

  void start(Duration countdownDuration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownDuration = countdownDuration - const Duration(seconds: 1);
      _countdownController.sink.add(countdownDuration);
      if (countdownDuration.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _countdownController.close();
  }
}