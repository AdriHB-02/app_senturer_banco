enum TipoCuenta { ahorro, corriente, digital }

class CuentaModel {
  final int? id;
  final int usuarioId;
  final String numeroCuenta;
  final TipoCuenta tipo;
  final double saldo;
  final String moneda;
  final String fechaApertura;
  final bool activa;

  CuentaModel({
    this.id,
    required this.usuarioId,
    required this.numeroCuenta,
    required this.tipo,
    this.saldo = 0.0,
    this.moneda = 'MXN',
    required this.fechaApertura,
    this.activa = true,
  });

  factory CuentaModel.fromMap(Map<String, dynamic> map) {
    return CuentaModel(
      id: map['id'] as int?,
      usuarioId: map['usuario_id'] as int,
      numeroCuenta: map['numero_cuenta'] as String,
      tipo: TipoCuenta.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoCuenta.ahorro,
      ),
      saldo: (map['saldo'] as num).toDouble(),
      moneda: map['moneda'] as String,
      fechaApertura: map['fecha_apertura'] as String,
      activa: (map['activa'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'usuario_id': usuarioId,
      'numero_cuenta': numeroCuenta,
      'tipo': tipo.name,
      'saldo': saldo,
      'moneda': moneda,
      'fecha_apertura': fechaApertura,
      'activa': activa ? 1 : 0,
    };
  }

  CuentaModel copyWith({
    int? id,
    int? usuarioId,
    String? numeroCuenta,
    TipoCuenta? tipo,
    double? saldo,
    String? moneda,
    String? fechaApertura,
    bool? activa,
  }) {
    return CuentaModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      numeroCuenta: numeroCuenta ?? this.numeroCuenta,
      tipo: tipo ?? this.tipo,
      saldo: saldo ?? this.saldo,
      moneda: moneda ?? this.moneda,
      fechaApertura: fechaApertura ?? this.fechaApertura,
      activa: activa ?? this.activa,
    );
  }

  @override
  String toString() {
    return 'CuentaModel(id: $id, usuarioId: $usuarioId, numeroCuenta: $numeroCuenta, tipo: $tipo, saldo: $saldo, moneda: $moneda, fechaApertura: $fechaApertura, activa: $activa)';
  }
}
