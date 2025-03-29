import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculatrice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';

  // Méthode pour ajouter un chiffre ou un opérateur à l'affichage
  void _onButtonPressed(String value) {
    setState(() {
      _display += value;
    });
  }

  // Méthode pour évaluer l'expression (nous simplifions ici)
  void _calculateResult() {
    // Pour cet exemple, nous allons utiliser une méthode simple.
    // Dans un vrai projet, il faudrait sécuriser l'évaluation de l'expression.
    try {
      // Remplacez le symbole 'x' par '*' si nécessaire, etc.
      // Ici, nous utilisons la fonction "evaluate" de l'expression.
      // Note : Pour plus de complexité, on pourrait utiliser une bibliothèque d'évaluation.
      double result = _simpleEvaluate(_display);
      setState(() {
        _display = result.toString();
      });
    } catch (e) {
      setState(() {
        _display = e.toString();
      });
    }
  }

  // Fonction d'évaluation simplifiée (pour l'exemple uniquement)
  double _simpleEvaluate(String expression) {
    
    if (expression.contains("(")) {
      var start = expression.indexOf("(");

      for (var i = expression.length-1; i > start; i--) {
          if (expression[i] == ")") {
            var end = i;
            var subExpression = expression.substring(start+1, end);
            var result = _simpleEvaluate(subExpression);
            expression = expression.replaceRange(start, end+1, result.toString());
            break;
          }
      }
    }
    
    var operators = {
      "+": (double a, double b) => a + b,
      "-": (double a, double b) => a - b,
      "x": (double a, double b) => a * b,
      "/": (double a, double b) => a / b,
    };

    var operators_priority = ["+", "-", "x", "/"];

    if (expression.contains("%")) {
      var start_index = 0;
      var n = "";
      for (var i = 0; i < expression.length; i++) {
        if (expression[i] == "%") {
          expression = expression.replaceRange(start_index, i+1, (double.parse(n)/100).toString());
        }
        else if (operators.containsKey(expression[i])) {
          n = "";
          start_index = i+1;
        }
        else {
          n += expression[i];
        }
      }
    }

    for (var operator in operators_priority) {
      if (expression.contains(operator)) {
        var parts = expression.split(operator);
        var a = parts[0];
        var b = parts[1];
        var result = operators[operator]!(_simpleEvaluate(a), _simpleEvaluate(b));
        return result;
      }
    }

    return double.parse(expression);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculatrice'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Affichage du résultat ou de l'expression
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(fontSize: 65),
            ),
          ),
          // Ligne de boutons (pour l'exemple, on ajoute quelques boutons)
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(15),
              children: <Widget>[
                _buildButton('C'), // Effacer
                _buildButton('( )'), // Parenthèses
                _buildButton('%'), // Pourcentage
                _buildButton('/'), // Division
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('x'), // Multiplication
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('-'), // Soustraction
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('+'), // Addition
                _buildButton('0'),
                _buildButton('.'), // Décimale
                _buildButton("<"), // Supprimer le dernier caractère
                _buildButton('='), // Calculer le résultat
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire un bouton de calculatrice
  Widget _buildButton(String label) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: ()
    {
      if (label == 'C') {
        setState(() {
          _display = '';
        });
      } else if (label == '=') {
        _calculateResult();
      } else if (label == '<') {
        setState(() {
          _display = _display.substring(0, _display.length - 1);
        });
      } else if (label=="( )") {
        var open_parentheses = _display.split("").where((n) => n == "(").toList().length;
        var closed_parentheses = _display.split("").where((n) => n == ")").toList().length;

        if (open_parentheses == closed_parentheses) {
          setState(() {
            _display += "(";
          });
        }
        else {
          setState(() {
            _display += ")";
          });
        }
      } else {
            _onButtonPressed(label);
          }
        },
        child: Text(
          label,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
