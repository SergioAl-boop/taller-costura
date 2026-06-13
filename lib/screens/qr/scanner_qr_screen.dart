import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerQrScreen extends StatefulWidget {
  const ScannerQrScreen({super.key});

  @override
  State<ScannerQrScreen> createState() =>
      _ScannerQrScreenState();
}

class _ScannerQrScreenState
    extends State<ScannerQrScreen> {

  String resultado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: Column(
        children: [

          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (capture) {

                final barcode =
                    capture.barcodes.first;

                setState(() {
                  resultado =
                      barcode.rawValue ?? '';
                });
              },
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                resultado,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}