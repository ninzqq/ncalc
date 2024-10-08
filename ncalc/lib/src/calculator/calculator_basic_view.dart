import 'package:flutter/material.dart';
import 'package:ncalc/src/calculator/calculator_notifier.dart';
import 'package:ncalc/src/calculator/calculator_button.dart';
import 'package:ncalc/src/calculator/display.dart';
import 'package:ncalc/src/settings/settings_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorBasicView extends ConsumerWidget {
  const CalculatorBasicView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorProvider);
    final calculator = ref.read(calculatorProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('nCalc'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Display(
                input: calculatorState.input,
                output: calculatorState.output,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildButtonRow(ref, [":)", "(", ")", "/"], calculator),
                    _buildButtonRow(ref, ["7", "8", "9", "*"], calculator),
                    _buildButtonRow(ref, ["4", "5", "6", "-"], calculator),
                    _buildButtonRow(ref, ["1", "2", "3", "+"], calculator),
                    _buildButtonRow(ref, ["C", "0", ".", "="], calculator),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a row of calculator buttons
  Widget _buildButtonRow(
      WidgetRef ref, List<String> values, CalculatorNotifier calculator) {
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
