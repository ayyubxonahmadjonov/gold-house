import 'package:flutter/material.dart';

class PenoPlexScreen extends StatefulWidget {
  const PenoPlexScreen({super.key});

  @override
  State<PenoPlexScreen> createState() => _PenoPlexScreenState();
}

class _PenoPlexScreenState extends State<PenoPlexScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("PenoPlex")));
  }
}
