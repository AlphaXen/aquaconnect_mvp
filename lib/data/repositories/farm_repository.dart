import '../models/farm.dart';

abstract class FarmRepository {
  Future<List<Farm>> listFarms({String? orgId});

  Future<Farm?> getFarm(String farmId);
}
