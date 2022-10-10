import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymap/app/modules/home/bindings/home_binding.dart';
import 'package:mymap/destination.dart';

main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Google Maps Demo',
      home: DestinationScreen(),
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
    );
  }
}
