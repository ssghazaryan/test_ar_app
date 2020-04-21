import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;

class VerticalDetecting extends StatefulWidget {
  static const String pageRoute = '/vertical-page';

  @override
  _IosSceenState createState() => _IosSceenState();
}

class _IosSceenState extends State<VerticalDetecting> {
  
  ARKitController arkitController;
  vector.Vector3 lastPosition;
  List nodeName = [];
  double size = 0.1;
  ARKitPlane plane;
  ARKitNode node;
  String anchorId;
  List listofPlans = [];
  vector.Vector3 position;
  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.tv),
            onPressed: () {
              nodeName.forEach((element) {
                arkitController.remove(element);
              });

              position = null;
              nodeName.clear();

            },
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
            
              listofPlans.forEach((element) {
                arkitController.remove(element);
              });
              listofPlans.clear();

            },
          )
        ],
        title: const Text(
          'Vertical plan detect',
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Tv size: $size m',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue[700],
                inactiveTrackColor: Colors.blue[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.blueAccent,
                overlayColor: Colors.blue.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.blue[700],
                inactiveTickMarkColor: Colors.blue[100],
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.blueAccent,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                useV2Slider: true,
                min: 0.1,
                max: 2,
                value: size,
                divisions: 10,
                label: size.toStringAsFixed(2),
                onChanged: (value) {
                  setState(() {
                    size = value;
                  });
                },
              )),
          Expanded(
            child: ARKitSceneView(
              enableTapRecognizer: true,
              planeDetection: ARPlaneDetection.vertical,
              onARKitViewCreated: onARKitViewCreated,
              showFeaturePoints: true,
              enablePanRecognizer: true,
              enableRotationRecognizer: true,
            ),
          ),
        ],
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
   this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
    this.arkitController.onARTap = (ar) {
      final point = ar.firstWhere(
        (o) => o.type == ARKitHitTestResultType.featurePoint,
        orElse: () => null,
      );
      if (point != null) {
        _onARTapHandler(point);
      }
    };
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor.identifier != anchorId) {
      return;
    }
    final ARKitPlaneAnchor planeAnchor = anchor;
    node.position.value = vector.Vector3(
        planeAnchor.center.x, planeAnchor.center.y - 1, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
     anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [   ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )],
    );

    node = ARKitNode(
      geometry: plane,
      renderingOrder: -1,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    controller.add(node, parentNodeName: anchor.nodeName);

    // final material = ARKitMaterial(
    //   lightingModelName: ARKitLightingModel.lambert,
    //   diffuse: ARKitMaterialProperty(
    //       image:
    //           'https://lh3.googleusercontent.com/proxy/vv1b9RODvY_Y4SEW5xQ1J0xcd8lAX1mj2hwsOg8Cyc-mon96jeOGpFdwcvCIEBhd8hJUwniQaebzuEMe16NycWxr2uUoo4n2TwFMhyi2L6_kV7dKc-pCX7_PeQ'),
    // );
    // plane = ARKitBox(
    //   width: anchor.extent.x,
    //   height: anchor.extent.z,
    //   materials: [
    //     // material
    //     ARKitMaterial(
    //       transparency: 0.5,
    //       diffuse: ARKitMaterialProperty(color: Colors.white),
    //     )
    //   ],
    // );

    //  final material = ARKitMaterial(
    //     lightingModelName: ARKitLightingModel.lambert,
    //     diffuse: ARKitMaterialProperty(
    //         image:
    //             'https://avatars.mds.yandex.net/get-zen_doc/46847/pub_5a52ee238c8be3221b05b9fa_5a52ee59f4a0ddadcb6b8538/scale_1200'),
    //   );
    //   final sphere = ARKitBox(
    //     length: anchor.extent.y,
    //     width: anchor.extent.x,
    //     materials: [material],
    //     height: 0.15
    //     // radius: 0.1,
    //   );
    // plane = ARKitPlane(
    //   width: anchor.extent.x,
    //   height: anchor.extent.z,
    //   materials: [
    //         // material
    //     ARKitMaterial(
    //       transparency: 0.5,
    //       diffuse: ARKitMaterialProperty(color: Colors.white),
    //     )
    //   ],
    // );
    // node = ARKitNode(
    //   geometry: plane,
    //   position:
    //       vector.Vector3(anchor.center.x, anchor.center.y, anchor.center.z),
    //      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    // );

     listofPlans.add(node.name);
    // controller.add(node, parentNodeName: anchor.nodeName);
  }

  void _onARTapHandler(ARKitTestResult point) {
    nodeName.forEach((element) {
      arkitController.remove(element);
    });
    if (position == null)
      position = vector.Vector3(
        point.worldTransform.getColumn(3).x,
        point.worldTransform.getColumn(3).y,
        point.worldTransform.getColumn(3).z,
      );

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty(
          image:
              'https://www.ixbt.com/img/n1/news/2019/0/0/Samsung-TV_iTunes-Movies-and-TV-shows_large.jpg'),
    );
    final sphere = ARKitBox(
        length: 0.003, width: size, materials: [material], height: size / 2
        // radius: 0.1,
        );

   final node = ARKitNode(
      geometry: sphere,
      position: position,
      eulerAngles: vector.Vector3.zero(),
     // rotation: vector.Vector4(0, 0, 0, 0),
    );

    arkitController.add(node);
    nodeName.add(node.name);

    if (lastPosition != null) {
      // final line = ARKitLine(
      //   fromVector: lastPosition,
      //   toVector: position,
      // );
      // final lineNode = ARKitNode(geometry: line);
      // arkitController.add(lineNode);

      // final distance = _calculateDistanceBetweenPoints(position, lastPosition);
      // final point = _getMiddleVector(position, lastPosition);
      // _drawText(distance, point);
    }
    // lastPosition = position;
  }

  void _onRotationHandler(List<ARKitNodeRotationResult> rotation) {
    final rotationNode = rotation.firstWhere(
      (e) => e.nodeName == node.name,
      orElse: () => null,
    );
    if (rotationNode != null) {
      final rotation =
          node.rotation.value + vector.Vector4.all(rotationNode.rotation);
      node.rotation.value = rotation;
    }
  }

  void _onPanHandler(List<ARKitNodePanResult> pan) {
    final panNode =
        pan.firstWhere((e) => e.nodeName == node.name, orElse: null);
    if (panNode != null) {
      final old = node.eulerAngles.value;
      final newAngleY = panNode.translation.x * math.pi / 180;
      node.eulerAngles.value = vector.Vector3(old.x, newAngleY, old.z);
    }
  }
}


