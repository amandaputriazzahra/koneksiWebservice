// untuk mengembangkan aplikasi Flutter yang akan menggunakan HTTP untuk mengambil data dari suatu API dan JSON untuk memparsing data yang diterima.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Mengimpor package yang diperlukan untuk komunikasi HTTP dan manipulasi data JSON

void main() {
  runApp(
      const MyApp()); // Menjalankan aplikasi Flutter dan titik masuk keseluruhan aplikasi.
}

// menampung data hasil pemanggilan API
class Activity {
  // Merepresentasikan suatu aktivitas
  String aktivitas; // Atribut untuk menyimpan nama atau deskripsi aktivitas.
  String jenis; // Atribut untuk menyimpan jenis aktivitas.

  Activity({required this.aktivitas, required this.jenis}); //constructor

  //map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json[
          'activity'], // Menginisialisasi atribut aktivitas dari data JSON.
      jenis: json['type'], // Menginisialisasi atribut jenis dari data JSON.
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // Variabel untuk menampung hasil pemanggilan API.

  //late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API.

  Future<Activity> init() async {
    return Activity(
        aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong.
  }

  // Metode untuk melakukan pemanggilan API dan memparsing respons JSON.
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Melakukan HTTP GET request.
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity =
        init(); // Memanggil metode init() saat initState dipanggil.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                // Memanggil metode init() saat initState dipanggil.
                setState(() {
                  futureActivity = fetchData();
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),

          // Widget FutureBuilder untuk menampilkan hasil aktivitas atau indikator loading.
          FutureBuilder<Activity>(
            future: futureActivity, // Future yang akan dipantau.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika sudah ada data yang diterima,
                // tampilkan hasil aktivitas dan jenisnya.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Tampilkan aktivitas.
                      Text(
                          "Jenis: ${snapshot.data!.jenis}") // Tampilkan jenis aktivitas.
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error saat memuat data,
                // tampilkan pesan error.

                return Text('${snapshot.error}');
              }
              // default: loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
