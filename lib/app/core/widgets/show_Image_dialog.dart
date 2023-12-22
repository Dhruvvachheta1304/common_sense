import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shows image dialog with a captured widget screenshot.
class ShowImageDialog extends StatelessWidget {
  final Uint8List capturedImage;

  const ShowImageDialog(this.capturedImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Captured widget screenshot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(child: Image.memory(capturedImage)),
      ),
    );
  }
}

Future<void> showCapturedWidget(
    BuildContext context, Uint8List capturedImage) async {
  await Get.dialog(
    ShowImageDialog(capturedImage),
    useSafeArea: false,
  );
}
