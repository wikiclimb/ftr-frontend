/// Environment configuration file.
///
/// Environments have sane defaults that can be configured passing command line
/// arguments, for example:
///
/// ```flutter run --dart-define=APP_NAME=DevelopmentApp```
///
/// ```flutter test --dart-define=API_URL=api.example.com```
class EnvironmentConfig {
  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'api.wikiclimb.org',
  );

  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'WikiClimb',
  );

  static const baseImgUrl = String.fromEnvironment(
    'BASE_IMG_URL',
    defaultValue: 'https://wikiclimb.org/static/img/',
  );

  static const sliverAppBarBackgroundPlaceholder =
      'graphics/wikiclimb-logo-800-450.png';

  static const databaseName = 'wkc.sqlite';
}
