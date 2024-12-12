import 'package:flutter/material.dart';
class $1 extends StatelessWidget {
  const $1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Widget Column'),
        ),
        body: const Column(
          children: [
            Text('Kolom 1'),
            Text('Kolom 3'),
            Text('Kolom 2'),
            Text('Kolom 4')
          ],
        ));
  }
}