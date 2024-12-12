import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:produkimel/edit.dart';
import 'package:produkimel/models/mproduk.dart';
import 'package:produkimel/models/api.dart';

class Details extends StatefulWidget {
  final ProdukModel sw;

  Details({required this.sw});

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  // Fungsi untuk menghapus data produk dari server
  void deleteProduk(context) async {
    try {
      print("Mengirim data delete ke server...");
      http.Response response = await http.post(
        Uri.parse(BaseUrl.hapus),
        body: {
          'id': widget.sw.id.toString(),
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final data = json.decode(response.body);
      if (data['success']) {
        pesan();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menghapus data.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error saat menghapus produk: $e");
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Menampilkan toast pesan saat delete berhasil
  pesan() {
    Fluttertoast.showToast(
      msg: "Data berhasil dihapus :v",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  // Konfirmasi sebelum menghapus data
  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 40),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Yakin mau dihapus?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.check_circle, color: Colors.white),
              label: Text("Hapus"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProduk(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jika data widget.sw kosong
    if (widget.sw == null) {
      return Scaffold(
        body: Center(
          child: Text("Data produk tidak ditemukan."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Details Produk'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID : ${widget.sw.id ?? 'N/A'}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(color: Colors.grey),
                      Text(
                        "KODE PRODUK : ${widget.sw.kode_produk ?? 'N/A'}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "NAMA PRODUK : ${widget.sw.nama_produk ?? 'N/A'}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "HARGA : ${widget.sw.harga?.toString() ?? 'N/A'}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, size: 28),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.greenAccent,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Edit(sw: widget.sw),
          ),
        ),
      ),
    );
  }
}