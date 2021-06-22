import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request');
    print(data.toHttpRequest());
    print(' headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    print(' status code: ${data.statusCode}');
    print(' headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }
}

void findAll() async {
  Client client = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );
  final url = Uri.http(
    '192.168.0.35:8080',
    'transactions',
  );

  final response = await client.get(url);
}
