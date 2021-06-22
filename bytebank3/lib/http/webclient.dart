
import 'package:http/http.dart';

void findAll() async {
  final url = Uri.http(
    '192.168.0.35:8080',
    'transactions',
  );

  final response = await get(url);
  print(response.body.toString());
}