import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget
{
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context)
  {
    return transactions.isEmpty ?
    LayoutBuilder(builder: (ctx, constriants)
    {
      return Column(
        children: <Widget>[
          Text('No Transactions Added yet !!!',
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              height: constriants.maxHeight * 0.7,
              child: Image.asset('Assets/Images/waiting.png',
                fit: BoxFit.cover,
              )
          ),
        ],
      );
    },
    ) : ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 5,
                  ),
            child: ListTile(
             leading: CircleAvatar(
               radius: 30,
               child: Padding( 
                 padding: const EdgeInsets.all(10),
                  child: FittedBox(
                    child: Text('\$${transactions[index].amount}'),
                    ),
                ),
             ),
            title: Text(transactions[index].title, style: Theme.of(context).textTheme.headline6,), 
            subtitle: Text(DateFormat.yMMMd().format(transactions[index].date),),
              trailing: MediaQuery.of(context).size.width > 350
                  ? TextButton.icon(
                      onPressed: () => deleteTx(transactions[index].id),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      )
                  : IconButton(
                      onPressed: () => deleteTx(transactions[index].id),
                      icon: const Icon(Icons.delete),
                      color: Colors.red//Theme.of(context).errorColor,
                      ),
              ),
            );
          },
          itemCount: transactions.length,
       );
  }
}
