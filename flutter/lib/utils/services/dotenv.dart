import 'package:flutter_dotenv/flutter_dotenv.dart';

class Dotenv {
  static String get apiAuthority => dotenv.get('API_AUTHORITY');
}
