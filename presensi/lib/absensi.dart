import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'laporan.dart';

void main() {
  runApp(const PresensiPage());
}

class Mahasiswa {
  final String nama;
  final String nim;
  bool hadir;

  Mahasiswa({required this.nama, required this.nim, this.hadir = false});
}

class PresensiPage extends StatefulWidget {
  const PresensiPage({Key? key}) : super(key: key);

  @override
  _PresensiPageState createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  final List<String> mahasiswaList = [
    'Mahasiswa 1',
    'Mahasiswa 2',
    'Mahasiswa 3',
    'Mahasiswa 4',
    'Mahasiswa 5',
    'Mahasiswa 6',
    'Mahasiswa 7',
    'Mahasiswa 8',
    'Mahasiswa 9',
    'Mahasiswa 10',
    'Mahasiswa 11',
    'Mahasiswa 12',
    'Mahasiswa 13',
    'Mahasiswa 14',
    'Mahasiswa 15',
    'Mahasiswa 16',
    'Mahasiswa 17',
    'Mahasiswa 18',
    'Mahasiswa 19',
    'Mahasiswa 20',
  ];

  final List<String> nimList = [
    "12S20001",
    "12S20002",
    "12S20003",
    "12S20004",
    "12S20005",
    "12S20006",
    "12S20007",
    "12S20008",
    "12S20009",
    "12S20010",
    "12S20011",
    "12S20012",
    "12S20013",
    "12S20014",
    "12S20015",
    "12S20016",
    "12S20017",
    "12S20018",
    "12S20019",
    "12S20020"
  ];

  late List<bool> hadirList;
  List<Mahasiswa> daftarMahasiswa = [];

  
  late String namaMataKuliah;
  late String kodeMataKuliah;
  late String dosenPengampu;
  late String pegawaiId;
  late String lokasiPerkuliahan;
  late String sesi;
  late String jenisPerkuliahan;
  late String waktuPerkuliahan;

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences();

    hadirList = List<bool>.filled(mahasiswaList.length, false);
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaMataKuliah = prefs.getString('mata_kuliah') ?? '';
      kodeMataKuliah = prefs.getString('kode_mk') ?? '';
      dosenPengampu = prefs.getString('dosenPengampu') ?? '';
      pegawaiId = prefs.getString('penugasanPengajarId') ?? '';
      lokasiPerkuliahan = prefs.getString('lokasiId') ?? '';
      sesi = prefs.getString('sesi') ?? '';
      jenisPerkuliahan = prefs.getString('jenisPerkuliahan') ?? '';
      waktuPerkuliahan = prefs.getString('waktuMulai') ?? '';
    });
  }

 

  void _handleSubmit() async {
    await _savePresensi(); 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LaporanPage()),
    );
    print('sukses');
  }

  Future<void> _savePresensi() async {
    daftarMahasiswa.clear();
    for (int i = 0; i < mahasiswaList.length; i++) {
      daftarMahasiswa.add(
        Mahasiswa(
          nama: mahasiswaList[i],
          nim: nimList[i],
          hadir: hadirList[i],
        ),
      );
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'presensiMahasiswa',
      daftarMahasiswa.map(
        (mahasiswa) =>
            '${mahasiswa.nama}-${mahasiswa.nim}-${mahasiswa.hadir ? 'Hadir' : 'Tidak Hadir'}',
      ).toList(),
    );
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
          'Presensi Mata Kuliah',
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Table(
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
                                  style: TextStyle(fontSize: 12,),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  mahasiswaList[index],
                                  style: TextStyle(fontSize: 12,),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Checkbox(
                                value: hadirList[index],
                                onChanged: (value) {
                                  setState(() {
                                    hadirList[index] = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Submit'),
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
