import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_weight_tracker/src/domain/base/failure.dart';

abstract class UseCase<Type, Params> {
  @protected
  Future<Type> execute(Params param);

  Future<Either<Failure, Type>> call(Params params) async {
    try {
      return Right(await execute(params));
    } catch (error, stackTrace) {
      return Left(Failure(message: error.toString(), stackTrace: stackTrace));
    }
  }
}

abstract class UseCaseNoParam extends UseCase<Type, void> {
  @override
  Future<Type> execute(void param);
}
