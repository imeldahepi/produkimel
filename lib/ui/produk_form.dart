import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:produkimel/models/api.dart';

class ProdukForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProdukFormState();
  }
}

class ProdukFormState extends State<ProdukForm> {
  final formkey = GlobalKey<FormState>();

  TextEditingController kodeProdukController = TextEditingController();
  TextEditingController namaProdukController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  Future<void> createProduk() async {
    final response = await http.post(
      Uri.parse(BaseUrl.tambah), // Ganti dengan URL API untuk menyimpan produk
      body: {
        "kode_produk": kodeProdukController.text,
        "nama_produk": namaProdukController.text,
        "harga": hargaController.text,
      },
    );

    final data = json.decode(response.body);
    if (data['success']) {
      // Jika data berhasil disimpan, kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      // Tampilkan pesan error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan produk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Produk"),
        centerTitle: true,
        backgroundColor: Colors.purple.shade200,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              _buildTextFormField(
                controller: kodeProdukController,
                label: "Kode Produk",
                icon: Icons.code,
                validatorMsg: 'Masukkan Kode Produk',
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: namaProdukController,
                label: "Nama Produk",
                icon: Icons.production_quantity_limits,
                validatorMsg: 'Masukkan Nama Produk',
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: hargaController,
                label: "Harga",
                icon: Icons.attach_money,
                validatorMsg: 'Masukkan Harga Produk',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Simpan"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple.shade200,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          onPressed: () {
            if (formkey.currentState!.validate()) {
              createProduk(); // Kirim data ke server
            }
          },
        ),
      ),
    );
  }

  // Function to build a TextFormField with an icon
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
    );
  }
}
