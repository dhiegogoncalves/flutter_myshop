import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final baseApiUrl = DotEnv().env['baseApiUrl'];
  static final webApikey = DotEnv().env['webApikey'];
}
