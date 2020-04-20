import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class NetworkImageDetectionPage extends StatefulWidget {
  static const String pageRoute = '/network-image-detection';

  @override
  _NetworkImageDetectionPageState createState() =>
      _NetworkImageDetectionPageState();
}

class _NetworkImageDetectionPageState extends State<NetworkImageDetectionPage> {
  ARKitController arkitController;
  Timer timer;
  bool anchorWasFound = false;
  ARKitNode boxNode;

  @override
  void dispose() {
    timer?.cancel();
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Image Detection Sample')),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ARKitSceneView(
                detectionImages: const [
                  ARKitReferenceImage(
                    name:
                        'https://images.ru.prom.st/383999910_w640_h640_banknota-100-rublej.jpg',
                    physicalWidth: 0.2,
                  ),
                ],
                onARKitViewCreated: onARKitViewCreated,
                // enableRotationRecognizer: true,
                // enablePinchRecognizer: true,
                // enablePanRecognizer: true,
              ),
              anchorWasFound
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        'open this image https://images.ru.prom.st/383999910_w640_h640_banknota-100-rublej.jpg',
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = onAnchorWasFound;

    this.arkitController.onNodeRotation =
        (rotation) => _onRotationHandler(rotation);
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      setState(() => anchorWasFound = true);
      final earthPosition = anchor.transform.getColumn(3);

      final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty(
            image:
                'https://avatars.mds.yandex.net/get-zen_doc/46847/pub_5a52ee238c8be3221b05b9fa_5a52ee59f4a0ddadcb6b8538/scale_1200'),
      );
       final sphere = ARKitSphere(
        materials: [material],
        radius: 0.1,
      );
      // final sphere = ARKitBox(
      //     length: 0.0000001, width: 0.25, materials: [material], height: 0.15
      //     // radius: 0.1,
      //     );

      boxNode = ARKitNode(
        geometry: sphere,
        position: vector.Vector3(
          earthPosition.x, earthPosition.y, earthPosition.z),
          //  earthPosition.x, earthPosition.y, earthPosition.z - 0.2),
        eulerAngles: vector.Vector3.zero(),
      );
      arkitController.add(boxNode);

      timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        final old = boxNode.eulerAngles.value;
        final eulerAngles = vector.Vector3(old.x, old.y + 0.1, old.z);
        boxNode.eulerAngles.value = eulerAngles;
      });
    }
  }

  void _onRotationHandler(List<ARKitNodeRotationResult> rotation) {
    final rotationNode = rotation.firstWhere(
      (e) => e.nodeName == boxNode.name,
      orElse: () => null,
    );
    if (rotationNode != null) {
      final rotation =
          boxNode.rotation.value + vector.Vector4.all(rotationNode.rotation);
      boxNode.rotation.value = rotation;
    }
  }
}
