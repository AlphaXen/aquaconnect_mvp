import '../../mock/mock_seed.dart';
import '../../models/disease_info.dart';
import '../disease_info_repository.dart';

class MockDiseaseInfoRepository implements DiseaseInfoRepository {
  @override
  Future<List<DiseaseInfo>> listDiseaseInfo() async => MockSeed.diseaseInfo;
}
