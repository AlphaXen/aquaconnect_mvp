import '../models/farm.dart';
import '../models/report.dart';
import '../models/share_link.dart';

class SharedReportBundle {
  const SharedReportBundle({required this.farm, required this.report, required this.link});

  final Farm farm;
  final Report report;
  final ShareLink link;
}

abstract class ShareLinkRepository {
  Future<ShareLink> createShareLink({required String farmId, required ShareLinkExpiry expiry});

  Future<List<ShareLink>> listShareLinks({String? farmId});

  /// Public lookup used by the unauthenticated `/r/:token` page. Returns
  /// null if the token is unknown, revoked, or expired.
  Future<SharedReportBundle?> resolveToken(String token);
}
