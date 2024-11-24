/// A utility class that defines the standard radius values used throughout the application.
class AppRadius {
  /// Basic radius values
  /// [none] - No radius (0)
  static const double none = 0;

  /// Extra small radius (4)
  static const double xs = 4;

  /// Small radius (8)
  static const double sm = 8;

  /// Medium radius (12)
  static const double md = 12;

  /// Large radius (16)
  static const double lg = 16;

  /// Extra large radius (24)
  static const double xl = 24;

  /// Circular radius (999) - Creates a fully rounded corner
  static const double circular = 999;

  /// Pill-shaped radius (100.0) - Creates a pill-shaped element
  static const double pill = 100.0;

  /// Component-specific radius values
  /// [button] - Default radius for buttons (8)
  static const double button = sm;

  /// [card] - Default radius for cards (12)
  static const double card = md;

  /// [dialog] - Default radius for dialogs (16)
  static const double dialog = lg;

  /// [bottomSheet] - Default radius for bottom sheets (24)
  static const double bottomSheet = xl;

  /// Input-specific radius values
  /// [input] - Default radius for input fields (8)
  static const double input = sm;

  /// [chip] - Default radius for chips (999)
  static const double chip = circular;

  /// Image-specific radius values
  /// [avatar] - Default radius for avatar images (999)
  static const double avatar = circular;

  /// [thumbnail] - Default radius for thumbnail images (12)
  static const double thumbnail = md;
}
