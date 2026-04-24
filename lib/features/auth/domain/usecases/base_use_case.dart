import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

/// Abstract base class for all domain use cases.
///
/// [Type] is the success return type.
/// [Params] is the input parameter type (use [NoParams] when no input is needed).
abstract class BaseUseCase<Type, Params> {
  const BaseUseCase();

  Future<Either<Failure, Type>> call(Params params);
}

/// Used as the [Params] type for use cases that require no input.
class NoParams {
  const NoParams();
}
