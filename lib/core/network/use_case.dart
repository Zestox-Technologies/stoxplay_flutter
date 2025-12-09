import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/app_error.dart';

abstract class UseCase<Type, Params> {
  Future<Either<AppError, Type>> call(Params params);
}