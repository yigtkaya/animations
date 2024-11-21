import 'package:animations/carusel_view.dart';
import 'package:animations/soft_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // set navigation buttons on android white
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.white));

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TaskListAnimation(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CaruselView(),
    );
  }
}

// write a stateful widget that has 5 images and a bouncy radio group
class ContainerApp extends StatefulWidget {
  const ContainerApp({super.key});

  @override
  _ContainerAppState createState() => _ContainerAppState();
}

class _ContainerAppState extends State<ContainerApp> {
  int selectedIndex = 2;
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
          child: ListView.separated(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: selectedIndex == index ? 200 : 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: selectedIndex == index ? Border.all(color: Colors.greenAccent, width: 2) : null,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(images[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
