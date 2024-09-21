import 'package:flutter/material.dart';

class CaruselView extends StatelessWidget {
  CaruselView({super.key});

  final images = [
    'https://assets.codepen.io/2585/fiddle-leaf.jpeg',
    'https://assets.codepen.io/2585/pink-princess.jpeg',
    'https://assets.codepen.io/2585/kara-eads-zcVArTF8Frs-unsplash.jpg',
    'https://assets.codepen.io/2585/pothos.jpeg',
    'https://assets.codepen.io/2585/rubber-tree.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resizable Containers'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: CarouselView(
            itemSnapping: true,
            itemExtent: 300,
            shrinkExtent: 150,
            overlayColor: const WidgetStatePropertyAll(Color.fromARGB(51, 198, 34, 34)),
            children: images
                .map((url) => Image.network(
                      url,
                      height: 60,
                      fit: BoxFit.fill,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
