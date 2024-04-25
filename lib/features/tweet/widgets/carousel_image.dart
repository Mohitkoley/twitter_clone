import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:twitter_clone/core/extension.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage({super.key, required this.images});
  final List<String> images;

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            FlutterCarousel(
              items: widget.images
                  .map((link) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: context.width,
                        margin: const EdgeInsets.all(10),
                        child: Image.network(link),
                      ))
                  .toList(),
              options: CarouselOptions(
                  showIndicator: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.images
                    .asMap()
                    .entries
                    .map((e) => Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                              .withOpacity(_currentIndex == e.key ? 0.9 : 0.4),
                        )))
                    .toList()),
            SizedBox(height: 10),
          ],
        )
      ],
    );
  }
}
