import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHandler {
  EnvHandler._();

  static String google_map_api_key = dotenv.env['GOOGLE_MAPS_API_KEY']!;


}
