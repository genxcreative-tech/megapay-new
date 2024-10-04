import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeHeroSlider extends StatefulWidget {
  const HomeHeroSlider({super.key});

  @override
  State<HomeHeroSlider> createState() => _HomeHeroSliderState();
}

class _HomeHeroSliderState extends State<HomeHeroSlider> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
     final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height/4,
      width: width,
      child: FlutterCarousel(items: [
        Card(
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(image: NetworkImage("https://images.pexels.com/photos/920382/pexels-photo-920382.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        ),
        Card(
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(image: NetworkImage("https://images.pexels.com/photos/6331258/pexels-photo-6331258.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        ),
        Card(
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(image: NetworkImage("https://images.pexels.com/photos/210705/pexels-photo-210705.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        )
      ], options: FlutterCarouselOptions(
        viewportFraction: 0.950,
        autoPlay: true,
        disableCenter: false,
        enlargeCenterPage: true
      ))
    );
  }
}