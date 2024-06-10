import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

void main() {
  runApp(const LaporanPage());
}

class Mahasiswa {
  final String nama;
  final String nim;
  bool hadir;

  Mahasiswa({required this.nama, required this.nim, this.hadir = false});
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final List<String> mahasiswaList = List.generate(20, (index) => 'Mahasiswa ${index + 1}');
  final List<String> nimList = List.generate(20, (index) => "12S200${index + 1}");
  List<bool> hadirList = List.generate(20, (index) => false);
  List<String> hadirStatus = [];

  late String namaMataKuliah;
  late String kodeMataKuliah;
  late String dosenPengampu;
  late String pegawaiId;
  late String lokasiPerkuliahan;
  late String sesi;
  late String jenisPerkuliahan;
  late String waktuPerkuliahan;

  int totalHadir = 0;
  int totalTidakHadir = 0;

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences();
    getPresensiMahasiswa();
  }

  Future<void> sendAttendanceData(String sesiKuliahId, int hadir, int tidakHadir) async {
    Map<String, dynamic> postData = {
      'sesi_kuliah_id': sesiKuliahId,
      'dim_id[0]': hadir.toString(),
      'dim_id[1]': tidakHadir.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://cis-dev.del.ac.id/absn/absn-api/absensi-add-many'),
        body: json.encode(postData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Data kehadiran berhasil dikirim');
      } else {
        print('Gagal mengirim data kehadiran: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaMataKuliah = prefs.getString('namaMataKuliah') ?? '';
      kodeMataKuliah = prefs.getString('kodeMataKuliah') ?? '';
      dosenPengampu = prefs.getString('dosenPengampu') ?? '';
      pegawaiId = prefs.getString('pegawaiId') ?? '';
      lokasiPerkuliahan = prefs.getString('lokasiPerkuliahan') ?? '';
      sesi = prefs.getString('sesi') ?? '';
      jenisPerkuliahan = prefs.getString('jenisPerkuliahan') ?? '';
      waktuPerkuliahan = prefs.getString('waktuPerkuliahan') ?? '';
    });
  }

  Future<void> getPresensiMahasiswa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? presensi = prefs.getStringList('presensiMahasiswa');

    if (presensi != null && presensi.isNotEmpty) {
      for (String data in presensi) {
        List<String> mahasiswaData = data.split('-');
        String hadir = mahasiswaData[2];
        hadirStatus.add(hadir);
        if (hadir == 'Hadir') {
          totalHadir++;
        } else {
          totalTidakHadir++;
        }
      }
    } else {
      print('Data presensi tidak ditemukan atau kosong');
    }
  }

  void _handleSubmit() async {}

  Future<void> _savePresensi() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/logo_del.jpeg'),
        ),
        title: Text(
          'Laporan Presensi Mata Kuliah',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Kode Mata Kuliah',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          ': $kodeMataKuliah',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Nama Mata Kuliah',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          ': $namaMataKuliah',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Dosen Pengampu',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          ': $dosenPengampu',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Waktu Kuliah',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          ': $waktuPerkuliahan',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Sesi Kuliah',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          ': $sesi',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: ElevatedButton(
    onPressed: () {
      // Navigate to the HomePage
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => HomePage())
      );
    },
    child: Text('HomePage'),
  ),
),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[300]),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'NIM',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Nama',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Presensi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          ...List.generate(
                            mahasiswaList.length,
                            (index) => TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      nimList[index],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      mahasiswaList[index],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    hadirStatus.isEmpty
                                        ? ''
                                        : hadirStatus[index] == 'Hadir'
                                            ? 'Hadir'
                                            : 'Tidak Hadir',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Total Hadir: $totalHadir',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Tidak Hadir: $totalTidakHadir',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
