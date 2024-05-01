import 'dart:convert'; // Impor package 'dart:convert' untuk mengonversi data JSON.
import 'package:flutter/material.dart'; // Impor package 'flutter/material.dart' untuk membuat aplikasi Flutter.

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter dengan widget MyApp.
}

// Kelas MyApp adalah StatelessWidget yang membangun aplikasi utama.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transkrip Mahasiswa', // Judul aplikasi
      home:
          TranskripMahasiswaPage(), // Halaman utama adalah TranskripMahasiswaPage.
    );
  }
}

// Kelas TranskripMahasiswaPage adalah StatefulWidget untuk menampilkan transkrip mahasiswa.
class TranskripMahasiswaPage extends StatefulWidget {
  @override
  _TranskripMahasiswaPageState createState() => _TranskripMahasiswaPageState();
}

class _TranskripMahasiswaPageState extends State<TranskripMahasiswaPage> {
  String jsonTranskrip =
      ''' // JSON data transkrip mahasiswa dalam bentuk string.
  {
    "mahasiswa": {
      "nama": "AMANDA PUTRI AZZAHRA",
      "nim" : "22082010031",
      "program_studi": "Sistem Informasi",
      "transkrip": [ // Array data mata kuliah dalam transkrip.
        {
          "mata_kuliah": "Basis Data",
          "sks": 3,
          "nilai": "B+"
        },
        {
          "mata_kuliah": "Interaksi Manusia Komputer",
          "sks": 3,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Pemrograman Mobile",
          "sks": 3,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Kecakapan Pribadi",
          "sks": 3,
          "nilai": "A"
        },
        {
          "mata_kuliah": "E-Business",
          "sks": 3,
          "nilai": "A"
        }
      ]
    }
  }
  ''';

  Map<String, dynamic> transkrip =
      {}; // Variabel untuk menampung data JSON transkrip.
  List<Map<String, dynamic>> daftarMataKuliah =
      []; // Variabel untuk menampung daftar mata kuliah.
  double totalSKS = 0; // Total SKS diinisialisasi sebagai 0.
  double totalBobot = 0; // Total bobot diinisialisasi sebagai 0.

  @override
  void initState() {
    super.initState();
    transkrip =
        jsonDecode(jsonTranskrip); // Mendekode string JSON menjadi objek Map.
    daftarMataKuliah = (transkrip['mahasiswa']['transkrip'] as List).cast<
        Map<String,
            dynamic>>(); // Mengonversi daftar mata kuliah ke tipe List<Map<String, dynamic>>.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transkrip Mahasiswa'), // Judul halaman
      ),
      body: SingleChildScrollView(
        // Widget SingleChildScrollView untuk scroll jika konten lebih panjang dari layar.
        padding: EdgeInsets.all(
            16.0), // Padding untuk memberikan jarak dari tepi layar.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Menyebarkan anak-anak secara horizontal.
          children: [
            Text(
              // Menampilkan informasi mahasiswa seperti nama, NIM, dan program studi.
              'Informasi Mahasiswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Jarak vertikal antara widget.
            Text('Nama                  : ${transkrip['mahasiswa']['nama']}'),
            Text('NIM                     : ${transkrip['mahasiswa']['nim']}'),
            Text(
                'Program Studi   : ${transkrip['mahasiswa']['program_studi']}'),
            SizedBox(height: 16), // Jarak vertikal antara widget.
            Text(
              // Menampilkan label untuk data transkrip mahasiswa.
              'Data Transkrip Mahasiswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16), // Jarak vertikal antara widget.
            for (var mataKuliah
                in daftarMataKuliah) // Loop untuk menampilkan daftar mata kuliah.
              ListTile(
                title: Text(
                    'Mata Kuliah: ${mataKuliah['mata_kuliah']}'), // Menampilkan nama mata kuliah.
                subtitle: Text(
                    // Menampilkan informasi tambahan seperti SKS dan nilai.
                    'SKS: ${mataKuliah['sks']}, Nilai: ${mataKuliah['nilai']}'),
              ),
            SizedBox(height: 16), // Jarak vertikal antara widget.
            ElevatedButton(
              // Tombol untuk menghitung IPK.
              onPressed: () {
                showDialog(
                  // Menampilkan dialog dengan IPK ketika tombol ditekan.
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('IPK'), // Judul dialog.
                      content: Text(// Isi dialog menampilkan IPK yang dihitung.
                          'IPK Anda adalah: ${hitungIPK().toStringAsFixed(2)}'),
                      actions: <Widget>[
                        TextButton(
                          // Tombol OK untuk menutup dialog.
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Hitung IPK'),
            ),
          ],
        ),
      ),
    );
  }

  double hitungIPK() {
    for (var mataKuliah in daftarMataKuliah) {
      int sks = mataKuliah['sks'];
      String nilai = mataKuliah['nilai'];

      double bobot = konversiNilaiKeBobot(nilai);
      totalSKS += sks;
      totalBobot += bobot * sks;
    }

    double ipk = totalBobot / totalSKS;
    return ipk;
  }

  double konversiNilaiKeBobot(String nilai) {
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  }
}
