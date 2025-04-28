import 'package:flutter_dotenv/flutter_dotenv.dart';

String splitHostUrl(String url) {
  return url.replaceAll("localhost", dotenv.get('IP'));
}
