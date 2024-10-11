import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncalc/src/calculator/calculator_notifier.dart';
import 'package:ncalc/src/settings/settings_view.dart';

class Display extends ConsumerWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var calculator = ref.watch(calculatorProvider.notifier);
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 1.9,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Column(
        children: [
          _buildTitleRow(context, ref),
          _buildDisplayRow(context, ref, true),
          _buildDisplayRow(context, ref, false),
          SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(''), // history here? hehe
                  ElevatedButton(
                    onPressed: () {
                      calculator.removeCharacterFromCursorPosition();
                    },
                    child: const Icon(Icons.backspace),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(context, ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'NCalc',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Roboto',
            ),
          ),
          const Text(
            'v0.1',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
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
    );
  }

  Widget _buildDisplayRow(context, ref, isInput) {
    var calculatorState = ref.watch(calculatorProvider);
    TextEditingController inputController = calculatorState.inputController;
    TextEditingController outputController = calculatorState.outputController;
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 20,
        right: 20,
        bottom: 8.0,
      ),
      child: SizedBox(
        height: 100,
        child: TextField(
          readOnly: !isInput,
          maxLines: 1,
          //expands: false,
          keyboardType: TextInputType.none,
          controller: isInput ? inputController : outputController,
          style: TextStyle(
            fontSize: isInput ? 32 : 24,
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.end,
          decoration: const InputDecoration.collapsed(hintText: '0'),
        ),
      ),
    );
  }
}
