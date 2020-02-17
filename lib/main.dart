import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcul application',
      home: Calculator(title: 'calculator'),
    );
  }
}

class Calculator extends StatefulWidget {
  Calculator({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CalculatorPage createState() => _CalculatorPage();
}

class _CalculatorPage extends State<Calculator> {
  int res = 0;   //store the result of the Math operation
  int _currentIndex = 0; //variable for the BottomNavigationBar (current page)
  String operation = ''; // Mathematical operation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CalculatorPage')),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() => _currentIndex = newIndex),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.looks_one), title: Text("One")),
          BottomNavigationBarItem(
              icon: Icon(Icons.looks_two), title: Text("Two")),
        ]
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next), onPressed: ()=>_toast()),

      body: Builder( builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(padding: EdgeInsets.all(16.0),
              child: Text("$operation",style:TextStyle(fontSize: 35.0))
          ),
          Padding(padding: EdgeInsets.all(16.0),
              child: Text("Result = $res",style:TextStyle(fontSize: 30.0))),

          Row(children: <Widget>[
            RaisedButton(onPressed: () => _putVar(7), child: Text('7')),
            RaisedButton(onPressed: () => _putVar(8), child: Text('8')),
            RaisedButton(onPressed: () => _putVar(9), child: Text('9')),
            RaisedButton(onPressed: () => _putVar(' + '), child: Text('+')),
          ], mainAxisAlignment: MainAxisAlignment.center),
          Row(children: <Widget>[
            RaisedButton(onPressed: () => _putVar(4), child: Text('4')),
            RaisedButton(onPressed: () => _putVar(5), child: Text('5')),
            RaisedButton(onPressed: () => _putVar(6), child: Text('6')),
            RaisedButton(onPressed: () => _putVar(' - '), child: Text('-')),
          ], mainAxisAlignment: MainAxisAlignment.center),
          Row(children: <Widget>[
            RaisedButton(onPressed: () => _putVar(1), child: Text('1')),
            RaisedButton(onPressed: () => _putVar(2), child: Text('2')),
            RaisedButton(onPressed: () => _putVar(3), child: Text('3')),
            RaisedButton(onPressed: () => _putVar(' * '), child: Text('*')),
          ], mainAxisAlignment: MainAxisAlignment.center),
          Row(children: <Widget>[
            RaisedButton(onPressed: () => _putVar(0), child: Text('0')),
            RaisedButton(
                onPressed: _delete, onLongPress: _clear, child: Text('Del')),
            RaisedButton(onPressed: _getRes, child: Text('Enter')),
            RaisedButton(onPressed: () => _putVar(' / '), child: Text('/')),
          ], mainAxisAlignment: MainAxisAlignment.center)
        ],
      )),
    );
  }

 ///***************** methods ********************

  void _toast() {
    Fluttertoast.showToast(
        msg: "This is a FloatingActionButton",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2
    );
  }

  //upon buttons clicks; add every value or operator to the operation string
  void _putVar(var i) {
    setState(() {
      operation += '$i';
    });
  }

  //i added operators with extra spaces ' + ' to split the operation to an array
  // of Numbers & Operators based on those spaces. function _calculate returns the
  //result of the operation, then we update our State (result)
  void _getRes() {
    try {
      var list = operation.split(' ');
      //print('list.toString = ${list.toString()}');
      int r = _calculate(list, 0);

      setState(() {
        r != null ? res = r : res = 0;
      });

    } catch (e) {
      print('caught Exc = $e');
    }
  }

  //we have extra spaces so they need to be automatically deleted if reached
  void _delete() {
    if(operation.length>0)
    setState(() {
      operation.endsWith(' ')?
      operation = operation.substring(0, operation.length - 2):
      operation = operation.substring(0, operation.length - 1);
    });
  }

  void _clear() {
    setState(() {
      operation = '';
      res = 0;
    });
  }

  //This recursive method calls itself until reaching the last number in the operation.
  //At the beginning, the first element list[0] will use the next operator stored in
  // list[i+1] to calculate it with the rest of the operation  "_calculate(list, i + 2)".
  // we jump to i+2 to see the next number because we already used the previous element
  // list[i] and it's operator list[i+1]. when we reach the end : list[n], we return the
  // last element Up to be start calculating using the previously unknown function calls results
  int _calculate(List list, int i) {
    if (i==list.length-1) return int.tryParse(list[i]);
    else
      switch (list[i + 1]) {
        case '+':
          {
            return int.tryParse(list[i]) + _calculate(list, i + 2);
          }
          break;
        case '*':
          {
            return int.tryParse(list[i]) * _calculate(list, i + 2);
          }
          break;
        case '-':
          {
            return int.tryParse(list[i]) - _calculate(list, i + 2);
          }
          break;
        case '/':
          {
            return (int.tryParse(list[i]) / _calculate(list, i + 2)).round();
          }
          break;
        default : return 0;
      }
  }
}