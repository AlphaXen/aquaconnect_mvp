import '../models/ocean_reading.dart';

/// Fetches ocean environment data. Real-time values are proxied through the
/// `ocean_service` Node app (deployed on Railway) so the Flutter Web build
/// never calls the NIFS API directly and hits its CORS restrictions.
abstract class OceanService {
  Future<OceanSnapshot> fetchSnapshot({
    required String stationCode,
    required String stationName,
    required String region,
  });

  Future<List<OceanObservation>> fetchRealtime({String? station});
}
