import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:iplocation/components/my_textfield.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:simple_animated_button/elevated_layer_button.dart';

class IpGeoPage extends StatefulWidget {
  @override
  _IpGeoPageState createState() => _IpGeoPageState();
}

class _IpGeoPageState extends State<IpGeoPage> {
  final TextEditingController _controller = TextEditingController();
  final CardSwiperController _swiperController = CardSwiperController();
  Map<String, dynamic> _data = {};
  bool _isLoading = false;

  List<Widget> _cards = [];

  Future<void> fetchData(String ip) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://ip-geolocation-ipwhois-io.p.rapidapi.com/json/?ip=$ip'),
      headers: {
        'X-Rapidapi-Key': '',
        'X-Rapidapi-Host': 'ip-geolocation-ipwhois-io.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _data = data;
        _isLoading = false;
        _cards = [
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[100],
              child: Center(child: Text('IP: ${_data['ip']}')),
            ),
          ),
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[200],
              child: Center(child: Text('Country: ${_data['country']}')),
            ),
          ),
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[300],
              child: Center(child: Text('Region: ${_data['region']}')),
            ),
          ),
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[400],
              child: Center(child: Text('City: ${_data['city']}')),
            ),
          ),
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[500],
              child: Center(child: Text('Latitude: ${_data['latitude']}')),
            ),
          ),
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[600],
              child: Center(child: Text('Longitude: ${_data['longitude']}')),
            ),
          ),
          Container(
            height: 150, // Set the desired height
            child: Card(
              color: Colors.blue[700],
              child: Center(child: Text('ISP: ${_data['isp']}')),
            ),
          ),
        ];
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23.0),
                child: MyTextfield(
                    hintText: "Enter IP address here",
                    obscureText: false,
                    controller: _controller),
              ),

              const SizedBox(height: 20),
              ElevatedLayerButton(
                onClick: () {
                  fetchData(_controller.text);
                },
                buttonHeight: 60,
                buttonWidth: 270,
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.ease,
                topDecoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                ),
                topLayerChild: Text("Get IP details"),
                baseDecoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : _data.isNotEmpty
                      ? SizedBox(
                          height: screenHeight / 2,
                          child: CardSwiper(
                            controller: _swiperController,
                            cardsCount: _cards.length,
                            cardBuilder: (context,
                                index,
                                horizontalThresholdPercentage,
                                verticalThresholdPercentage) {
                              return _cards[index];
                            },
                            onSwipe: (previousIndex, currentIndex, direction) {
                              debugPrint(
                                'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
                              );
                              return true;
                            },
                            onUndo: (previousIndex, currentIndex, direction) {
                              debugPrint(
                                'The card $currentIndex was undone from the ${direction.name}',
                              );
                              return true;
                            },
                          ),
                        )
                      : SizedBox(
                          height: screenHeight / 2,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No data available yet ??!'),
                                Lottie.asset('assets/ipsearch.json'),
                              ],
                            ),
                          ),
                        ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedLayerButton(
                      onClick: () =>
                          _swiperController.swipe(CardSwiperDirection.left),
                      buttonHeight: 60,
                      buttonWidth: 60,
                      animationDuration: const Duration(milliseconds: 200),
                      animationCurve: Curves.ease,
                      topDecoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                      topLayerChild: Icon(Icons.keyboard_arrow_left),
                      baseDecoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    ElevatedLayerButton(
                      onClick: _swiperController.undo,
                      buttonHeight: 60,
                      buttonWidth: 60,
                      animationDuration: const Duration(milliseconds: 200),
                      animationCurve: Curves.ease,
                      topDecoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                      topLayerChild: Icon(Icons.rotate_left),
                      baseDecoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    ElevatedLayerButton(
                      onClick: () =>
                          _swiperController.swipe(CardSwiperDirection.right),
                      buttonHeight: 60,
                      buttonWidth: 60,
                      animationDuration: const Duration(milliseconds: 200),
                      animationCurve: Curves.ease,
                      topDecoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                      topLayerChild: Icon(Icons.keyboard_arrow_right),
                      baseDecoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Add some padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
