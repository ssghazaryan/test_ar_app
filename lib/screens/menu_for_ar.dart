import 'package:ar_app/screens/android/adnroid_detect_horizonal.dart';
import 'package:ar_app/screens/android/assets_objects.dart';
import 'package:ar_app/screens/ios_custom_object.dart';
import 'package:ar_app/screens/ios_detect_horizonal.dart';
import 'package:ar_app/screens/ios_detect_image_ios.dart';
import 'package:ar_app/screens/ios_set_figures_screen.dart';
import 'package:ar_app/screens/ios_set_shop_page_items.dart';
import 'package:ar_app/screens/ios_vertical_screen.dart';
import 'package:ar_app/widget/menu_item.dart';
import 'package:ar_app/widget/menu_item_with_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vector_math/vector_math_64.dart';

class MenuForAr extends StatelessWidget {
  void openScreen(context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void changeScreen({
    @required BuildContext context,
    @required String title,
    @required String dae,
    @required Vector3 scale,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SetToHorizonal(
              dae: dae,
              scale: scale,
              title: title,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ar Test App'),
      ),
      body: Platform.isIOS
          ? Container(
              padding: EdgeInsets.all(8),
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
                  MenuItemWidgetImg(
                    imageUrl:
                        'https://static.turbosquid.com/Preview/001201/300/08/table-marble-3D-model_DHQ.jpg',
                    title: 'Marble Table',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Marble Table',
                      dae: 'marbletable',
                      scale: Vector3(1.2, 1, 2),
                    ),
                  ),
                  MenuItemWidgetImg(
                    imageUrl:
                        'https://static.turbosquid.com/Preview/2016/07/04__03_42_32/Armchair_2_1.jpg571E4342-4CE7-48DB-BEB0-E5DA52DCA28EDefaultHQ.jpg',
                    title: 'Armchairby',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Armchairby',
                      dae: 'arm',
                      scale: Vector3(1.8, 0.9, 1.8),
                    ),
                  ),
                  MenuItemWidgetImg(
                    imageUrl:
                        'https://static.turbosquid.com/Preview/2014/07/10__01_47_29/ModestyVeiledArmchair.jpg14cde977-3a0c-411e-824f-6110cc503a50Zoom.jpg',
                    title: 'Modesty Veiled Armchair',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Modesty Veiled Armchair',
                      dae: 'modesty',
                      scale: Vector3(0.048, 0.027, 0.048),
                    ),
                  ),
                  MenuItemWidgetImg(
                    imageUrl:
                        'https://static.turbosquid.com/Preview/2015/07/25__00_58_07/screenshot000.png16655063-50a4-42d4-84ca-e11d4cbc1717Zoom.jpg',
                    title: 'Low-poly Armchair',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Low-poly Armchair',
                      dae: 'armchair',
                      scale: Vector3(0.018, 0.009, 0.018),
                    ),
                  ),
                  MenuItemWidgetImg(
                    imageUrl:
                        'https://static.turbosquid.com/Preview/2014/11/02__13_42_46/Couch1.png18e8acb9-78e4-4f6f-85be-a2f80b025b41Zoom.jpg',
                    title: 'Leather Sofa',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Leather Sofa',
                      dae: 'couch',
                      scale: Vector3(0.9, 0.9, 0.63),
                    ),
                  ),
                  MenuItemWidgetImg(
                    imageUrl:
                        'https://static-us-east-2-fastly-a.www.philo.com/storage/images/try/tv.png?auto=webp&width=1000',
                    title: 'Tv',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Tv',
                      dae: 'tv',
                      scale: Vector3(0.18, 0.18, 0.09),
                    ),
                  ),
                  MenuItemWidgetImg(
                    title: 'Monster',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Monster',
                      dae: 'twist_danceFixed',
                      scale: Vector3(0.2, 0.2, 0.2),
                    ),
                  ),
                  MenuItemWidgetImg(
                    title: 'Pica',
                    onPress: () => changeScreen(
                      context: context,
                      title: 'Pica',
                      dae: 'eevee',
                      scale: Vector3(0.03, 0.03, 0.03),
                    ),
                  )
                ],
              ),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                children: [
                     MenuItemWidget(
                      title: 'Add simple objects at horizonal plan',
                      secondTitle: 'sphere / cylinder / con',
                      onPress: () =>
                          openScreen(context, ArCoreHorizonalPlanWithObjects.pageRoute),
                    ),
                    // MenuItemWidget(
                    //   title: 'Assets objects',
                    //   secondTitle: 'sphere / cylinder / con',
                    //   onPress: () =>
                    //       openScreen(context, AndroidAssetsObject.pageRoute),
                    // ),
                ],
              ),
          ),
    );
  }
}
