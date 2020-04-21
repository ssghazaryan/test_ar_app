import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;

class AddSimpleObjectStcreen extends StatefulWidget {
  static const String pageRoute = '/add-simple-object-screens';

  @override
  _IosSceenState createState() => _IosSceenState();
}

class _IosSceenState extends State<AddSimpleObjectStcreen> {
  ARKitController arkitController;
  vector.Vector3 lastPosition;
  List nodeName = [];
  int index = 0;
  ARKitPlane plane;
  ARKitNode node;
  String anchorId;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                nodeName.forEach((element) {
                  arkitController.remove(element);
                });
              },
            )
          ],
          title: const Text(
            'Simple objects',
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  child: Text('sphere'),
                  onPressed: () {
                    setState(() {
                      index = 0;
                    });
                  },
                ),
                RaisedButton(
                  child: Text('cylinder'),
                  onPressed: () {
                    setState(() {
                      index = 1;
                    });
                  },
                ),
                RaisedButton(
                  child: Text('con'),
                  onPressed: () {
                    setState(() {
                      index = 2;
                    });
                  },
                )
              ],
            ),
            Expanded(
              child: ARKitSceneView(
                enableTapRecognizer: true,
                planeDetection: ARPlaneDetection.horizontal,
                onARKitViewCreated: onARKitViewCreated,
              ),
            ),
          ],
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    this.arkitController.onNodeTap = (nodes) => onNodeTapHandler(nodes);

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
    node.position.value =
        vector.Vector3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );

    node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    controller.add(node, parentNodeName: anchor.nodeName);
  }

  void onNodeTapHandler(List<String> nodesList) {
    final name = nodesList.first;
    arkitController.remove(name);
  }

  // void _handleOnPlaneTap(List<ARKitTestResult> hits) {
  //   print('\n\n\n\n\n////////////');

  //   print('here');
  //   final hit = hits.first;
  //   print(hit.localTransform);
  //   print('////////////');
  //   print(hit.worldTransform);
  //   print('////////////');

  //   print(hit.type);
  //   print('////////////');

  //   print(hit.distance);

  //   print('////////////');
  //   print('////////////\n\n\n\n\n');

  //   final node = ARKitNode(
  //     geometry: ARKitSphere(radius: 0.1),
  //     position: vector.Vector3(
  //       0,
  //       0,
  //       -0.5,
  //     ),
  //   );
  //   this.arkitController.add(node);
  // }

  void _onARTapHandler(ARKitTestResult point) {
    var temoNode;

    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );

    if (index == 0) {
      final material = ARKitMaterial(
          lightingModelName: ARKitLightingModel.constant,
          diffuse: ARKitMaterialProperty(color: Colors.green));
      temoNode = ARKitSphere(
        radius: 0.05,
        materials: [material],
      );
    } else if (index == 1) {
      temoNode = ARKitCylinder(
          radius: 0.05, height: 0.09, materials: _createRandomColorMaterial());
    } else if (index == 2) {
      temoNode = ARKitCone(
          topRadius: 0,
          bottomRadius: 0.05,
          height: 0.09,
          materials: _createRandomColorMaterial());
    }

    final node = ARKitNode(
      geometry: temoNode,
      position: position,
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
    lastPosition = position;
  }

  List<ARKitMaterial> _createRandomColorMaterial() {
    return [
      ARKitMaterial(
        lightingModelName: ARKitLightingModel.physicallyBased,
        diffuse: ARKitMaterialProperty(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0),
        ),
      )
    ];
  }

  // String _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
  //   final length = A.distanceTo(B);
  //   return '${(length * 100).toStringAsFixed(2)} cm';
  // }

  // vector.Vector3 _getMiddleVector(vector.Vector3 A, vector.Vector3 B) {
  //   return vector.Vector3((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
  // }

  // void _drawText(String text, vector.Vector3 point) {
  //   final textGeometry = ARKitText(
  //     text: text,
  //     extrusionDepth: 1,
  //     materials: [
  //       ARKitMaterial(
  //         diffuse: ARKitMaterialProperty(color: Colors.red),
  //       )
  //     ],
  //   );
  //   const scale = 0.001;
  //   final vectorScale = vector.Vector3(scale, scale, scale);
  //   final node = ARKitNode(
  //     geometry: textGeometry,
  //     position: point,
  //     scale: vectorScale,
  //   );
  //   arkitController.add(node);
  // }
}
