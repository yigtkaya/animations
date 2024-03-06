import 'package:flutter/material.dart';

class ContainerApp extends StatefulWidget {
  @override
  _ContainerAppState createState() => _ContainerAppState();
}

class _ContainerAppState extends State<ContainerApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int selectedIndex = 2;
  final images = [
    'https://assets.codepen.io/2585/fiddle-leaf.jpeg',
    'https://assets.codepen.io/2585/pink-princess.jpeg',
    'https://assets.codepen.io/2585/kara-eads-zcVArTF8Frs-unsplash.jpg',
    'https://assets.codepen.io/2585/pothos.jpeg',
    'https://assets.codepen.io/2585/rubber-tree.webp',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resizable Containers'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: ListView.separated(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (selectedIndex == index) return;

                  setState(() {
                    selectedIndex = index;
                  });
                  if (_controller.isCompleted || _controller.isAnimating) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(selectedIndex == index ? _controller.value * 10 : 0, 0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: selectedIndex == index ? 300 : 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: selectedIndex == index
                              ? Border.all(color: Colors.greenAccent, width: 2)
                              : null,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(images[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
