/// Build-time configuration read from `--dart-define` flags.
///
/// Local dev default is mock mode so the app runs without any backend:
///   flutter run -d chrome
/// Once the `server/` API is deployed (Railway + its Postgres plugin),
/// point the app at it with:
///   flutter run -d chrome --dart-define=USE_MOCK=false \
///     --dart-define=API_BASE_URL=https://YOUR-RAILWAY-SERVICE.up.railway.app
class Env {
  Env._();

  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);

  /// Base URL for the `server/` API — auth, farms, memos, reports, share
  /// links, and the `/api/ocean/*` NIFS proxy all live under this one host.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
