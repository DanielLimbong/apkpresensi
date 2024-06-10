import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'absensi.dart';
import 'matkulregist.dart';
import 'login.dart';
import 'laporan.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? namaMataKuliah;
  String? kodeMataKuliah;
  String? dosenPengampu;
  String? pegawaiId;
  String? lokasiPerkuliahan;
  String? sesi;
  String? jenisPerkuliahan;
  String? waktuPerkuliahan;
  String? loginData;
  List<Map<String, dynamic>> mataKuliahList = [];

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences();
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginData = prefs.getString('loginData');
      if (loginData != null) {
        Map<String, dynamic> loginMap = json.decode(loginData!);
        pegawaiId = loginMap['pegawai_id'].toString();
        fetchData(); // Panggil fetchData setelah mendapatkan pegawaiId
      }
    });
    print(loginData);
  }

    Future<void> fetchData() async {
    try {
      if (pegawaiId != null) {
        final response = await http.get(
          Uri.parse('https://cis-dev.del.ac.id/absn/absn-api/mata-kuliah-by-pegawai-id?pegawai_id=$pegawaiId'),
        );
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            mataKuliahList = data.cast<Map<String, dynamic>>();
          });
          // Simpan data ke SharedPreferences
          saveDataToSharedPreferences();
        } else {
          print('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
    Future<void> saveDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mataKuliahList', json.encode(mataKuliahList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/logo_del.jpeg'),
        ),
        title: const Text(
          'Presensi Institut Teknologi Del',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
              itemCount: mataKuliahList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(mataKuliahList[index]['mata_kuliah']),
          subtitle: Text('Kode MK: ${mataKuliahList[index]['kode_mk']}'),
          onTap: () {
            _showOptionsDialog(context, mataKuliahList, index);

          },
          );
        },
      ),

    );
  }
}

void _showOptionsDialog(BuildContext context, List<Map<String, dynamic>> mataKuliahList, int index) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Tambahkan Sesi Absensi'),
            onTap: () {
              // Pindah ke halaman absensi dengan kode mata kuliah yang sesuai
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage(kodeMataKuliah: mataKuliahList[index]['kode_mk'])),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text('Laporan Absensi'),
            onTap: () {
              // Pindah ke halaman laporan absensi
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LaporanPage()),
              );
            },
          ),
        ],
      );
    },
  );
}



