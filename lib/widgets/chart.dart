import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart' as chb;

class  Chart extends StatelessWidget
{

  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactionValues
  {
      return List.generate(7, (index)
      {
        final weekDay = DateTime.now().subtract(Duration(days: index),);
        var totalSum = 0.0;
        for(var i=0; i < recentTransactions.length; i++)
          {
              if(
                  recentTransactions[i].date.day == weekDay.day &&
                  recentTransactions[i].date.month == weekDay.month &&
                  recentTransactions[i].date.year == weekDay.year
              )
                {
                  totalSum = totalSum + recentTransactions[i].amount;
                }
          }

        return {'day': DateFormat.E().format(weekDay).substring(0, 1), 'amount' : totalSum,};
      }
      ).reversed.toList();
  }

  double get totalSpending
  {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return (sum + (item['amount']as double));
    });
  }

  @override
  Widget build(BuildContext context)
  {
      return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupTransactionValues.map((data){
          return Flexible(
            fit: FlexFit.tight,
            child: chb.ChartBar(
              (data['day'] as String),
              (data['amount'] as double),
              totalSpending == 0.0 ? 0.0 : (data['amount'] as double ) / totalSpending,
            ),
          );
        }).toList(),
        ),
      ),
      );
  }
}