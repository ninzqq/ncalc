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
        _buildDisplayRow(context, input),
        _buildDisplayRow(context, output),
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

  Widget _buildDisplayRow(context, inout) {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 20,
        right: 20,
        bottom: 8.0,
      ),
      child: Container(
        height: 100,
        //width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.primaries.last,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: TextField(
          maxLines: 1,
          //expands: false,
          keyboardType: TextInputType.none,
          controller: controller..text = inout,
          style: const TextStyle(
            fontSize: 32,
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.end,
          decoration: const InputDecoration.collapsed(hintText: ''),
        ),
      ),
    );
  }
}
