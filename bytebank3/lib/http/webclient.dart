import 'dart:convert';

import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
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

final Client client = InterceptedClient.build(
  interceptors: [
    LoggingInterceptor(),
  ],
);

final url = Uri.http(
  '192.168.0.35:8080',
  'transactions',
);

Future<List<Transaction>> findAll() async {
  final response = await client.get(url).timeout(Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(
      response.body); //Decodifica o json para poder criar a lista de transações
  final List<Transaction> transactions = []; //criando a lista vazia
  for (Map<String, dynamic> transactionJson in decodedJson) {
    // Varre o Json decodificado extraindo o elemento, que representa o mapa que vai ter a cha String
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    final Transaction transaction = Transaction(
      //e valores dinâmicos
      transactionJson['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
    transactions.add(transaction);
  }
  return transactions;
}

Future<Transaction> save(Transaction transaction) async {

  final Map<String, dynamic> transactionMap = {
    'value' : transaction.value,
    'contact' : {
      'name' : transaction.contact.name,
      'accountNumber' : transaction.contact.accountNumber
    }
  };
  final String transactionJson = jsonEncode(transactionMap);

  final Response response = await client.post(url,
      headers: {'Content-type': 'application/json',
        'password': '1000',
      },body: transactionJson);

  Map<String, dynamic> json = jsonDecode(response.body);
  final Map<String, dynamic> contactJson = json['contact'];
  return  Transaction(
    json['value'],
    Contact(
      0,
      contactJson['name'],
      contactJson['accountNumber'],
    ),
  );

}
