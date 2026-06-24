import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../services/pedido_service.dart';

class ScannerQrScreen extends StatefulWidget {
  const ScannerQrScreen({super.key});

  @override
  State<ScannerQrScreen> createState() => _ScannerQrScreenState();
}

class _ScannerQrScreenState extends State<ScannerQrScreen> {
  final pedidoService = PedidoService();

  String resultado = '';
  bool procesando = false;

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
              onDetect: (capture) async {
                if (procesando) return;

                procesando = true;

                final barcode = capture.barcodes.first;
                final codigo = barcode.rawValue ?? '';

                setState(() {
                  resultado = codigo;
                });

                try {
                  final pedido = await pedidoService
                      .obtenerPedidoPorCodigo(codigo);

                  if (!mounted) return;

                  if (pedido != null) {
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Pedido encontrado'),
                        content: Text(
                          '''
Código: ${pedido.codigoPedido}

Cliente: ${pedido.nombreCliente}

Estado del pedido: ${pedido.estadoPedido}

Estado de pago: ${pedido.estadoPago}

Saldo: \$${pedido.saldo}
''',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title:
                            const Text('Pedido no encontrado'),
                        content: Text(
                          'No existe un pedido con el código $codigo',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  print(e);
                }

                procesando = false;
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                resultado.isEmpty
                    ? 'Escanea un código QR'
                    : resultado,
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