import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerarQrScreen extends StatelessWidget {
  final String codigoPedido;

  const GenerarQrScreen({
    super.key,
    required this.codigoPedido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR del Pedido'),
      ),
      body: Center(
        child: QrImageView(
          data: codigoPedido,
          version: QrVersions.auto,
          size: 250,
        ),
      ),
    );
  }
}