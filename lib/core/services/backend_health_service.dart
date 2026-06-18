import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:polyglot_admin/core/config/app_config.dart';

enum BackendStatus { healthy, down }

class BackendHealth {
  const BackendHealth(this.status, [this.latencyMs]);
  final BackendStatus status;
  final int? latencyMs;
}

/// Pings the Parlo backend's `/health` endpoint and reports status + latency.
class BackendHealthService {
  BackendHealthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<BackendHealth> check() async {
    final sw = Stopwatch()..start();
    try {
      final res = await _client
          .get(Uri.parse('${AppConfig.backendBaseUrl}/health'))
          .timeout(const Duration(seconds: 5));
      sw.stop();
      return res.statusCode == 200
          ? BackendHealth(BackendStatus.healthy, sw.elapsedMilliseconds)
          : const BackendHealth(BackendStatus.down);
    } catch (_) {
      return const BackendHealth(BackendStatus.down);
    }
  }
}

final backendHealthServiceProvider = Provider<BackendHealthService>(
  (ref) => BackendHealthService(),
);

/// Polls backend health every 30s while watched (auto-disposes when the
/// dashboard is not visible).
final backendHealthProvider = StreamProvider.autoDispose<BackendHealth>((
  ref,
) async* {
  final service = ref.watch(backendHealthServiceProvider);
  while (true) {
    yield await service.check();
    await Future<void>.delayed(const Duration(seconds: 30));
  }
});
