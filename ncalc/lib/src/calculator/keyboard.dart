import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncalc/src/calculator/calculator_button.dart';
import 'package:ncalc/src/calculator/calculator_notifier.dart';

class Keyboard extends ConsumerWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildButtonRow(ref, [":)", "(", ")", "/"]),
            _buildButtonRow(ref, ["7", "8", "9", "*"]),
            _buildButtonRow(ref, ["4", "5", "6", "-"]),
            _buildButtonRow(ref, ["1", "2", "3", "+"]),
            _buildButtonRow(ref, ["C", "0", ".", "="]),
          ],
        ),
      ),
    );
  }

  // Helper method to create a row of calculator buttons
  Widget _buildButtonRow(WidgetRef ref, List<String> values) {
    var calculator = ref.watch(calculatorProvider.notifier);
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: values
              .map(
                (value) => CalculatorButton(
                  value: value,
                  calculator: calculator,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
