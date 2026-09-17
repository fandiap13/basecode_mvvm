import 'package:basecode/app/bootstrap.dart';
import 'package:basecode/config/flavor.dart';

/// Default entrypoint agar `flutter run` tanpa `-t` tetap jalan.
void main() => bootstrap(Flavor.dev);
