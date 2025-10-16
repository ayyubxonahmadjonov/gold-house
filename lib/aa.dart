import 'package:flutter/material.dart';
import 'package:gold_house/core/utils/video_player.dart';

class AAPage extends StatefulWidget {
  const AAPage({super.key});

  @override
  State<AAPage> createState() => _AAPageState();
}

class _AAPageState extends State<AAPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VideoWidget(url: "https://www.youtube.com/watch?v=MWERkikpEkI"),
      ),
    );
  }
}