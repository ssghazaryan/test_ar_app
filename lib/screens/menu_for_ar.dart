import 'package:ar_app/screens/ios_custom_object.dart';
import 'package:ar_app/screens/ios_detect_horizonal.dart';
import 'package:ar_app/screens/ios_detect_image_ios.dart';
import 'package:ar_app/screens/ios_set_figures_screen.dart';
import 'package:ar_app/screens/ios_vertical_screen.dart';
import 'package:ar_app/widget/menu_item.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MenuForAr extends StatelessWidget {
  void openScreen(context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ar Test App'),
      ),
      body: Platform.isIOS
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView(
                children: [
                  MenuItemWidget(
                    title: 'Add simple objects',
                    secondTitle: 'add sphere / cylinder / con',
                    onPress: () =>
                        openScreen(context, AddSimpleObjectStcreen.pageRoute),
                  ),
                  MenuItemWidget(
                    title: 'Add simple objects at horizonal plan',
                    secondTitle: 'sphere / cylinder / con',
                    onPress: () =>
                        openScreen(context, HorizonalPlanWithObjects.pageRoute),
                  ),
                  MenuItemWidget(
                    title: 'Detect Image',
                    secondTitle:
                        'https://images.ru.prom.st/383999910_w640_h640_banknota-100-rublej.jpg',
                    onPress: () => openScreen(
                        context, NetworkImageDetectionPage.pageRoute),
                  ),
                  MenuItemWidget(
                    title: 'Custom objects',
                    secondTitle: 'Set Pokemon and Monster',
                    onPress: () =>
                        openScreen(context, CustomObjectPage.pageRoute),
                  ),
                  MenuItemWidget(
                    title: 'Vertical plan detect set tv',
                    secondTitle: 'Vertical plan',
                    onPress: () =>
                        openScreen(context, VerticalDetecting.pageRoute),
                  ),
                ],
              ),
            )
          : ListView(
              children: [],
            ),
    );
  }
}
