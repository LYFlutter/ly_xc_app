import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget {
  TravelPage({Key? key}) : super(key: key);

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('旅拍'),
      ),
    );
  }
}
