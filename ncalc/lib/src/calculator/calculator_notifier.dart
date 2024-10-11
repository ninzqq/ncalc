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
      // Split the input by numbers and operators using a regular expression.
      List<String> tokens = input.split(RegExp(r'(?<=[-+*/])|(?=[-+*/])'));

      if (isOperator(tokens[0]) && state.outputController.text.isNotEmpty) {
        tokens.insert(0, state.outputController.text);
      }

      if (isOperator(tokens[tokens.length - 1])) return (0, false);

      // Step 1: Handle Multiplication and Division first
      List<String> intermediateTokens = [];
      double currentValue =
          double.parse(tokens[0]); // Start with the first number

      for (int i = 1; i < tokens.length; i += 2) {
        String operator = tokens[i];
        double nextValue = double.parse(tokens[i + 1]);

        if (operator == "*") {
          currentValue *= nextValue;
        } else if (operator == "/") {
          currentValue /= nextValue;
        } else {
          // If it's + or -, we save the current value and the operator
          intermediateTokens.add(currentValue.toString());
          intermediateTokens.add(operator);
          currentValue = nextValue; // Update current value with the next number
        }
      }

      // Don't forget to add the last value after handling * and /
      intermediateTokens.add(currentValue.toString());

      // Step 2: Handle Addition and Subtraction
      double result = double.parse(intermediateTokens[0]);

      for (int i = 1; i < intermediateTokens.length; i += 2) {
        String operator = intermediateTokens[i];
        double nextValue = double.parse(intermediateTokens[i + 1]);

        if (operator == "+") {
          result += nextValue;
        } else if (operator == "-") {
          result -= nextValue;
        }
      }

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

  bool hasDecimals(double num) {
    return num % 1 != 0;
  }

  bool isOperator(token) {
    return token == '+' || token == '-' || token == '*' || token == '/';
  }

  (double, bool) isValidFormula(String input) {
    var (result, isValid) = calculateExpression(input, false);
    if (isValid) {
      return (result, true);
    } else {
      return (0, false);
    }
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
}

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});
