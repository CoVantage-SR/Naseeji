import 'package:equatable/equatable.dart';

enum BootstrapStatus { initial, initializing, success, failure }

class BootstrapState extends Equatable {
  final BootstrapStatus status;
  final String? message;

  const BootstrapState({
    this.status = BootstrapStatus.initial,
    this.message,
  });

  bool get isSuccess => status == BootstrapStatus.success;

  BootstrapState copyWith({
    BootstrapStatus? status,
    String? message,
  }) {
    return BootstrapState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
