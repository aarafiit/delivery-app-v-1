import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/banner_entity.dart';

abstract interface class BannerRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();
}
