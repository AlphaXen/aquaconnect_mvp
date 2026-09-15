import '../models/report.dart';

abstract class ReportRepository {
  /// Most recent stored snapshot for a farm, or null if never generated.
  Future<Report?> getLatestReport(String farmId);

  /// Recomputes and persists a new snapshot for the farm using the current
  /// memos + ocean data (see `ReportGenerator`).
  Future<Report> generateReport(String farmId);

  /// Latest snapshot per farm, for the org-wide AllReport screen.
  Future<List<Report>> listLatestReports({required List<String> farmIds});
}
