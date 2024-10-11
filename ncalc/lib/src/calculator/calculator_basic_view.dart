import 'package:flutter/material.dart';
import 'package:ncalc/src/calculator/display.dart';
import 'package:ncalc/src/calculator/keyboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorBasicView extends ConsumerWidget {
  const CalculatorBasicView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Display(),
            Keyboard(),
          ],
        ),
      ),
    );
  }
}
