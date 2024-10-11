import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorState {
  final TextEditingController inputController;
  final TextEditingController outputController;

  CalculatorState({
    required this.inputController,
    required this.outputController,
  });

  CalculatorState copyWith({
    TextEditingController? inputController,
    TextEditingController? outputController,
  }) {
    return CalculatorState(
      inputController: inputController ?? this.inputController,
      outputController: outputController ?? this.outputController,
    );
  }
}

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier()
      : super(
          CalculatorState(
            inputController: TextEditingController(),
            outputController: TextEditingController(),
          ),
        );

  void addCharacterToCursorPosition(String character) {
    var inputField = state.inputController;
    var outputField = state.outputController;

    // Continue the formula if the output is not empty
    if (inputField.text.isEmpty) {
      if (outputField.text.isNotEmpty) {
        inputField.text = outputField.text;
      }
    }

    final text = inputField.text;
    final TextSelection textSelection;

    // If the user hasn't selected any text, add the character at the end
    if (inputField.selection.start == -1 && inputField.selection.end == -1) {
      inputField.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
      textSelection = inputField.selection;
    } else {
      textSelection = inputField.selection;
    }

    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      character,
    );

    inputField.text = newText;
    inputField.selection = textSelection.copyWith(
      baseOffset: textSelection.start + character.length,
      extentOffset: textSelection.start + character.length,
    );

    updateOutputField(newText);
  }

  void removeCharacterFromCursorPosition() {
    TextEditingController inputField = state.inputController;

    if (inputField.text.isEmpty) return;

    final text = inputField.text;
    final TextSelection textSelection;

    // If the user hasn't selected any text, add the selection at the end
    if (inputField.selection.start == -1 && inputField.selection.end == -1) {
      inputField.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
      textSelection = inputField.selection;
    } else {
      textSelection = inputField.selection;
    }

    final newText = text.replaceRange(
      textSelection.start - 1,
      textSelection.end,
      '',
    );

    inputField.text = newText;
    inputField.selection = textSelection.copyWith(
      baseOffset: textSelection.start - 1,
      extentOffset: textSelection.start - 1,
    );

    updateOutputField(newText);
  }

  (double, bool) calculateExpression(String input, bool equalsButtonPressed) {
    try {
      // Split the input by numbers, operators, and parentheses using a regular expression.
      List<String> tokens = input.split(RegExp(r'(?<=[-+*/()])|(?=[-+*/()])'));

      if (isOperator(tokens[0]) && state.outputController.text.isNotEmpty) {
        tokens.insert(0, state.outputController.text);
      }

      if (isOperator(tokens[tokens.length - 1])) return (0, false);

      List<String> operators = [];
      List<double> operands = [];

      for (String token in tokens) {
        if (isNumeric(token)) {
          operands.add(double.parse(token));
        } else if (token == '(') {
          operators.add(token);
        } else if (token == ')') {
          while (operators.isNotEmpty && operators.last != '(') {
            String operator = operators.removeLast();
            double b = operands.removeLast();
            double a = operands.removeLast();
            operands.add(applyOperator(a, b, operator));
          }
          operators.removeLast(); // Remove the '('
        } else if (isOperator(token)) {
          while (operators.isNotEmpty &&
              precedence(operators.last) >= precedence(token)) {
            String operator = operators.removeLast();
            double b = operands.removeLast();
            double a = operands.removeLast();
            operands.add(applyOperator(a, b, operator));
          }
          operators.add(token);
        }
      }

      // Apply remaining operators
      while (operators.isNotEmpty) {
        String operator = operators.removeLast();
        double b = operands.removeLast();
        double a = operands.removeLast();
        operands.add(applyOperator(a, b, operator));
      }

      double result = operands.last;

      if (!hasDecimals(result)) {
        state.outputController.text = result.toInt().toString();
      } else {
        state.outputController.text = result.toString();
      }

      if (equalsButtonPressed) {
        state.inputController.text = '';
      }

      return (result, true);
    } catch (e) {
      state.outputController.text = 'SYNTAX ERROR';
      return (0, false);
    }
  }

  void clear() {
    state.inputController.text = '';
    state.outputController.text = '';
  }

  void updateOutputField(String text) {
    var outputField = state.outputController;

    if (text.isEmpty) {
      outputField.text = '';
      return;
    }

    var (result, isValid) = isValidFormula(text);
    if (isValid) {
      outputField.text = result.toString();
    }
  }

  // Helper functions
  bool hasDecimals(double num) {
    return num % 1 != 0;
  }

  (double, bool) isValidFormula(String input) {
    var (result, isValid) = calculateExpression(input, false);
    if (isValid) {
      return (result, true);
    } else {
      return (0, false);
    }
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  bool isOperator(String str) {
    return ['+', '-', '*', '/'].contains(str);
  }

  int precedence(String operator) {
    if (operator == '+' || operator == '-') return 1;
    if (operator == '*' || operator == '/') return 2;
    return 0;
  }

  double applyOperator(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return a / b;
      default:
        throw ArgumentError('Invalid operator');
    }
  }
}

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});
