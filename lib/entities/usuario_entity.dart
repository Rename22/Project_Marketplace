class Usuario {
  int? id;
  String usuario;
  String password;
  String nombre;
  String email;
  String telefono;
  String rol;

  Usuario({
    this.id,
    required this.usuario,
    required this.password,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.rol,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'password': password,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'rol': rol,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      id: data['id'],
      usuario: data['usuario'],
      password: data['password'],
      nombre: data['nombre'],
      email: data['email'],
      telefono: data['telefono'],
      rol: data['rol'],
    );
  }
}