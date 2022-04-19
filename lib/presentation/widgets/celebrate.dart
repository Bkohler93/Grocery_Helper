import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CelebrateConfetti extends StatefulWidget {
  const CelebrateConfetti({Key? key}) : super(key: key);

  @override
  State<CelebrateConfetti> createState() => _CelebrateConfettiState();
}

class _CelebrateConfettiState extends State<CelebrateConfetti> {
  final controller = ConfettiController(duration: const Duration(milliseconds: 50));

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: ConfettiWidget(
        confettiController: controller,
        shouldLoop: false,
        blastDirection: pi * (-1 / 2),
        gravity: 0.18,
        minimumSize: const Size(20, 20),
        maximumSize: const Size(25, 25),
        maxBlastForce: 40,
        minBlastForce: 20,
        particleDrag: 0.02,
        numberOfParticles: 30,
      ),
    );
  }
}
