
import 'package:bytebank2/components/progress.dart';
import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //transactions.add(Transaction(100.0, Contact(0, 'Alex', 1000))); --Teste--
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: findAll(),
        builder: (context, snapshot){

          switch(snapshot.connectionState){

            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Transaction>? transactions = snapshot.data;
              return
              ListView.builder(
                itemBuilder: (context, index) {
                  final Transaction transaction = transactions![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text(
                        transaction.value.toString(),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        transaction.contact.accountNumber.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: transactions!.length,
              );
          }

          return Text('Unknow error');
        },
      ),
    );
  }
}

