import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pago.dart';

class PagoService {
  final supabase = Supabase.instance.client;

  Future<void> registrarPago(Pago pago) async {
    await supabase
        .from('pagos')
        .insert(pago.toJson());

    await recalcularSaldo(pago.idPedido);
  }

  Future<List<dynamic>> obtenerPagos(int idPedido) async {
    return await supabase
        .from('pagos')
        .select()
        .eq('id_pedido', idPedido);
  }

  Future<void> recalcularSaldo(int idPedido) async {

    final pedido = await supabase
        .from('pedidos')
        .select()
        .eq('id_pedido', idPedido)
        .single();

    final pagos = await supabase
        .from('pagos')
        .select()
        .eq('id_pedido', idPedido);

    double totalPagado = 0;

    for (var pago in pagos) {
      totalPagado += (pago['monto'] as num).toDouble();
    }

    final precioTotal =
        (pedido['precio_total'] as num).toDouble();

    double saldo = precioTotal - totalPagado;

    String estadoPago = 'Pendiente';

    if (saldo <= 0) {
      saldo = 0;
      estadoPago = 'Pagado';
    } else if (totalPagado > 0) {
      estadoPago = 'Parcial';
    }

    await supabase
        .from('pedidos')
        .update({
          'saldo': saldo,
          'estado_pago': estadoPago,
        })
        .eq('id_pedido', idPedido);
  }
}