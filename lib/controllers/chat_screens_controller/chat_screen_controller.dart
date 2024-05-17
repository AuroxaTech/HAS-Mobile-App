import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenListController extends GetxController {
  RxBool messages = true.obs;
  RxBool landlord = false.obs;
  RxBool service = false.obs;
}