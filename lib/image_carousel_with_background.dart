import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:math' as math;

final class ImageCarouselView extends StatefulWidget {
  const ImageCarouselView({
    super.key,
  });

  @override
  State<ImageCarouselView> createState() => _ImageCarouselViewState();
}

class _ImageCarouselViewState extends State<ImageCarouselView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;
  int _nextIndex = 0;
  double _scrollProgress = 0.0;
  final Map<String, List<Color>> _imageColors = {};
  bool _isScrolling = false;
  double _page = 0;

  final List<String> _assetImages = [
    'assets/cliff.jpg',
    'assets/ocean.jpg',
    'assets/castle.jpg',
    'assets/berries.jpg',
    'assets/oxford_main.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _loadImageColors();
  }

  Future<void> _loadImageColors() async {
    for (final imagePath in _assetImages) {
      final colors = await _extractColorsFromImage(imagePath);
      setState(() {
        _imageColors[imagePath] = colors;
      });
    }
  }

  Future<List<Color>> _extractColorsFromImage(String imagePath) async {
    final imageProvider = AssetImage(imagePath);
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 5,
    );

    final colors = [
      paletteGenerator.dominantColor?.color,
      paletteGenerator.vibrantColor?.color,
      paletteGenerator.mutedColor?.color,
    ].where((color) => color != null).map((color) => color!).toList();

    // If we don't have enough colors, add some defaults
    if (colors.length < 2) {
      colors.add(Colors.black);
    }

    return colors;
  }

  Color _interpolateColors(Color a, Color b, double t) {
    return Color.lerp(a, b, t) ?? a;
  }

  List<Color> _interpolateColorList(List<Color> a, List<Color> b, double t) {
    final maxLength = math.max(a.length, b.length);
    final result = <Color>[];

    for (var i = 0; i < maxLength; i++) {
      final colorA = i < a.length ? a[i] : a.last;
      final colorB = i < b.length ? b[i] : b.last;
      result.add(_interpolateColors(colorA, colorB, t));
    }

    return result;
  }

  void _updatePage(double page) {
    final normalizedPage = page % _assetImages.length;
    setState(() {
      _page = normalizedPage;
      _currentIndex = normalizedPage.floor() % _assetImages.length;
      _nextIndex = (normalizedPage.ceil()) % _assetImages.length;
      _scrollProgress = normalizedPage - normalizedPage.floor();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reverse().then((_) => Navigator.of(context).pop());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildAnimatedGradientBackground(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: _assetImages.length,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.width * 0.8,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      onScrolled: (value) {
                        if (value != null) _updatePage(value);
                      },
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return _buildMainImage(_assetImages[index]);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildIndicators(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedGradientBackground() {
    final currentColors = _imageColors[_assetImages[_currentIndex]] ?? [Colors.black, Colors.black.withOpacity(0.7)];
    final nextColors = _imageColors[_assetImages[_nextIndex]] ?? [Colors.black, Colors.black.withOpacity(0.7)];

    // When transitioning from last to first image
    final progress = _currentIndex == _assetImages.length - 1 && _nextIndex == 0
        ? _scrollProgress
        : _currentIndex == 0 && _nextIndex == _assetImages.length - 1
            ? 1 - _scrollProgress
            : _scrollProgress;

    final interpolatedColors = _interpolateColorList(currentColors, nextColors, progress);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: interpolatedColors,
          stops: List.generate(
            interpolatedColors.length,
            (index) => index / (interpolatedColors.length - 1),
          ).map((value) => value.toDouble()).toList(),
        ),
      ),
    );
  }

  Widget _buildMainImage(String assetPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _assetImages.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _carouselController.animateToPage(entry.key),
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(
                _currentIndex == entry.key ? 0.9 : 0.4,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
