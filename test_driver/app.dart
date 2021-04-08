import 'package:flutter_driver/driver_extension.dart';
import 'package:covid_19_contact_tracing_app/main.dart' as app;

//uses flutter_driver library
void main() async {
  enableFlutterDriverExtension();

  await app.main();
}