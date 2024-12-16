import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location_geocoder/location_geocoder.dart';
import 'package:property_app/app_constants/color_constants.dart';
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
  late CameraPosition kGooglePlex;
  RxBool isCard = false.obs;
  final TextEditingController _controller = TextEditingController();
  List<String> _autocompleteSuggestions = [];
  bool _isLoading = false;
  RxBool _isHybrid = true.obs;

  @override
  void initState() {
    super.initState();
    getCurrentLocation(); // Initialize camera with the current location
    kGooglePlex = CameraPosition(
      target: LatLng(lat.value, lng.value),
      zoom: 14.4746,
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location", "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Location", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Location",
          "Location permissions are permanently denied, we cannot request permissions.");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat.value = position.latitude;
      lng.value = position.longitude;

      _moveCameraToCurrentLocation();
      updateMarkerPin(lat.value, lng.value);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _moveCameraToCurrentLocation() async {
    if (lat.value != null && lng.value != null) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat.value, lng.value),
          zoom: 10,
        ),
      ));
    }
  }

  updateMarkerPin(double lat, double lng) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17)));
    setState(() {
      isFirstTime.value = false;
    });
  }

  Future<void> _getAutocomplete(String input) async {
    if (input.isEmpty) {
      setState(() {
        _autocompleteSuggestions = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    const String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    Map<String, dynamic> parameters = {
      'input': input,
      'key': AppUrls.mapKey,
      'components': 'country:ca',
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
      if (data != null && data['predictions'] != null) {
        setState(() {
          _autocompleteSuggestions = List<String>.from(
              data['predictions'].map((s) => s['description'] as String));
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

  Future<String?> fetchPostalCodeFallback(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      // Find a placemark that has a postal code
      for (Placemark place in placemarks) {
        if (place.postalCode != null) {
          return place.postalCode; // Return the first postal code found
        }
      }
      return null; // Return null if no postal code is found
    } catch (e) {
      print("Failed to get postal code: $e");
      return null;
    }
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
              "Search",
              style: TextStyle(fontSize: 16.7),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.layers,
            color: primaryColor,
          ),
          onPressed: () {
            Get.bottomSheet(
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.map),
                      title: const Text('Normal Map'),
                      onTap: () {
                        _isHybrid.value = false;
                        Get.back();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.satellite),
                      title: const Text('Satellite View'),
                      onTap: () {
                        _isHybrid.value = true;
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() => GoogleMap(
                            myLocationEnabled: true,
                            mapType: _isHybrid.value
                                ? MapType.hybrid
                                : MapType.normal,
                            initialCameraPosition: kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                            onCameraMove: (pos) async {
                              if (!isFirstTime.value) {
                                lat.value = pos.target.latitude;
                                lng.value = pos.target.longitude;
                                final LocatitonGeocoder geocoder =
                                    LocatitonGeocoder(AppUrls.mapKey);
                                var results =
                                    await geocoder.findAddressesFromCoordinates(
                                        Coordinates(lat.value, lng.value));
                                var fullAddress = results.first.addressLine;
                                var postal = results.first.postalCode;

                                postal ??= await fetchPostalCodeFallback(
                                    lat.value, lng.value);

                                var regex = RegExp(
                                    r'\b[\w+]+\d+[A-Z]+\d+\b|\b\d+/\d+\b',
                                    caseSensitive: false);
                                var cleanAddress =
                                    fullAddress!.replaceAll(regex, '').trim();

                                var parts = cleanAddress
                                    .split(',')
                                    .map((s) => s.trim())
                                    .where((s) => s.isNotEmpty)
                                    .toList();
                                String? area =
                                    parts.isNotEmpty ? parts[0] : null;
                                String? city =
                                    parts.length > 1 ? parts[1] : null;

                                String displayAddress = (area ?? '') +
                                    (city != null ? ', $city' : '');
                                setState(() {
                                  address = displayAddress;
                                  postalCode = postal ??
                                      "Unknown"; // Set to "Unknown" if postal is null
                                });
                              }
                            },
                          )),
                      Positioned(
                        top: 10.0,
                        left: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 24.0),
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
                                                _controller.clear();
                                                _autocompleteSuggestions
                                                    .clear();
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
                                          _controller.text =
                                              _autocompleteSuggestions[index];
                                          List<String> addressParts =
                                              _controller.text.split(', ');
                                          String desiredAddress =
                                              addressParts.take(2).join(', ');
                                          address = desiredAddress;
                                          _autocompleteSuggestions.clear();
                                        });

                                        final LocatitonGeocoder geocoder =
                                            LocatitonGeocoder(AppUrls.mapKey);
                                        final results = await geocoder
                                            .findAddressesFromQuery(
                                                _controller.text);

                                        if (results.isNotEmpty) {
                                          lat.value = results
                                              .first.coordinates.latitude!;
                                          lng.value = results
                                              .first.coordinates.longitude!;
                                          postalCode =
                                              (results.first.postalCode ??
                                                  await fetchPostalCodeFallback(
                                                      lat.value, lng.value))!;
                                          updateMarkerPin(lat.value, lng.value);
                                        }
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
                      if (selectedAddress == AddressType.Home)
                        addressType = AddressType.Home.name;
                      if (selectedAddress == AddressType.Office)
                        addressType = AddressType.Office.name;
                      if (selectedAddress == AddressType.Other)
                        addressType = AddressType.Other.name;

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
}
