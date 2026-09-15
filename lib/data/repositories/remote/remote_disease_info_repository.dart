import '../../models/disease_info.dart';
import '../../services/api_client.dart';
import '../disease_info_repository.dart';

class RemoteDiseaseInfoRepository implements DiseaseInfoRepository {
  RemoteDiseaseInfoRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<DiseaseInfo>> listDiseaseInfo() async {
    final json = await _api.get('/api/disease-info') as List<dynamic>;
    return json.map((e) => DiseaseInfo.fromJson(e as Map<String, dynamic>)).toList();
  }
}
