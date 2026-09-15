import '../models/ocean_reading.dart';
import 'ocean_service.dart';

/// Canned data matching the numbers baked into the approved `.dc.html`
/// designs, keyed by NIFS station code (001 = 완도, 002 = 해남).
class MockOceanService implements OceanService {
  static final Map<String, List<double>> _tempSeries = {
    '001': const [26.6, 26.9, 27.1, 27.4, 27.6, 27.7, 27.8],
    '002': const [26.9, 27.2, 27.6, 28.0, 28.3, 28.5, 28.6],
  };

  static const _salinity = {'001': 32.1, '002': 31.8};
  static const _dissolvedOxygen = {'001': 5.2, '002': 5.0};

  @override
  Future<OceanSnapshot> fetchSnapshot({
    required String stationCode,
    required String stationName,
    required String region,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final series = _tempSeries[stationCode] ?? _tempSeries['001']!;
    return OceanSnapshot(
      region: region,
      stationName: stationName,
      waterTemp: series.last,
      salinity: _salinity[stationCode] ?? _salinity['001'],
      dissolvedOxygen: _dissolvedOxygen[stationCode] ?? _dissolvedOxygen['001'],
      redTideStatus: '없음',
      sevenDayTemps: series,
      sevenDayLabels: _lastSevenDayLabels(),
      source: '바다누리 해양정보 · NIFS RISA (mock)',
      hasTrendHistory: true,
    );
  }

  @override
  Future<List<OceanObservation>> fetchRealtime({String? station}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      OceanObservation(
        stationCode: station ?? '001',
        stationName: station == '002' ? '해남' : '완도',
        observedDate: _today(),
        observedTime: '12:00',
        layer: '표층',
        waterTempC: (_tempSeries[station ?? '001'] ?? _tempSeries['001']!).last,
        status: '정상',
      ),
    ];
  }

  static List<String> _lastSevenDayLabels() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return '${d.month}/${d.day}';
    });
  }

  static String _today() {
    final d = DateTime.now();
    return '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
  }
}
