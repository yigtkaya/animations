import 'dart:async';

import 'package:flutter/material.dart';

class CountDownTimerAnimation extends StatefulWidget {
  const CountDownTimerAnimation({super.key});

  @override
  State<CountDownTimerAnimation> createState() => _CountDownTimerAnimationState();
}

class _CountDownTimerAnimationState extends State<CountDownTimerAnimation> with SingleTickerProviderStateMixin {
  static const int _initialCount = 6;
  late Timer timer;
  late AnimationController _animationController;
  int count = _initialCount;
  double _heightFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count--;
        _heightFactor = count / _initialCount;
        if (count <= 0) {
          timer.cancel();
          _heightFactor = 0.0;
        }
        _animationController.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildText(String text, double fontSize, FontWeight? fontWeight, double yOffset, double gradientHeight) {
    // Calculate the text height approximately (can be adjusted based on font size)
    final textHeight = fontSize * 1.2;

    // Calculate text position relative to center
    final screenHeight = MediaQuery.of(context).size.height;
    final centerY = screenHeight / 2;
    final textBottomY = centerY + yOffset;
    final textTopY = textBottomY + textHeight;

    // Text is half white if the gradient is between textTopY and TextBottomY

    final isHalfWhite = textBottomY <= gradientHeight && textTopY >= gradientHeight;

    final isPast = textBottomY <= gradientHeight;
    // Text is black only if it's completely above the gradient
    final textColor = isPast ? Colors.white : Colors.black;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [textColor, Colors.white.withOpacity(isHalfWhite ? 0.5 : 0.9)],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final currentHeight = _heightFactor + (1 - _animationController.value) * (1 / _initialCount);
              final gradientHeight = MediaQuery.of(context).size.height * currentHeight;

              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: gradientHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final gradientHeight = MediaQuery.of(context).size.height *
                    (_heightFactor + (1 - _animationController.value) * (1 / _initialCount));

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildText(count.toString(), 32, null, -40, gradientHeight),
                    _buildText('Still There?', 28, FontWeight.bold, 0, gradientHeight),
                    const SizedBox(height: 8),
                    _buildText('Tap anywhere to keep exploring', 16, null, 40, gradientHeight),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
