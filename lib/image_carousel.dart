import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:math' as math;
import 'dart:ui';

class ImageCarouselPage extends StatefulWidget {
  const ImageCarouselPage({super.key});

  @override
  State<ImageCarouselPage> createState() => _ImageCarouselPageState();
}

class _ImageCarouselPageState extends State<ImageCarouselPage> {
  final PageController _pageController = PageController();
  final Map<int, PaletteGenerator> _paletteCache = {};
  double _currentPageValue = 0;
  bool _imagesPreloaded = false;

  final List<CarouselItem> _items = [
    CarouselItem(
      image: 'assets/cliff.jpg',
      title: 'Cliff',
    ),
    CarouselItem(
      image: 'assets/castle.jpg',
      title: 'Green',
    ),
    CarouselItem(
      image: 'assets/ocean.jpg',
      title: 'Ocean',
    ),
    CarouselItem(
      image: 'assets/berries.jpg',
      title: 'Berries',
    ),
    CarouselItem(
      image: 'assets/oxford_main.jpg',
      title: 'Old city',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
    _precacheColors();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPreloaded) {
      _precacheImages();
      _imagesPreloaded = true;
    }
  }

  void _onScroll() {
    setState(() {
      _currentPageValue = _pageController.page ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _precacheImages() {
    for (var item in _items) {
      precacheImage(AssetImage(item.image), context);
    }
  }

  Future<void> _precacheColors() async {
    for (int i = 0; i < _items.length; i++) {
      if (!_paletteCache.containsKey(i)) {
        final palette = await _extractPalette(_items[i].image);
        if (mounted) {
          setState(() {
            _paletteCache[i] = palette;
            print('Palette for image $i:');
            print('Dominant: ${palette.dominantColor?.color}');
            print('Vibrant: ${palette.vibrantColor?.color}');
            print('Muted: ${palette.mutedColor?.color}');
          });
        }
      }
    }
  }

  Future<PaletteGenerator> _extractPalette(String imagePath) async {
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        AssetImage(imagePath),
        size: const Size(200, 200),
        maximumColorCount: 20,
      );
      return palette;
    } catch (e) {
      print('Error extracting palette: $e');
      return PaletteGenerator.fromColors([
        PaletteColor(Colors.black, 1),
      ]);
    }
  }

  Color _getInterpolatedColor() {
    if (_paletteCache.isEmpty) return Colors.black;

    final currentPage = _currentPageValue.floor();
    final nextPage = currentPage + 1;

    if (nextPage >= _items.length || !_paletteCache.containsKey(nextPage)) {
      return _getBestColorFromPalette(_paletteCache[currentPage]);
    }

    final progress = _currentPageValue - currentPage;
    final currentColor = _getBestColorFromPalette(_paletteCache[currentPage]);
    final nextColor = _getBestColorFromPalette(_paletteCache[nextPage]);

    return Color.lerp(currentColor, nextColor, progress) ?? currentColor;
  }

  Color _getBestColorFromPalette(PaletteGenerator? palette) {
    if (palette == null) return Colors.black;

    // Try each available color type in priority order
    return palette.vibrantColor?.color ?? // Try vibrant first
        palette.dominantColor?.color ?? // Then dominant
        palette.mutedColor?.color ?? // Then muted
        palette.lightVibrantColor?.color ?? // Then light vibrant
        palette.darkVibrantColor?.color ?? // Then dark vibrant
        Colors.black; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _getInterpolatedColor();
    print('Current interpolated color: $currentColor');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.lerp(
                _currentPageValue.floor().isEven ? const Alignment(0.0, -0.2) : const Alignment(0.0, 0.2),
                _currentPageValue.ceil().isEven ? const Alignment(0.0, -0.2) : const Alignment(0.0, 0.2),
                _currentPageValue - _currentPageValue.floor())!,
            end: Alignment.lerp(
                _currentPageValue.floor().isEven ? const Alignment(0.0, 0.2) : const Alignment(0.0, -0.2),
                _currentPageValue.ceil().isEven ? const Alignment(0.0, 0.2) : const Alignment(0.0, -0.2),
                _currentPageValue - _currentPageValue.floor())!,
            colors: [
              currentColor.withOpacity(0.4),
              currentColor.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _buildCarouselItem(_items[index], index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItem item, int index) {
    double pageOffset = index - _currentPageValue;

    return Transform.translate(
      offset: Offset(-32 * pageOffset, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  height: 400,
                  width: double.infinity,
                  cacheWidth: 1200,
                  filterQuality: FilterQuality.medium,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 4),
                      child: Container(
                        height: 80,
                        alignment: Alignment.center,
                        color: Colors.black.withAlpha(20),
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselItem {
  final String image;
  final String title;

  CarouselItem({
    required this.image,
    required this.title,
  });
}
