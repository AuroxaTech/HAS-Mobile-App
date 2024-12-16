import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_app/app_constants/app_icon.dart';
import 'package:property_app/custom_widgets/custom_button.dart';
import 'package:property_app/route_management/constant_routes.dart';

import '../../app_constants/app_sizes.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../models/propert_model/ladlord_property_model.dart';
import '../../services/property_services/get_property_services.dart';

class PropertyMap extends StatefulWidget {
  const PropertyMap({Key? key}) : super(key: key);

  @override
  State<PropertyMap> createState() => _PropertyMapState();
}

class _PropertyMapState extends State<PropertyMap> {
  final Completer<GoogleMapController> _mapController = Completer();
  final _markers = <Marker>{}.obs;
  RxBool isLoading = false.obs;
  final PagingController<int, Property> pagingController =
      PagingController(firstPageKey: 1);
  final PropertyServices propertyServices = PropertyServices();

  double? currentLatitude;
  double? currentLongitude;

  final RxBool _isHybrid = true.obs;

  @override
  void initState() {
    super.initState();
    loadCustomMarkerIcon();
    getProperties(1);
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly.
      Get.snackbar("Location", "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try to request permissions again.
        Get.snackbar("Location", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle accordingly.
      Get.snackbar("Location",
          "Location permissions are permanently denied, we cannot request permissions.");
      return;
    }
    try {
      await Geolocator.isLocationServiceEnabled();
      await Geolocator.checkPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double latitude = position.latitude;
      double longitude = position.longitude;
      setState(() {
        currentLatitude = latitude;
        currentLongitude = longitude;
      });

      _moveCameraToCurrentLocation();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _moveCameraToCurrentLocation() async {
    if (currentLatitude != null && currentLongitude != null) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLatitude!, currentLongitude!),
          zoom: 10,
        ),
      ));
    }
  }

  Future<void> getProperties(int pageKey,
      [Map<String, dynamic>? filters]) async {
    isLoading.value = true;
    try {
      var result =
          await propertyServices.getAllProperties(pageKey, filters: filters);
      isLoading.value = false;
      print("Result: $result");
      if (result['status'] == true) {
        final List<Property> newItems = (result['data']['data'] as List)
            .map((json) => Property.fromJson(json))
            .toList();

        final isLastPage =
            result['data']['current_page'] == result['data']['last_page'];
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
        updateMarkers(newItems);
      } else {
        pagingController.error = Exception('Failed to fetch properties');
      }
    } catch (error) {
      isLoading.value = false;
      pagingController.error = error.toString();
      Get.snackbar("Error", "Failed to load properties: $error");
    }
  }

  BitmapDescriptor? customIcon;

  Future<void> loadCustomMarkerIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), // Size is optional
        'assets/png/house_bitmap.png');
  }

  void updateMarkers(List<Property> properties) {
    Set<Marker> newMarkers = {};
    Random random = Random();

    for (var property in properties) {
      double? lat = double.tryParse(property.lat);
      double? lng = double.tryParse(property.long);

      // Check and correct invalid latitude or longitude ranges
      if (lat != null && (lat < -90 || lat > 90)) {
        print(
            "Latitude out of range, correcting for property ID: ${property.id}");
        lat = null; // Set to null to avoid using an invalid latitude
      }
      if (lng != null && (lng < -180 || lng > 180)) {
        print(
            "Longitude out of range, correcting for property ID: ${property.id}");
        lng = null; // Set to null to avoid using an invalid longitude
      }

      // Assume zero longitude might be incorrect, needs validation
      if (lng == 0.0) {
        print(
            "Longitude is zero, checking if misplaced for property ID: ${property.id}");
        // Implement logic to handle zero longitude or assume data error
        lng = null;
      }

      // Adding a small random offset to prevent exact overlap, only if coordinates are valid
      if (lat != null && lng != null) {
        double offsetLat = (random.nextDouble() - 0.5) * 0.0001;
        double offsetLng = (random.nextDouble() - 0.5) * 0.0001;
        lat += offsetLat;
        lng += offsetLng;

        final marker = Marker(
          markerId: MarkerId(property.id.toString()),
          icon: customIcon ?? BitmapDescriptor.defaultMarker,
          position: LatLng(lat, lng),
          onTap: () {
            _onMarkerTapped(property, LatLng(lat!, lng!));
          },
        );
        newMarkers.add(marker);
      }
    }
    _markers.value = newMarkers;
  }

  Widget? _customInfoWindow;
  OverlayEntry? _overlayEntry;
  LatLng? _markerLocation;

  void _onMarkerTapped(Property property, LatLng position) {
    _removeOverlay();
    _markerLocation = position;
    _overlayEntry = _createOverlayEntry(property);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(Property property) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + (size.width / 2),
        top: offset.dy + (size.height / 2),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 10)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppIcons.appLogo,
                    height: 50,
                  ), // Assuming imageURL is available in the property
                  h10,
                  customText(
                      text: property.address, fontWeight: FontWeight.bold),
                  h10,
                  customText(text: "Price: \$${property.amount}"),
                  h10,
                  CustomButton(
                    onTap: () {
                      _removeOverlay();
                      Get.toNamed(kAllPropertyDetailScreen,
                          arguments: property.id);
                    },
                    height: 30,
                    text: "Go",
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    print("Latitude==> ${currentLatitude} Longitude===> ${currentLongitude}");
    return Scaffold(
      body: Obx(() => GoogleMap(
            myLocationEnabled: true,
            mapType: _isHybrid.value ? MapType.hybrid : MapType.normal,
            initialCameraPosition: CameraPosition(
              target: currentLatitude != null && currentLongitude != null
                  ? LatLng(currentLatitude!, currentLongitude!)
                  : const LatLng(33.6995, 73.0363),
              zoom: 10,
            ),
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            onTap: (LatLng location) {
              _removeOverlay();
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 200),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.layers,
            color: Colors.black54,
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
      ),
    );
  }
}
