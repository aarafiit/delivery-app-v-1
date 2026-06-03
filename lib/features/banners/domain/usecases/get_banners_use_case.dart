import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/banner_entity.dart';
import '../repositories/banner_repository.dart';

class GetBannersUseCase extends BaseUseCase<List<BannerEntity>, NoParams> {
  final BannerRepository _repository;

  const GetBannersUseCase(this._repository);

  @override
  Future<Either<Failure, List<BannerEntity>>> call(NoParams params) =>
      _repository.getBanners();
}
