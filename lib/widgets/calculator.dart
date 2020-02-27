import 'dart:math';
import 'package:flutter/material.dart';
import 'calculator_buttons.dart';

class CalculatorWidget extends StatefulWidget {
  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _currentValue;
  String _currentAction;
  Function _lastAction;
  double _storedValue;
  Widget _buttonsWidget;

  Map<String, Function> actions;

  final List<String>    buttons = 
  [
    '+', '-', '*', '/',
    '.', 'C', '=', 'e', 'sin',
    'cos', 'tan', 'atan'
  ];

  final List<String>    valueButtons =
  [
    '.', 'e'
  ];

  @override
  void initState() {
    super.initState();

    _clear();
    _storedValue = 0.0;

    actions = <String, Function>{
      '=': () {
        _evaluate();
      },
      'C': () {
        setState(() => _clear());
      },
      'AC': () {
        setState(() {
          _clear();
          _storedValue = 0.0;
        });
      },
      'sin': () {
        _apply(sin);
      },
      'cos': () {
        _apply(cos);
      },
      'tan': () {
        _apply(tan);
      },
      'tan': () {
        _apply(atan);
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: _createDisplay(context),
        ),
        Expanded(
          flex: 4,
          child: _buttonsWidget ?? _createButtons(context),
        ),
      ],
    );
  }

  Widget _createDisplay(BuildContext context) {
    String displayText = (_getCurrent()).toStringAsPrecision(8);

    return Card(
      child: FittedBox(
        alignment: Alignment.bottomRight,
        fit: BoxFit.contain,
        child: Container(
          child: Text(
            '$displayText',
            style: TextStyle(
              fontSize: 40.0,
              fontFamily: 'Monospace'
            ),
          ),
          padding: EdgeInsets.only(
            right: 4.0,
            left: 4.0,
          ),
        ),
      ),
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      )
    );
  }

  Widget _createButtons(BuildContext context) {
    _buttonsWidget = CalculatorButtonsWidget(buttons: buttons, onButtonPress: _buttonPress);

    return _buttonsWidget;
  }

  double _getCurrent() {
    return double.tryParse(_currentValue) ?? _storedValue;
  }

  void _buttonPress(String buttonText) {
    if (actions.containsKey(buttonText)) {
      actions[buttonText].call();
    } else if (buttons.contains(buttonText) && !valueButtons.contains(buttonText)) {
      if (_currentAction != '') {
        _evaluate();
      }

      _setAction(buttonText);
    } else {
      setState(() {
        _currentValue += buttonText;
      });
    }
  }

  void _apply(Function action) {
    double current = _getCurrent();

    setState(() {
      _clear();
      _currentValue = action(current).toString();
    });
  }

  void _clear() {
    _currentValue = '';
    _storedValue = 0.0;
    _currentAction = '';
  }

  void _repeatLastAction() {
    if (_lastAction != null) {
      _lastAction.call();
    }
  }

  void _evaluate() {
    double newValue = _storedValue;
    double currentValue = _getCurrent();
    String action = _currentAction;

    if (action == '') {
      _repeatLastAction();
      return;
    }

    Function evaluate = () {
      switch (action) {
        case '+':
          newValue += currentValue;
          break;
        case '-':
          newValue -= currentValue;
          break;
        case '*':
          newValue *= currentValue;
          break;
        case '/':
          newValue /= currentValue;
          break;
        default:
          newValue = currentValue;
          break;
      }
    };

    evaluate();

    Function cleanup = () {
      setState(() {
        _clear();
        _storedValue = newValue;
      });
    };

    _lastAction = () {
      newValue = _getCurrent();
      
      evaluate();
      cleanup();
    };

    cleanup();
  }

  void _setAction(String newAction) {
    setState(() {
      _currentAction = newAction;
      _storedValue = _getCurrent();
      _currentValue = '';
    });
  }
}