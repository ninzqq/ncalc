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
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceBright,
          ],
        ),
      ),
      child: Column(
        children: [
          _buildTitleRow(context, ref),
          _buildDisplayRow(context, ref, true),
          _buildDisplayRow(context, ref, false),
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 23.0,
                right: 23.0,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(''), // history here? hehe
                  ElevatedButton(
                    onPressed: () {
                      calculator.removeCharacterFromCursorPosition();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primaryFixed,
                      backgroundColor: theme.colorScheme.primary,
                    ),
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
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 16,
        right: 16,
        bottom: 0,
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
            color: theme.colorScheme.primaryFixed,
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
    var theme = Theme.of(context);
    return SizedBox(
      height: 100,
      child: Padding(
        padding: EdgeInsets.only(
          top: isInput ? 10 : 0,
          left: 20,
          right: 20,
          bottom: 8.0,
        ),
        child: TextField(
          readOnly: !isInput,
          maxLines: 1,
          //expands: false,
          keyboardType: TextInputType.none,
          controller: isInput ? inputController : outputController,
          style: isInput
              ? theme.textTheme.displayLarge
              : theme.textTheme.displayMedium,
          textAlign: TextAlign.end,
          decoration: InputDecoration.collapsed(
            hintText: '0',
            hintStyle: isInput
                ? theme.textTheme.displayLarge
                : theme.textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
