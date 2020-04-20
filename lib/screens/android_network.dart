import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AutoDetectPlane extends StatefulWidget {
  @override
  _AutoDetectPlaneState createState() => _AutoDetectPlaneState();
}

class _AutoDetectPlaneState extends State<AutoDetectPlane> {
  ArCoreController arCoreController;
  ArCoreNode node;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plane detect handler'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableUpdateListener: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneDetected = _handleOnPlaneDetected;
  }
  

  void _handleOnPlaneDetected(ArCorePlane plane) {
    if (node != null) {
      print("\n\n\\n\n\n\\n\n\n\\n\n\n\n\n\n\n\\nhere\n\n\\n\n\n\\n\n\n\\n\n\n\n\n\n\n\\n");
      arCoreController.removeNode(nodeName: node.name);
    }
    _addSphere(arCoreController, plane);
  }

  Future _addSphere(ArCoreController controller, ArCorePlane plane) async {
    final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');
  print("\n\n\\n\n\n\\n\n\n\\n\n\n\n\n\n\n\\qwertyuiop[]\n\n\\n\n\n\\n\n\n\\n\n\n\n\n\n\n\\n");
    final material = ArCoreMaterial(color: Colors.deepOrange);
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.2,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}