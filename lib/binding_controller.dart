import 'package:get/get.dart';
import 'package:googlemap/location_controller.dart';

class BindingController extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController());
  }
}
