import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

enum ConnectionStatus {
  connected,
  disconnected,
}

class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectionStatus> _statusController =
      StreamController<ConnectionStatus>.broadcast();

  ConnectivityService(this._connectivity) {
    _init();
  }

  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  void _init() {
    _connectivity.onConnectivityChanged.listen((results) {
      final status = _mapResultsToStatus(results);
      _statusController.add(status);
    });
  }

  Future<ConnectionStatus> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return _mapResultsToStatus(results);
  }

  ConnectionStatus _mapResultsToStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectionStatus.disconnected;
    }
    return ConnectionStatus.connected;
  }

  void dispose() {
    _statusController.close();
  }
}

@riverpod
ConnectivityService connectivityService(ConnectivityServiceRef ref) {
  final connectivity = Connectivity();
  final service = ConnectivityService(connectivity);
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
Stream<ConnectionStatus> connectivityStatus(ConnectivityStatusRef ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
}


