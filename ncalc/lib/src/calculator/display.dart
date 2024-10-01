import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Display extends ConsumerWidget {
  final String input;
  final String output;
  const Display({super.key, required this.input, required this.output});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildDisplayRow(input),
        _buildDisplayRow(output),
      ],
    );
  }

  Widget _buildDisplayRow(inout) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 20,
        right: 20,
        bottom: 8.0,
      ),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.primaries.last,
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              inout,
              style: const TextStyle(
                fontSize: 48,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ),
    );
  }
}
