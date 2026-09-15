import '../models/disease_info.dart';

abstract class DiseaseInfoRepository {
  Future<List<DiseaseInfo>> listDiseaseInfo();
}
