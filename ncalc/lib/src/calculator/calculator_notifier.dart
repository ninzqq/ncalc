import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorState {
  final String input;
  final String output;

  CalculatorState({
    required this.input,
    required this.output,
  });

  CalculatorState copyWith({
    String? input,
    String? output,
  }) {
    return CalculatorState(
      input: input ?? this.input,
      output: output ?? this.output,
    );
  }
}

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(CalculatorState(input: '0', output: '0'));

  void inputNumber(String number) {
    if (state.input.length >= 30) return; // Limit input length
    if (state.input == '0') {
      state = state.copyWith(input: '');
    }
    state = state.copyWith(input: state.input + number);
  }

  double calculateExpression(String input) {
    try {
      // Split the input by numbers and operators using a regular expression.
      List<String> tokens = input.split(RegExp(r'(?<=[-+*/])|(?=[-+*/])'));

      if (isOperator(tokens[0])) {
        tokens.insert(0, state.output);
      }

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
        state = state.copyWith(input: '0', output: result.toInt().toString());
      } else {
        state = state.copyWith(input: '0', output: result.toString());
      }

      return result;
    } catch (e) {
      state = state.copyWith(input: '0', output: 'SYNTAX ERROR');
      return 0;
    }
  }

  void clear() {
    state = state.copyWith(input: '0', output: '0');
  }

  bool hasDecimals(double num) {
    return num % 1 != 0;
  }

  bool isOperator(token) {
    return token == '+' || token == '-' || token == '*' || token == '/';
  }
}

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});
