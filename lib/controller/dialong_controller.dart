import 'package:get/get.dart';

class DialongController extends GetxController {
  final List<String> tags = [
    'Garage',
    'Kitchen',
    'Flooring',
    'Documents',
    'Air Vents',
    'Fire Alarm / Smoke Detector',
    'Laundry Room',
    'Landscaping',
  ];

  final selectedTags = <String>[].obs;

  // Toggle tag selection
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // For debugging or sending to next step
  void printSelectedTags() {
    print('Selected: $selectedTags');
  }
}
