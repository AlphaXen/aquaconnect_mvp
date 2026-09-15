import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ocean_reading.dart';
import 'ocean_service.dart';

/// Talks to the `server/` API's `/api/ocean/*` routes, which wrap the NIFS
/// `risaList` OpenAPI so Flutter Web never hits it (and its CORS policy)
/// directly.
///
/// That upstream API only reports the current water temperature per
/// station — no salinity, dissolved oxygen, red tide status, or history —
/// so [fetchSnapshot] leaves those fields null/short rather than inventing
/// numbers. See `server/README.md` for the API contract.
class RailwayOceanService implements OceanService {
  RailwayOceanService({required String baseUrl, http.Client? client})
      : _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl,
        _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  @override
  Future<List<OceanObservation>> fetchRealtime({String? station}) async {
    final uri = Uri.parse('$_baseUrl/api/ocean/realtime').replace(
      queryParameters: station == null ? null : {'station': station},
    );
    final response = await _client.get(uri, headers: const {'Accept': 'application/json'});
    if (response.statusCode != 200) {
      throw Exception('실시간 수온 조회 실패 (HTTP ${response.statusCode})');
    }
    final body = jsonDecode(response.body) as List<dynamic>;
    return body.map((e) => OceanObservation.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<OceanSnapshot> fetchSnapshot({
    required String stationCode,
    required String stationName,
    required String region,
  }) async {
    final observations = await fetchRealtime(station: stationCode);
    final withTemp = observations.where((o) => o.waterTempC != null).toList();
    final latestTemp = withTemp.isEmpty ? null : withTemp.first.waterTempC!;

    if (latestTemp == null) {
      throw Exception('$stationName 관측소의 수온 데이터를 찾을 수 없습니다.');
    }

    return OceanSnapshot(
      region: region,
      stationName: withTemp.first.stationName,
      waterTemp: latestTemp,
      sevenDayTemps: [latestTemp],
      sevenDayLabels: const ['오늘'],
      source: 'NIFS RISA (실시간, 이력 데이터 미제공)',
      hasTrendHistory: false,
    );
  }
}
