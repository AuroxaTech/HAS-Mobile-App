import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CreateOfferController extends GetxController{

  RxString cleanService = "House clean service".obs;
  RxString currency = "\$".obs;
  RxString pricing = "2500".obs;
  RxString offerPricing = "\$2000".obs;
  RxString serviceDuration = "hours".obs;
  RxString offerValid = "Days".obs;
  RxString selectBuyer = "James".obs;

}