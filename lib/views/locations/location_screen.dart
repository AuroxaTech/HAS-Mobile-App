import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:http/http.dart' as http;
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/utils/api_urls.dart';

enum AddressType { Home, Office, Other }

AddressType selectedAddress = AddressType.Other;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  RxBool isFirstTime = true.obs;

  RxDouble lat = 33.6995.obs, lng = 73.0363.obs;
  GoogleMapController? mapStyleController;
  String address = "";
  String postalCode = "";
  Rx<TextEditingController> searchController = TextEditingController().obs;

  final Completer<GoogleMapController> _mapController = Completer();

  updateMarkerPin(double lat, double lng) async {
    print("Lat : $lat , Lng : $lng");
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 17)));
    setState(() {});
    isFirstTime.value = false;
  }

  void _returnSelectedLocation() {
    final selectedLocation = {
      'address': address,
      'latitude': lat.value,
      'longitude': lng.value,
      'postalCode': postalCode,
    };
    Navigator.pop(context, selectedLocation);
  }

  @override
  void initState() {
    kGooglePlex = CameraPosition(
      target: LatLng(lat.value, lng.value),
      zoom: 14.4746,
    );
    super.initState();

    updateMarkerPin(lat.value, lng.value);
  }

  late CameraPosition kGooglePlex;
  RxBool isCard = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            titleSpacing: 0.0,
            title: const Text(
              "Hangi",
              style: TextStyle(fontSize: 16.7),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: kGooglePlex,
                        onMapCreated: onMapCreated,
                        onCameraMove: (pos) async {
                          if (!isFirstTime.value) {
                            lat.value = pos.target.latitude;
                            lng.value = pos.target.longitude;
                            final LocatitonGeocoder geocoder = LocatitonGeocoder(AppUrls.mapKey);
                            var results = await geocoder.findAddressesFromCoordinates(Coordinates(lat.value, lng.value));
                            var fullAddress = results.first.addressLine;
                            var postal = results.first.postalCode;

                            print('Full Address: $fullAddress'); // Debugging
                            print('Postal Code: $postal'); // Debugging

                            if (postal == null) {
                              // Fallback to Google Geocoding API if postal code is null
                              postal = await fetchPostalCodeFallback(lat.value, lng.value);
                            }

                            var regex = RegExp(r'\b[\w+]+\d+[A-Z]+\d+\b|\b\d+/\d+\b', caseSensitive: false);
                            var cleanAddress = fullAddress!.replaceAll(regex, '').trim();

                            var parts = cleanAddress.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                            String? area = parts.isNotEmpty ? parts[0] : null;
                            String? city = parts.length > 1 ? parts[1] : null;

                            String displayAddress = (area ?? '') + (city != null ? ', $city' : '');
                            setState(() {
                              address = displayAddress;
                              postalCode = postal ?? "Unknown"; // Set to "Unknown" if postal is null
                            });

                            print('Assigned Address: $address'); // Debugging
                            print('Assigned Postal Code: $postalCode'); // Debugging
                          }
                        },
                      ),
                      Positioned(
                        top: 10.0,
                        left: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: whiteColor,
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _controller,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: 'Search Places',
                                    suffixIcon: _isLoading
                                        ? const CircularProgressIndicator()
                                        : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          print(address);
                                          _controller.clear();
                                          _autocompleteSuggestions.clear();
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: _getAutocomplete,
                                ),
                                ListView.builder(
                                  itemCount: _autocompleteSuggestions.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        _autocompleteSuggestions[index],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          _controller.text = _autocompleteSuggestions[index];
                                          List<String> addressParts = _controller.text.split(', ');
                                          String desiredAddress = addressParts.take(2).join(', ');
                                          address = desiredAddress;
                                          _autocompleteSuggestions.clear();
                                        });

                                        final LocatitonGeocoder geocoder = LocatitonGeocoder(AppUrls.mapKey);
                                        final results = await geocoder.findAddressesFromQuery(_controller.text);

                                        if (results.isNotEmpty) {
                                          lat.value = results.first.coordinates.latitude!;
                                          lng.value = results.first.coordinates.longitude!;
                                          postalCode = (results.first.postalCode ?? await fetchPostalCodeFallback(lat.value, lng.value))!;
                                          updateMarkerPin(lat.value, lng.value);
                                        }

                                        print('Selected Address: $address'); // Debugging
                                        print('Selected Postal Code: $postalCode'); // Debugging
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Image.asset('assets/png/map_pin.png', scale: 2.5),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/png/map_pin.png', scale: 2.5),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomButton(
                    width: double.infinity,
                    text: "Continue",
                    onTap: () async {
                      String addressType = AddressType.Other.name;
                      if (selectedAddress == AddressType.Home) addressType = AddressType.Home.name;
                      if (selectedAddress == AddressType.Office) addressType = AddressType.Office.name;
                      if (selectedAddress == AddressType.Other) addressType = AddressType.Other.name;

                      Map<String, dynamic> map = {
                        "address": address,
                        "latitude": lat.value.toString(),
                        "longitude": lng.value.toString(),
                        "addressType": addressType,
                        "createdOn": DateTime.now().millisecondsSinceEpoch,
                      };

                      _returnSelectedLocation();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLocationSelected(String selectedLocation) {
    Get.back(result: selectedLocation);
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController.complete(controller);
      mapStyleController = controller;
      controller.setMapStyle('''
  [
    {
      "featureType": "all",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#7c93a3"
        },
        {
          "lightness": "-10"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "geometry",
      "stylers": [
        {
          "visibility": "simplified"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "all",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.province",
      "elementType": "all",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {
          "visibility": "simplified"
        },
        {
          "color": "#e9e5dc"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "on"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#a5b076"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text",
      "stylers": [
        {
          "visibility": "simplified"
        },
        {
          "color": "#447530"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f9d29d"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#f9d29d"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "simplified"
        },
        {
          "color": "#82868c"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#a6cbe3"
        }
      ]
    }
  ]
  ''');
    });
  }

  final TextEditingController _controller = TextEditingController();
  List<String> _autocompleteSuggestions = [];
  bool _isLoading = false;

  Future<void> _getAutocomplete(String input) async {
    if (input.isEmpty) {
      setState(() {
        _autocompleteSuggestions = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    const String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    Map<String, dynamic> parameters = {
      'input': input,
      'key': AppUrls.mapKey,
      'components': 'country:pk',
      'language': 'en',
    };

    if (lat.value != null && lng.value != null) {
      parameters.addAll({
        "location": "${lat.value},${lng.value}",
        "radius": "500",
      });
    }

    try {
      final response = await http.get(
        Uri.parse(url).replace(queryParameters: parameters),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      print(data);
      if (data != null && data['predictions'] != null) {
        setState(() {
          _autocompleteSuggestions = List<String>.from(data['predictions'].map((s) => s['description'] as String));
          _isLoading = false;
        });
      } else {
        setState(() {
          _autocompleteSuggestions = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Failed to fetch suggestions: $e");
      }
      }

  Future<String?> fetchPostalCodeFallback(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      // Find a placemark that has a postal code
      for (Placemark place in placemarks) {
        if (place.postalCode != null) {
          return place.postalCode;  // Return the first postal code found
        }
      }
      return null;  // Return null if no postal code is found
    } catch (e) {
      print("Failed to get postal code: $e");
      return null;
    }
  }

  // Future<String?> fetchPostalCodeFallback(double lat, double lng) async {
  //   const String url = 'https://maps.googleapis.com/maps/api/geocode/json';
  //   Map<String, dynamic> parameters = {
  //     'latlng': '$lat,$lng',
  //     'key': AppUrls.mapKey,
  //   };
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url).replace(queryParameters: parameters),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     final data = json.decode(response.body);
  //     print('Geocoding API Fallback Response: $data'); // Debugging
  //
  //     if (data['results'] != null && data['results'].isNotEmpty) {
  //       for (var component in data['results'][0]['address_components']) {
  //         if (component['types'].contains('postal_code')) {
  //           return component['long_name'];
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("Failed to fetch postal code: $e");
  //   }
  //   return null;
  // }
}

class BottomBar extends StatelessWidget {
  final Function onTap;
  final String? text;
  final Color? color;
  final Color? textColor;

  BottomBar({required this.onTap, required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(color: color ?? primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        height: 55.0,
        child: Center(
          child: Text(
            text!,
            style: textColor != null ? TextStyle(color: Colors.black) : TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
