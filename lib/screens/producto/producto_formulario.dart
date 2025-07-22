import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../entities/producto_entity.dart';
import '../../repositories/producto_repository.dart';
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();
  Producto? _producto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Producto) {
      _producto = args;
      _nombreController.text = _producto!.nombre;
      _descripcionController.text = _producto!.descripcion;
      _precioController.text = _producto!.precio.toString();
      _stockController.text = _producto!.stock.toString();
      if (_producto!.imagen.isNotEmpty) {
        _imageFile = File(_producto!.imagen);
      }
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy(imagePath);
      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy(imagePath);
      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Producto(
        id: _producto?.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
        stock: int.parse(_stockController.text),
        imagen: _imageFile?.path ?? '',
      );

      try {
        if (_producto == null) {
          await ProductoRepository.insert(newProduct);
        } else {
          await ProductoRepository.update(newProduct);
        }
        Navigator.pop(context);
      } catch (e) {
        print('Error al agregar producto: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        foregroundColor: Colors.white,
        title: Text(_producto == null ? "Agregar Producto" : "Actualizar Producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _imageFile == null
                    ? const Icon(Icons.image, size: 100, color: Color.fromARGB(255, 97, 117, 150))
                    : Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Color.fromARGB(255, 97, 117, 150)),
                      onPressed: _getImageFromCamera,
                      tooltip: 'Tomar foto',
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_library, color: Color.fromARGB(255, 97, 117, 150)),
                      onPressed: _getImageFromGallery,
                      tooltip: 'Seleccionar de galería',
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _buildTextField(
                  controller: _nombreController,
                  label: "Nombre del Producto",
                  icon: Icons.inventory,
                  validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 22),
                _buildTextField(
                  controller: _descripcionController,
                  label: "Descripción",
                  icon: Icons.description,
                  validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 22),
                _buildTextField(
                  controller: _precioController,
                  label: "Precio",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El campo Precio es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'El campo Precio debe ser un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                _buildTextField(
                  controller: _stockController,
                  label: "Stock",
                  icon: Icons.inventory_2,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El campo Stock es obligatorio';
                    }
                    if (int.tryParse(value) == null) {
                      return 'El campo Stock debe ser un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 184, 184),
                          shadowColor: Colors.grey.withOpacity(0.2),
                          elevation: 5,
                        ),
                        onPressed: _addProduct,
                        child: const Text("Guardar Producto", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 97, 117, 150)),
        prefixIconColor: Color.fromARGB(255, 97, 117, 150),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 97, 117, 150), width: 2),
        ),
      ),
    );
  }
}
