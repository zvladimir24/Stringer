import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    // The default "data protection" macOS keychain requires a real Team-ID
    // code signature; local/ad-hoc builds (like this one, run outside the
    // App Store) don't have that, and fail with error -34018. The legacy
    // keychain API works fine without it.
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );
}
