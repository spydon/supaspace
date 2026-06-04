/// Supabase connection for the game client.
///
/// Project ref: lrnasmsbyyxyfpjuquzw
///
/// The publishable (anon) key is intentionally NOT committed. It is injected at
/// build time as a Dart define, e.g.:
///
///   flutter build web --wasm --dart-define=SUPABASE_ANON_KEY=`<publishable>`
///
/// In CI the value comes from the `SUPABASE_ANON_KEY` GitHub Actions secret,
/// baked into the bundle the workflow publishes (and that Cloudflare serves).
/// Use only the publishable/anon key here (it respects Row Level Security);
/// never a secret/service key.
const supabaseUrl = 'https://lrnasmsbyyxyfpjuquzw.supabase.co';

// ignore: do_not_use_environment
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
