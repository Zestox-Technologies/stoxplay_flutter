import 'app_error.dart';

abstract class ApiResponse<T> {
  const ApiResponse();

  bool get isSuccess => this is Success<T>;

  bool get isError => this is Error<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;

  AppError? get error => isError ? (this as Error<T>).error : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onError,
  }) {
    if (isSuccess) {
      return onSuccess(data!);
    } else {
      return onError(error!);
    }
  }
}

class Success<T> extends ApiResponse<T> {
  @override
  final T data;

  const Success(this.data);
}

class Error<T> extends ApiResponse<T> {
  @override
  final AppError error;

  const Error(this.error);
}
