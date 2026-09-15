import '../../mock/mock_seed.dart';
import '../../models/farm.dart';
import '../farm_repository.dart';

class MockFarmRepository implements FarmRepository {
  @override
  Future<List<Farm>> listFarms({String? orgId}) async {
    return MockSeed.farms.where((f) => orgId == null || f.orgId == orgId).toList();
  }

  @override
  Future<Farm?> getFarm(String farmId) async {
    for (final farm in MockSeed.farms) {
      if (farm.id == farmId) return farm;
    }
    return null;
  }
}
