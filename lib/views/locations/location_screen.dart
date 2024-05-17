import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:property_app/app_constants/color_constants.dart';
import 'package:http/http.dart' as http;
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
  RxString address = "".obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  final Completer<GoogleMapController> _mapController = Completer();


  updateMarkerPin(lat, lng) async {
    print("Lat : $lat , Lng : $lng");
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 17)));
    setState(() {});
    isFirstTime.value = false;
  }
  @override
  void initState() {
    kGooglePlex =  CameraPosition(
      target: LatLng(lat.value, lng.value),
      zoom: 14.4746,
    );
    // rootBundle.loadString('images/map_style.txt').then((string) {
    //   mapStyle = string;
    // });
    super.initState();

    updateMarkerPin(lat.value, lng.value);

  }
  late CameraPosition kGooglePlex;
  RxBool isCard = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                  decoration: const BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(color: Theme.of(context).cardColor),
                    // ],
                    // borderRadius: BorderRadius.circular(30.0),
                    // color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      // if (lat != null && lng != null) // Ensure lat and lng are not null
                      //   // GooglePlaceAutoCompleteTextField(
                      //   //   textEditingController: searchController.value,
                      //   //   googleAPIKey: Common.apiKey!, // Replace with your actual Google API Key
                      //   //   inputDecoration: const InputDecoration(
                      //   //     hintText: 'Enter Location',
                      //   //     border: InputBorder.none,
                      //   //     suffixIcon: Icon(Icons.search),
                      //   //   ),
                      //   //   debounceTime: 800,
                      //   //   countries:  [_countryCode.toLowerCase(),],
                      //   //   isLatLngRequired: true,
                      //   //   getPlaceDetailWithLatLng: (prediction) {
                      //   //     print("Place Details: ${prediction.description}, Lat: ${prediction.lat}, Lng: ${prediction.lng}");
                      //   //   },
                      //   //   itemClick: (Prediction prediction) {
                      //   //     setState(() {
                      //   //       List<String> addressParts = prediction.description?.split(', ') ?? [];
                      //   //       String desiredAddress = addressParts.take(2).join(', '); // Include the first two parts
                      //   //
                      //   //       searchController.value.text = prediction.description ?? "";
                      //   //       address.value = desiredAddress;
                      //   //       print(address.value);
                      //   //       // Optionally, move map camera here if using a Google Map
                      //   //     });
                      //   //   },
                      //   //   itemBuilder: (context, index, Prediction prediction) {
                      //   //     return ListTile(
                      //   //       leading: const Icon(Icons.location_on),
                      //   //       title: Text(prediction.description ?? ""),
                      //   //     );
                      //   //   },
                      //   //   seperatedBuilder: const Divider(),
                      //   //   isCrossBtnShown: true,
                      //   //   containerHorizontalPadding: 10,
                      //   // ),
                      //   GooglePlacesAutocompleteWidget(
                      //     googleAPIKey: Common.apiKey!,
                      //     countryCode: "pk", latitude: Common.currentLat!, longitude: Common.currentLng!,),
                    ],
                  )
                //
                // MapAutoCompleteField(
                //   googleMapApiKey: Common.apiKey!,
                //   controller: searchController.value,
                //   hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: kHintColor),
                //   itemBuilder: (BuildContext context, suggestion) {
                //     return ListTile(
                //       leading: Icon(Icons.location_on, color: kTextColor),
                //       title: Text(suggestion.description, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
                //     );
                //   },
                //   onSuggestionSelected: (suggestion) async {
                //     searchController.value.text = suggestion.description;
                //     if (searchController.value.text.isNotEmpty) {
                //       print(searchController.value.text);
                //       final LocatitonGeocoder geocoder = LocatitonGeocoder(Common.apiKey!);
                //       final result = await geocoder.findAddressesFromQuery(searchController.value.text);
                //       lat.value = result.first.coordinates.latitude!;
                //       lng.value = result.first.coordinates.longitude!;
                //       await updateMarkerPin(lat.value, lng.value);
                //     }
                //
                //     address.value = suggestion.description;
                //   },
                //   inputDecoration: InputDecoration(
                //     fillColor: Theme.of(context).cardColor,
                //     contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                //     icon: ImageIcon(AssetImage('assets/images/icons/ic_search.png'), color: Theme.of(context).secondaryHeaderColor, size: 16),
                //     filled: true,
                //     suffixIcon: searchController.value.text.isNotEmpty
                //         ? InkWell(
                //       onTap: () async {
                //         searchController.value.text = '';
                //         address.value = '';
                //         lat.value = 0.0;
                //         lng.value = 0.0;
                //         await updateMarkerPin(double.parse(Common.currentLat!), double.parse(Common.currentLng!));
                //       },
                //       child: Icon(Icons.close),
                //     )
                //         : Icon(Icons.close, color: Colors.transparent),
                //     hintText: AppLocalizations.of(context)!.enterLocation,
                //     hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: kHintColor),
                //     labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: kHintColor),
                //     border: InputBorder.none,
                //   ),
                // ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Expanded(
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
                              var fullAddress = results.first.addressLine;  // Get the full address line

                              // Define a regex pattern to remove Plus Codes and overly specific details
                              var regex = RegExp(r'\b[\w+]+\d+[A-Z]+\d+\b|\b\d+/\d+\b', caseSensitive: false);
                              var cleanAddress = fullAddress!.replaceAll(regex, '').trim(); // Remove unwanted patterns

                              // Further process the string to extract meaningful parts
                              var parts = cleanAddress.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                              String? area = parts.isNotEmpty ? parts[0] : null;
                              String? city = parts.length > 1 ? parts[1] : null;

                              String displayAddress = (area ?? '') + (city != null ? ', $city' : '');
                              setState(() {
                                this.address.value = displayAddress;
                              });
                            }
                          },
                        ),

                        Positioned(
                          top: 10.0, // Adjust the position based on your AppBar height or UI design
                          left: 10,
                          right: 10,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 24.0),
                                decoration:  BoxDecoration(

                                  boxShadow: [
                                    BoxShadow(color: Theme.of(context).cardColor),
                                  ],
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _controller,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300
                                      ),
                                      decoration: InputDecoration(
                                          hintText: 'Search Places',

                                          suffixIcon: _isLoading ? CircularProgressIndicator() : IconButton(onPressed: (){
                                            setState(() {

                                              print(address.value);
                                              _controller.clear();
                                              _autocompleteSuggestions.clear();
                                            });
                                          }, icon: const Icon(Icons.close)),
                                          border: InputBorder.none
                                      ),

                                      onChanged: _getAutocomplete,
                                    ),
                                    ListView.builder(
                                      itemCount: _autocompleteSuggestions.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(_autocompleteSuggestions[index], style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300
                                          ),),
                                          onTap: () {
                                            setState(() {
                                              _controller.text = _autocompleteSuggestions[index];
                                              List<String> addressParts = _controller.text.split(', ') ?? [];
                                              String desiredAddress = addressParts.take(2).join(', '); // Include the first two parts
                                              // searchController.value.text = prediction.description ?? "";
                                              address.value = desiredAddress;
                                              _autocompleteSuggestions.clear(); // Clear suggestions after selection
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                )
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
                            this.address.value,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                  BottomBar(
                    text: "Continue",
                    onTap: () async {
                      if (!isCard.value) {
                        isCard.value = true;
                      } else {

                        String addressType = AddressType.Other.name;
                        if (selectedAddress == AddressType.Home) addressType = AddressType.Home.name;
                        if (selectedAddress == AddressType.Office) addressType = AddressType.Office.name;
                        if (selectedAddress == AddressType.Other) addressType = AddressType.Other.name;

                        Map<String, dynamic> map = {
                          "address": address.value,
                          "latitude": lat.value.toString(),
                          "longitude": lng.value.toString(),
                          "addressType": addressType,
                          "createdOn": DateTime.now().millisecondsSinceEpoch,
                        };

                        Get.back();
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
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
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
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
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
    ''');
      // mapStyleController!.setMapStyle(mapStyle);
    });
  }

  final TextEditingController _controller = TextEditingController();
  List<String> _autocompleteSuggestions = [];
  bool _isLoading = false;

  // Function to call Google Places Autocomplete API
  Future<void> _getAutocomplete(String input) async {
    if (input.isEmpty) {
      setState(() {
        _autocompleteSuggestions = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    // Ensure the countryCode is correctly set to the ISO 3166-1 Alpha-2 code.
    // For example, 'us' for the United States, 'pk' for Pakistan.

    const String url = 'https://places.googleapis.com/v1/places:autocomplete';
    Map<String, dynamic> body = {
      'input': input,
      "locationBias": {
        "circle": {
          "center": {
            "latitude": lat.value,
            "longitude": lng.value
          },
          "radius": 500.0
        }
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': AppUrls.mapKey,
        },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);
      print(data);
      if (data != null && data['suggestions'] != null) {
        setState(() {
          _autocompleteSuggestions = List<String>.from(
              data['suggestions'].map((s) => s['placePrediction']['text']['text'] as String)
          );
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
        height: 60.0,
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
