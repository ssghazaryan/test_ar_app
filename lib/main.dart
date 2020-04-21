

import './screens/ios_custom_object.dart';
import './screens/ios_detect_horizonal.dart';
import './screens/ios_detect_image_ios.dart';
import './screens/ios_set_figures_screen.dart';
import './screens/ios_vertical_screen.dart';
import 'package:flutter/material.dart';
import 'screens/menu_for_ar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MenuForAr(),
      routes: {
        AddSimpleObjectStcreen.pageRoute: (ctx) => AddSimpleObjectStcreen(),
        NetworkImageDetectionPage.pageRoute: (ctx) => NetworkImageDetectionPage(),
        HorizonalPlanWithObjects.pageRoute: (ctx) => HorizonalPlanWithObjects(),
        CustomObjectPage.pageRoute: (ctx) => CustomObjectPage(),
        VerticalDetecting.pageRoute: (ctx) => VerticalDetecting(),
      },
      // MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}