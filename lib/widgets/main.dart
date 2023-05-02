import 'dart:io';

import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import './transaction_list.dart' as tl;
import './new_transaction.dart';
import '../models/transaction.dart';
import './chart.dart' as ch;

void main()  
{
    //WidgetsFlutterBinding.ensureInitialized();
    //SystemChrome.setPreferredOrientations(
    //    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]
    //);
    runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6 : const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
              ),
          button: const TextStyle(
            color: Colors.white,
              ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6 : const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{

  final List<Transaction> _userTransactions = [
    //Transaction(id: '0001', title: 'New Shoes', amount: 1000.00, date: DateTime.now(),),
    //Transaction(id: '0002', title: 'New Socks', amount: 500.00, date: DateTime.now(),),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions
  {
      return _userTransactions.where((tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime choosenDate)
  {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx)
  {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id)
  {
      setState(() {
        _userTransactions.removeWhere((tx) => tx.id == id);
      });
  }

  @override
  Widget build(BuildContext context)
  {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final Widget appBar = Platform.isIOS
        ?  CupertinoNavigationBar(
              middle: const Text('Expense Planner'),
              trailing: Row(children: <Widget>[
                    GestureDetector(
                        child: const Icon(CupertinoIcons.add),
                        onTap: () => _startAddNewTransaction(context),
                      ),
                    ],
                  ),
              )
        : AppBar(
            title: const Text('Expense Planner'),
            actions: <Widget>[
                IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: const Icon(Icons.add_box),
                   ),
            ],
          );

    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
      child: tl.TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child:  SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if(isLandscape) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Show Chart', style: Theme.of(context).textTheme.headline6,),
              Switch.adaptive(value: _showChart, onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
            ],
          ),
          if(!isLandscape) Container(
            height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
            child: ch.Chart( _recentTransactions ),
          ),
          if(!isLandscape) txListWidget,
          if(isLandscape) _showChart ?
          Container(
            height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top) * 0.8,
            child: ch.Chart( _recentTransactions ),
          )
              : txListWidget,
        ],
      ),
    ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
          child: pageBody,
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Expense Planner'),
            trailing: Row(children: <Widget>[
              GestureDetector(
                child: const Icon(CupertinoIcons.add),
                onTap: () => _startAddNewTransaction(context),
              ),
            ],
            ),
          ),
        )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Expense Planner'),
              actions: <Widget>[
                IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: const Icon(Icons.add_box),
                ),
              ],
            ),
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                      onPressed: () => _startAddNewTransaction(context),
                       child: const Icon(Icons.add_box),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                    ),
            );
        }
}
