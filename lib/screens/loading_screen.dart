import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StaggeredLoading extends StatefulWidget {
  const StaggeredLoading({super.key});

  @override
  State<StaggeredLoading> createState() => _StaggeredLoadingState();
}

class _StaggeredLoadingState extends State<StaggeredLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 100,
      ),
    ));
  }
}