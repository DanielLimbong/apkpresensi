import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'absensi.dart';
import 'package:intl/intl.dart'; 

void main() {
  runApp(const RegistrationPage(kodeMataKuliah: ''));
}

class RegistrationPage extends StatefulWidget {
  final String kodeMataKuliah;

  const RegistrationPage({Key? key, required this.kodeMataKuliah}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>{
   
  final TextEditingController penugasan_pengajar_idController = TextEditingController();
  final TextEditingController lokasiidController = TextEditingController();
  final TextEditingController sesiController = TextEditingController();
  final TextEditingController jenisPerkuliahanController = TextEditingController();
  final TextEditingController waktu_mulaiPerkuliahanController = TextEditingController();
  final TextEditingController waktu_akhirPerkuliahanController = TextEditingController();

  Future<void> _simpanData(String penugasanPengajarId, String lokasiId, String sesi, String jenisPerkuliahan, String waktuMulai, String waktuSelesai) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('penugasanPengajarId', penugasanPengajarId);
    prefs.setString('lokasiId', lokasiId);
    prefs.setString('sesi', sesi);
    prefs.setString('jenisPerkuliahan', jenisPerkuliahan);
    prefs.setString('waktuMulai', waktuMulai);
    prefs.setString('waktuSelesai', waktuSelesai);
    
    _kirimData(); // Panggil fungsi untuk mengirim data setelah menyimpannya di SharedPreferences
  }

  Future<void> _kirimData() async {
    try {
      // Ambil data dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String penugasanPengajarId = prefs.getString('penugasanPengajarId') ?? '';
      String lokasiId = prefs.getString('lokasiId') ?? '';
      String sesi = prefs.getString('sesi') ?? '';
      String jenisPerkuliahan = prefs.getString('jenisPerkuliahan') ?? '';
      String waktuMulai = prefs.getString('waktuMulai') ?? '';
      String waktuSelesai = prefs.getString('waktuSelesai') ?? '';

      // Menyiapkan data yang akan dikirim
      Map<String, dynamic> postData = {
        'penugasanPengajarId': penugasanPengajarId,
        'lokasiId': lokasiId,
        'sesi': sesi,
        'jenisPerkuliahan': jenisPerkuliahan,
        'waktuMulai': waktuMulai,
        'waktuSelesai': waktuSelesai,
      };

      // Mengirim data ke API menggunakan metode POST
      final response = await http.post(
        Uri.parse('https://cis-dev.del.ac.id/absn/absn-api/sesi-kuliah-add'),
        body: json.encode(postData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Memeriksa kode status respons
      if (response.statusCode == 200) {
        // Jika berhasil, tampilkan pesan sukses
        print('Data berhasil disimpan');
      } else {
        // Jika gagal, tampilkan pesan error
        print('Gagal menyimpan data: ${response.statusCode}');
      }
    } catch (error) {
      // Menangani kesalahan koneksi atau kesalahan lainnya
      print('Terjadi kesalahan: $error');
    }
  }

  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/logo_del.jpeg'),
        ),
        title: Text(
          'Registrasi Mata Kuliah',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Isi Formulir Registrasi',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ), 
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: penugasan_pengajar_idController,
                decoration: InputDecoration(
                  labelText: 'ID Penugasan Pengajar',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: lokasiidController,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: sesiController,
                decoration: InputDecoration(
                  labelText: 'Sesi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: jenisPerkuliahanController,
                decoration: InputDecoration(
                  labelText: 'Jenis Perkuliahan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                readOnly: true, // Make the field read-only to prevent manual text input
                controller: waktu_mulaiPerkuliahanController,
                decoration: InputDecoration(
                  labelText: 'Waktu Mulai',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        DateTime combinedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        // Format the combinedDateTime using DateFormat
                        String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
                        // Update the text field with the formatted date and time
                        waktu_mulaiPerkuliahanController.text = formattedDateTime;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                readOnly: true,
                controller: waktu_akhirPerkuliahanController,
                decoration: InputDecoration(
                  labelText: 'Waktu Selesai',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        DateTime combinedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        // Format the combinedDateTime using DateFormat
                        String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
                        // Update the text field with the formatted date and time
                        waktu_akhirPerkuliahanController.text = formattedDateTime;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String penugasanPengajarId = penugasan_pengajar_idController.text;
                  String lokasiId = lokasiidController.text;
                  String sesi = sesiController.text;
                  String jenisPerkuliahan = jenisPerkuliahanController.text;
                  String waktuMulai = waktu_mulaiPerkuliahanController.text;
                  String waktuSelesai = waktu_akhirPerkuliahanController.text;
                  
                  _simpanData(penugasanPengajarId, lokasiId, sesi, jenisPerkuliahan, waktuMulai, waktuSelesai);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PresensiPage())
                  );
                },
                child: Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
