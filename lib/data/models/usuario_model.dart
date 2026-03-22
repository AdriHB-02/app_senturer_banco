class UsuarioModel {
  final int? id;
  final String nombre;
  final String email;
  final String? telefono;
  final String fechaRegistro;
  final bool activo;

  UsuarioModel({
    this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.fechaRegistro,
    this.activo = true,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      email: map['email'] as String,
      telefono: map['telefono'] as String?,
      fechaRegistro: map['fecha_registro'] as String,
      activo: (map['activo'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'fecha_registro': fechaRegistro,
      'activo': activo ? 1 : 0,
    };
  }

  UsuarioModel copyWith({
    int? id,
    String? nombre,
    String? email,
    String? telefono,
    String? fechaRegistro,
    bool? activo,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      activo: activo ?? this.activo,
    );
  }

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nombre: $nombre, email: $email, telefono: $telefono, fechaRegistro: $fechaRegistro, activo: $activo)';
  }
}
