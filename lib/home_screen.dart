import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quotes/constant.dart';
import 'package:quotes/quotes.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? imageList;
  int? imageNumber = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFromUnplash();
  }

  var accessKey = '';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: imageList != null
            ? Stack(
                children: [
                  AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: BlurHash(
                      key: ValueKey(imageList![imageNumber!]['blur_hash']),
                      hash: imageList![imageNumber!]['blur_hash'],
                      duration: Duration(milliseconds: 500),
                      image: imageList![imageNumber!]['urls']['regular'],
                      curve: Curves.easeInOut,
                      imageFit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  Container(
                    width: width,
                    height: height,
                    child: SafeArea(
                      child: CarouselSlider.builder(
                          itemCount: quotesList.length,
                          itemBuilder: (context, index1, index2) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    quotesList[index1][kQuote],
                                    style: kQuoteTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '- ${quotesList[index1][kAuthor]} -',
                                  style: kAuthorTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                          options: CarouselOptions(
                            scrollDirection: Axis.vertical,
                            pageSnapping: true,
                            initialPage: 0,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              HapticFeedback.lightImpact();
                              imageNumber = index;
                              setState(() {});
                            },
                          )),
                    ),
                  ),
                  Positioned(
                      top: 50,
                      right: 30,
                      child: Row(
                        children: [
                          Text(
                            '${imageList![imageNumber!]['user']['username']}',
                            style: kAuthorTextStyle,
                          ),
                          Text(
                            ' On ',
                            style: kAuthorTextStyle,
                          ),
                          Text(
                            'Unplash',
                            style: kAuthorTextStyle,
                          )
                        ],
                      ))
                ],
              )
            : Container(
                width: width,
                height: height,
                color: Colors.black.withOpacity(0.6),
                child: Container(
                  width: 100,
                  height: 100,
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                  ),
                ),
              ));
  }

  void getImageFromUnplash() async {
    var url =
        'https://api.unsplash.com/search/photos?per_page=30&query=nature&order_by=relevant&client_id=$accessKey';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var unsplashData = json.decode(response.body);
    imageList = unsplashData['results'];
    setState(() {});
  }
}
