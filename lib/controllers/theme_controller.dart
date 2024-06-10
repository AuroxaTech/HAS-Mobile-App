import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var selectedMessages = <String>[].obs;
  var selectedUsers = <String>[].obs;
  var selectedLanguageCode = 'en'.obs;
  var selectedLanguageName = 'English'.obs;



  void selectMessage(bool selected, String categoryId) {
    if (selected) {
      selectedMessages.add(categoryId);
      update();
    } else {
      selectedMessages.remove(categoryId);
      update();
    }

  }

  void selectContact(bool selected, String categoryId) {
    if (selected) {
      selectedUsers.add(categoryId);
    } else {
      selectedUsers.remove(categoryId);
    }
    update();
  }


}
