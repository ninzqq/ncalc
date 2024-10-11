import 'package:flutter/material.dart';
import 'package:ncalc/src/calculator/calculator_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorButton extends ConsumerWidget {
  final String value;
  final CalculatorNotifier calculator;
  const CalculatorButton({
    super.key,
    required this.value,
    required this.calculator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var calculatorState = ref.read(calculatorProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: () {
            if (value == "C") {
              calculator.clear();
            } else if (value == ":)" || value == '(' || value == ')') {
            } else if (value == "=") {
              calculator.calculateExpression(
                  calculatorState.inputController.text, true);
            } else {
              calculator.addCharacterToCursorPosition(value);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
