class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final DateTime timestamp;

  ApiResponse({required this.success, required this.message, required this.data, required this.timestamp});

  /// Factory constructor for parsing from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Convert back to JSON
  Map<String, dynamic> toJson(dynamic Function(T value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Computed properties
  bool get isSuccess => success;

  bool get isError => !success;
}

enum ApiStatus { initial, success, loading, failed }

extension ApiStatusExtension on ApiStatus {
  bool get isInitial => this == ApiStatus.initial;

  bool get isSuccess => this == ApiStatus.success;

  bool get isLoading => this == ApiStatus.loading;


  bool get isFailed => this == ApiStatus.failed;
}
