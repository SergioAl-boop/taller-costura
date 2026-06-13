class Pago {
  final int? idPago;
  final int idPedido;
  final double monto;
  final String metodoPago;

  Pago({
    this.idPago,
    required this.idPedido,
    required this.monto,
    required this.metodoPago,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_pedido': idPedido,
      'monto': monto,
      'metodo_pago': metodoPago,
    };
  }
}