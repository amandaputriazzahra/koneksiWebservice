import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class University {
  String name; // Deklarasi atribut 'name' untuk menyimpan nama universitas
  String
      website; // Deklarasi atribut 'website' untuk menyimpan situs web universitas

  University(
      {required this.name,
      required this.website}); // Konstruktor untuk inisialisasi atribut 'name' dan 'website'
}

class MyApp extends StatefulWidget {
  // Deklarasi kelas MyApp sebagai StatefulWidget
  @override
  State<StatefulWidget> createState() {
    // Mengoverride metode createState untuk membuat instance dari MyAppState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // Deklarasi kelas MyAppState sebagai State<MyApp>
  late Future<List<University>>
      futureUniversities; // Deklarasi variabel futureUniversities untuk menampung future hasil dari fetchUniversities

  String url =
      "http://universities.hipolabs.com/search?country=Indonesia"; // URL untuk mengambil data universitas Indonesia

  Future<List<University>> fetchUniversities() async {
    // Deklarasi fungsi fetchUniversities yang mengembalikan Future<List<University>>
    final response = await http.get(Uri.parse(
        url)); // Mengirimkan permintaan HTTP GET ke URL dan menunggu responsenya

    if (response.statusCode == 200) {
      // Jika responsenya berhasil (status code 200)
      List<dynamic> data = json
          .decode(response.body); // Mendekode respons HTTP ke dalam bentuk JSON
      List<University> universities =
          []; // Inisialisasi list untuk menampung objek University

      for (var item in data) {
        // Iterasi setiap item dalam data
        universities.add(
          // Menambahkan objek University ke dalam list
          University(
            name: item['name'], // Mengambil nama universitas dari data
            website: item['web_pages'][0], // Ambil situs web pertama
          ),
        );
      }

      return universities; // Mengembalikan list universitas
    } else {
      throw Exception(
          'Gagal load'); // Jika responsenya tidak berhasil, lempar exception
    }
  }

  @override
  void initState() {
    // Mengoverride initState untuk melakukan inisialisasi data awal
    super.initState();
    futureUniversities =
        fetchUniversities(); // Memanggil fetchUniversities dan menyimpan hasilnya ke dalam futureUniversities
  }

  @override
  Widget build(BuildContext context) {
    // Mengoverride metode build untuk membangun UI aplikasi
    return MaterialApp(
      title: 'Universities App', // Judul aplikasi
      home: Scaffold(
        // Scaffold sebagai kerangka aplikasi
        appBar: AppBar(
          title: Text('Universitas di Indonesia'), // Judul AppBar
        ),
        body: FutureBuilder<List<University>>(
          // Widget FutureBuilder untuk menampilkan data yang diambil dari future
          future:
              futureUniversities, // Future yang digunakan untuk membangun UI
          builder: (context, snapshot) {
            // Builder yang akan membangun UI sesuai dengan state snapshot
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Jika sedang menunggu data
              return Center(
                // Tengahkan CircularProgressIndicator
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Jika terjadi error saat fetching data
              return Center(
                // Tengahkan teks error
                child: Text('${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Jika tidak ada data atau data kosong
              return Center(
                // Tengahkan teks bahwa tidak ada data tersedia
                child: Text('No data available'),
              );
            } else {
              // Jika berhasil mendapatkan data
              return ListView.separated(
                // Tampilkan data menggunakan ListView.separated
                shrinkWrap: true,
                itemCount:
                    snapshot.data!.length, // Jumlah item adalah panjang data
                separatorBuilder: (BuildContext context,
                        int index) => // Tambahkan Divider di antara item
                    Divider(),
                itemBuilder: (context, index) {
                  // Untuk setiap item dalam data
                  return ListTile(
                    // Tampilkan data universitas dalam ListTile
                    title: Text(snapshot
                        .data![index].name), // Tampilkan nama universitas
                    subtitle: Text(snapshot.data![index]
                        .website), // Tampilkan situs web universitas
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  // Fungsi main untuk menjalankan aplikasi
  runApp(MyApp()); // Menjalankan aplikasi MyApp
}
