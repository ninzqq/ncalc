import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncalc/src/calculator/calculator_notifier.dart';

class Display extends ConsumerWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildDisplayRow(context, ref, true),
        _buildDisplayRow(context, ref, false),
        SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.only(left: 23.0, right: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('History'),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('<-'),
                )
              ],
            ),
          ),
        ),
      ],
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
