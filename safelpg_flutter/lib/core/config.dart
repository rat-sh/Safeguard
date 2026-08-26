/// All sensitive configuration is injected at compile time via --dart-define.
/// Run the app with:
///   flutter run \
///     --dart-define=SUPABASE_URL=<your_url> \
///     --dart-define=SUPABASE_ANON_KEY=<your_key> \
///     --dart-define=FASTAPI_BASE_URL=http://<your_server_ip>:8000
class AppConfig {
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static const String fastapiBaseUrl =
      String.fromEnvironment('FASTAPI_BASE_URL', defaultValue: 'http://10.0.2.2:8000');
}
