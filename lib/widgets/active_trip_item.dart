import 'package:animations/mixins/active_trip_item_mixin.dart';
import 'package:flutter/material.dart';

class ActiveTripItem extends StatefulWidget {
  const ActiveTripItem({super.key});

  @override
  State<ActiveTripItem> createState() => _ActiveTripItemState();
}

class _ActiveTripItemState extends State<ActiveTripItem> with SingleTickerProviderStateMixin, ActiveTripItemMixin {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        16,
      ),
      onTap: () {},
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                16,
              ),
              gradient: LinearGradient(
                colors: const [
                  Colors.red,
                  Colors.blue,
                ],
                begin: topAlignmentAnimation.value,
                end: bottomAlignmentAnimation.value,
              ),
            ),
          );
        },
      ),
    );
  }
}
