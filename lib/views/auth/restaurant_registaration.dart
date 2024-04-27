// ignore_for_file: prefer_collection_literals

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:zapizza/common/app_style.dart';
import 'package:zapizza/common/background_container.dart';
import 'package:zapizza/common/custom_button.dart';
import 'package:zapizza/common/reusable_text.dart';
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/controllers/restaurant_controller.dart';
import 'package:zapizza/controllers/uploader_controller.dart';
import 'package:zapizza/models/restaurant_request.dart';
import 'package:zapizza/views/auth/widgets/email_textfield.dart';
import 'package:zapizza/views/auth/widgets/map_btn.dart';

class RestaurantRegistration extends StatefulWidget {
  const RestaurantRegistration({super.key});

  @override
  State<RestaurantRegistration> createState() => _RestaurantRegistrationState();
}

class _RestaurantRegistrationState extends State<RestaurantRegistration> {
  final box = GetStorage();
  late final PageController _pageController = PageController(initialPage: 0);
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  List<dynamic> _placeList = [];
  List<dynamic> _selectedPlaceList = [];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _title.dispose();
    _time.dispose();
    _address.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  LatLng? _selectedLocation;

  void _getPlaceDetails(String placeId) async {
    var placeDetailsUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey');

    final response = await http.get(placeDetailsUrl);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      final lat = responseBody['result']['geometry']['location']['lat'];
      final lng = responseBody['result']['geometry']['location']['lng'];

      final address = responseBody['result']['formatted_address'];

      String postalCode = '';
      final addressComponent = responseBody['result']['address_components'];

      for (var component in addressComponent) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _selectedLocation = LatLng(lat, lng);
        _searchController.text = address;
        _postalCode.text = postalCode;
        _placeList = [];
        moveToSelection();
      });
    }
  }

  void moveToSelection() {
    if (_selectedLocation != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _selectedLocation!, zoom: 15)));
    }
  }

  void _onSearchChanged(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&key=$googleApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        setState(() {
          _placeList = [];
        });
      }
    }
  }

  void _onMarkerDragEnd(LatLng coords) async {
    setState(() {
      _selectedLocation = coords;
    });

    var reverseGeoCodingUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coords.latitude},${coords.longitude}&key=$googleApiKey');

    final response = await http.get(reverseGeoCodingUrl);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      final address = responseBody['results'][0]['formatted_address'];

      String postalCode = '';

      final addressComponent = responseBody['results'][0]['address_components'];

      for (var component in addressComponent) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _searchController.text = address;
        _postalCode.text = postalCode;
      });
    } else {
      debugPrint("Error getting thhe details");
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploader = Get.put(UploaderController());
    final controller = Get.put(RestaurantController());
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MapBtn(
              text: "Back",
              onTap: () {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
            ),
            ReusableText(
              text: "Register Restaurant",
              style: appStyle(13, kLightWhite, FontWeight.w600),
            ),
            MapBtn(
              text: "Next",
              onTap: () {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: hieght,
        width: width,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BackGroundContainer(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                        target: _selectedLocation ??
                            const LatLng(37.42796133580664, -122.085749655962),
                        zoom: 15),
                    markers: _selectedLocation == null
                        ? Set.of([])
                        : Set.of(
                            [
                              Marker(
                                markerId: const MarkerId('Your Location'),
                                position: _selectedLocation!,
                                draggable: true,
                                onDragEnd: (LatLng position) {
                                  _onMarkerDragEnd(position);
                                },
                              )
                            ],
                          ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        color: Colors.white,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                              hintStyle: appStyle(13, kGray, FontWeight.normal),
                              hintText: 'Search for your address...'),
                        ),
                      ),
                      _placeList.isEmpty
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: ListView(
                              children: List.generate(_placeList.length, (i) {
                                return Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Text(
                                      _placeList[i]['description'],
                                      style: appStyle(
                                        12,
                                        kGray,
                                        FontWeight.normal,
                                      ),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    onTap: () {
                                      _getPlaceDetails(
                                          _placeList[i]['place_id']);
                                      _selectedPlaceList.add(_placeList[i]);
                                    },
                                  ),
                                );
                              }),
                            ))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: hieght,
              child: BackGroundContainer(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Image One
                        GestureDetector(
                          onTap: () {
                            uploader.pickImage('logo');
                          },
                          child: Obx(() => Container(
                                height: 120.h,
                                width: width / 2.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: kGrayLight),
                                ),
                                child: uploader.logoUrl == ''
                                    ? Center(
                                        child: ReusableText(
                                            text: "Upload Logo",
                                            style: appStyle(
                                                16, kDark, FontWeight.w600)),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Image.network(
                                          uploader.logoUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              )),
                        ),

                        //Image Two

                        GestureDetector(
                          onTap: () {
                            uploader.pickImage('cover');
                          },
                          child: Obx(() => Container(
                                height: 120.h,
                                width: width / 2.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: kGrayLight),
                                ),
                                child: uploader.coverUrl == ''
                                    ? Center(
                                        child: ReusableText(
                                            text: "Upload Cover",
                                            style: appStyle(
                                                16, kDark, FontWeight.w600)),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Image.network(
                                          uploader.coverUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    EmailTextField(
                      prefixIcon: Icon(
                        AntDesign.edit,
                        size: 14.sp,
                        color: kGray,
                      ),
                      controller: _title,
                      hintText: 'Restaurant Title',
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    EmailTextField(
                      prefixIcon: Icon(
                        AntDesign.edit,
                        size: 14.sp,
                        color: kGray,
                      ),
                      controller: _time,
                      hintText: 'Business Hrs (08:00 AM - 10:00 PM)',
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    EmailTextField(
                      prefixIcon: Icon(
                        AntDesign.edit,
                        size: 14.sp,
                        color: kGray,
                      ),
                      controller: _postalCode,
                      hintText: 'Postal Code',
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    EmailTextField(
                      prefixIcon: Icon(
                        AntDesign.edit,
                        size: 14.sp,
                        color: kGray,
                      ),
                      controller: _searchController,
                      hintText: 'Address',
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomButton(
                      text: "A D D   R E S T A U R A N T",
                      btnHieght: 35.h,
                      onTap: () {
                        if (_time.text.isEmpty ||
                            _title.text.isEmpty ||
                            _postalCode.text.isEmpty ||
                            _searchController.text.isEmpty ||
                            uploader.logoUrl.isEmpty ||
                            uploader.coverUrl.isEmpty) {
                          Get.snackbar(
                            colorText: kLightWhite,
                            backgroundColor: kPrimary,
                            "Error",
                            "All fields are required",
                          );
                        } else {
                          String owner = box.read("userId");

                          RestaurantRequest model = RestaurantRequest(
                              title: _title.text,
                              time: _time.text,
                              owner: owner,
                              code: _postalCode.text,
                              logoUrl: uploader.logoUrl,
                              imageUrl: uploader.coverUrl,
                              coords: Coords(
                                  id: controller.generateId(),
                                  latitude: _selectedLocation!.latitude,
                                  longitude: _selectedLocation!.longitude,
                                  address: _searchController.text,
                                  title: _title.text));

                          String data = restaurantRequestToJson(model);

                          controller.restaurantRegistration(data);
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
