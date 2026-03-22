enum TipoTransaccion { deposito, retiro, transferencia }

enum EstadoTransaccion { pendiente, completada, fallida }

class TransaccionModel {
  final int? id;
  final int cuentaId;
  final TipoTransaccion tipo;
  final double monto;
  final String? descripcion;
  final String fecha;
  final EstadoTransaccion estado;

  TransaccionModel({
    this.id,
    required this.cuentaId,
    required this.tipo,
    required this.monto,
    this.descripcion,
    required this.fecha,
    this.estado = EstadoTransaccion.completada,
  });

  factory TransaccionModel.fromMap(Map<String, dynamic> map) {
    return TransaccionModel(
      id: map['id'] as int?,
      cuentaId: map['cuenta_id'] as int,
      tipo: TipoTransaccion.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoTransaccion.deposito,
      ),
      monto: (map['monto'] as num).toDouble(),
      descripcion: map['descripcion'] as String?,
      fecha: map['fecha'] as String,
      estado: EstadoTransaccion.values.firstWhere(
        (e) => e.name == map['estado'],
        orElse: () => EstadoTransaccion.completada,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'cuenta_id': cuentaId,
      'tipo': tipo.name,
      'monto': monto,
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado.name,
    };
  }

  TransaccionModel copyWith({
    int? id,
    int? cuentaId,
    TipoTransaccion? tipo,
    double? monto,
    String? descripcion,
    String? fecha,
    EstadoTransaccion? estado,
  }) {
    return TransaccionModel(
      id: id ?? this.id,
      cuentaId: cuentaId ?? this.cuentaId,
      tipo: tipo ?? this.tipo,
      monto: monto ?? this.monto,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
    );
  }

  bool get esIngreso => tipo == TipoTransaccion.deposito;
  bool get esEgreso => tipo == TipoTransaccion.retiro || tipo == TipoTransaccion.transferencia;

  @override
  String toString() {
    return 'TransaccionModel(id: $id, cuentaId: $cuentaId, tipo: $tipo, monto: $monto, descripcion: $descripcion, fecha: $fecha, estado: $estado)';
  }
}
