import 'package:get/get.dart';
import 'package:mymap/app/modules/home/controllers/map_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<MapController>(
      () => MapController(),
    );
  }
}
