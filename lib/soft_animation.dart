import 'package:flutter/material.dart';
import 'dart:ui';

class TaskListAnimation extends StatefulWidget {
  const TaskListAnimation({super.key});

  @override
  State<TaskListAnimation> createState() => _TaskListAnimationState();
}

class _TaskListAnimationState extends State<TaskListAnimation> {
  bool isExpanded = false;
  double dragStart = 0;

  double _screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double _screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (dragStart - details.globalPosition.dy > 20 && isExpanded) {
      setState(() => isExpanded = false);
    } else if (dragStart - details.globalPosition.dy < -20 && !isExpanded) {
      setState(() => isExpanded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = _screenHeight(context) * 0.1;
    final expandedHeight = _screenHeight(context) * 0.5;
    final horizontalPadding = _screenWidth(context) * 0.05;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/particules.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding).copyWith(top: topMargin),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(
                    begin: isExpanded ? 0 : 3,
                    end: isExpanded ? 0 : 3,
                  ),
                  builder: (context, blur, child) => BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                    ),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(
                        begin: isExpanded ? 0 : 3,
                        end: isExpanded ? 0 : 3,
                      ),
                      builder: (context, blur, child) => BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blur,
                          sigmaY: blur,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 28,
                                ),
                                children: [
                                  TextSpan(text: 'Good morning, '),
                                  TextSpan(text: '🧑 '),
                                  TextSpan(
                                    text: "Yiğit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 28,
                                ),
                                children: [
                                  TextSpan(text: 'You have '),
                                  TextSpan(text: '📅 '),
                                  TextSpan(
                                    text: '3 meetings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ', '),
                                  TextSpan(text: '✓ '),
                                  TextSpan(
                                    text: '2 tasks',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(text: '💪 '),
                                  TextSpan(
                                    text: '1 habit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' today. You\'re mostly free\nafter 4 pm.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _iconTextItem(
                                  Icons.star,
                                  Colors.yellow,
                                  '4.7k steps',
                                ),
                                _iconTextItem(
                                  Icons.nightlight_round,
                                  Colors.blue,
                                  '6:37 hours',
                                ),
                                _iconTextItem(
                                  Icons.access_alarm,
                                  Colors.green,
                                  '36 min',
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: isExpanded ? expandedHeight : 0),
              height: _screenHeight(context) - (isExpanded ? expandedHeight : 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  dragStart = details.globalPosition.dy;
                },
                onVerticalDragUpdate: _handleDragUpdate,
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedPadding(
                        duration: const Duration(milliseconds: 300),
                        padding: !isExpanded
                            ? const EdgeInsets.only(
                                top: 100,
                                left: 20,
                                right: 20,
                              )
                            : const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            _buildTaskTile('Wake up', '08:00', Icons.sunny, Colors.yellow),
                            _buildTaskTile('Design Crit', '10:00'),
                            _buildTaskTile('Haircut with Vincent', '13:00'),
                            _buildTaskTile('Birthday party', '16:30'),
                            _buildTaskTile('Finish designs', '18:00'),
                            _buildTaskTile('Make pasta', '19:00'),
                            _buildTaskTile('Pushups ×100', '20:00'),
                            _buildTaskTile('Wind down', '21:00', Icons.nightlight_round, Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: _screenHeight(context) * 0.05,
              left: horizontalPadding,
              right: horizontalPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: _screenWidth(context) * 0.1,
                      fontWeight: FontWeight.bold,
                      color: isExpanded ? Colors.white : Colors.black,
                    ),
                    child: const Text('09'),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: _screenWidth(context) * 0.04,
                          color: isExpanded ? Colors.white70 : Colors.black54,
                        ),
                        child: const Text('Jan 24'),
                      ),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: _screenWidth(context) * 0.04,
                          color: isExpanded ? Colors.white60 : Colors.black54,
                        ),
                        child: const Text('Tuesday'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconTextItem(IconData icon, Color iconColor, String text) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: _screenWidth(context) * 0.04),
        SizedBox(width: _screenWidth(context) * 0.02),
        Text(
          text,
          style: TextStyle(
            color: Colors.white70,
            fontSize: _screenWidth(context) * 0.04,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskTile(String title, String time, [IconData? icon, Color? iconColor]) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _screenHeight(context) * 0.01,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor,
              size: _screenWidth(context) * 0.04,
            ),
            SizedBox(width: _screenWidth(context) * 0.02),
          ],
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: _screenWidth(context) * 0.04,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              color: Colors.black54,
              fontSize: _screenWidth(context) * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
