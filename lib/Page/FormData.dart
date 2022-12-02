import 'package:app_pesantren/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class addFormData extends StatefulWidget {
  final SantriModel? data;
  const addFormData({Key? key, this.data}) : super(key: key);

  @override
  State<addFormData> createState() => _addFormDataState();
}

class _addFormDataState extends State<addFormData> {
  TextEditingController NameSantriController = TextEditingController();
  TextEditingController KelasController = TextEditingController();
  TextEditingController NameWaliController = TextEditingController();
  TextEditingController NoHpController = TextEditingController();
  TextEditingController ProfessiController = TextEditingController();
  TextEditingController AlamatController = TextEditingController();
  int count = 0;

  @override
  void initState() {
    selectedValue = kelasItems[0];
    super.initState();
    if (widget.data != null) {
      NameSantriController.text = widget.data!.nameSantri!;
      KelasController.text = widget.data!.kelas!;
      NameWaliController.text = widget.data!.waliSantri!;
      NoHpController.text = widget.data!.noHp!;
      ProfessiController.text = widget.data!.pekerjaan!;
      AlamatController.text = widget.data!.alamat!;
    }
  }

// tambah data
  Future<void> addData() async {
    final res = await http.post(
        Uri.parse("http://192.168.10.7:8081/db_pesantren/addData.php"),
        body: {
          "name_santri": NameSantriController.text,
          "kelas": KelasController.text,
          "wali_santri": NameWaliController.text,
          "no_hp": NoHpController.text,
          "pekerjaan": ProfessiController.text,
          "alamat": AlamatController.text
        }).then((value) => {
          if (value == true)
            {
              Alert(
                context: context,
                title: "Success",
                desc: "Data Telah Disimpan",
                type: AlertType.success,
                buttons: [
                  DialogButton(
                      child: Text("OK", style: TextStyle(fontSize: 20)),
                      onPressed: () =>
                          Navigator.of(context).popUntil((_) => count++ >= 2))
                ],
              )
            }
          else
            {
              Alert(
                context: context,
                title: "Failed",
                desc: "Data Gagal Disimpan",
                type: AlertType.error,
                buttons: [
                  DialogButton(
                      child: Text("OK", style: TextStyle(fontSize: 20)),
                      onPressed: () => Navigator.pop(context))
                ],
              )
            }
        });
  }

  // edit data
  Future<void> editData() async {
    final res = await http.post(
        Uri.parse("http://192.168.10.7:8081/db_pesantren/editData.php"),
        body: {
          "id": widget.data!.id,
          "name_santri": NameSantriController.text,
          "kelas": KelasController.text,
          "wali_santri": NameWaliController.text,
          "no_hp": NoHpController.text,
          "pekerjaan": ProfessiController.text,
          "alamat": AlamatController.text
        });
    Navigator.pop(context);
  }

  kelasModel? selectedValue;
  List<kelasModel> kelasItems = [
    kelasModel(1, "7A"),
    kelasModel(2, "7B"),
    kelasModel(3, "7C"),
    kelasModel(4, "8A"),
    kelasModel(5, "8B"),
    kelasModel(6, "8C"),
    kelasModel(7, "9A"),
    kelasModel(8, "9B"),
    kelasModel(9, "9C"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data != null ? "EDIT DATA" : "ADD DATA"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Column(
              children: [
                TextFormField(
                  controller: NameSantriController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Masukkan Nama Santri",
                      labelText: "Nama Santri"),
                ),
                TextFormField(
                  controller: KelasController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.class_),
                      hintText: "Masukkan Kelas",
                      labelText: "Kelas"),
                ),
                TextFormField(
                  controller: NameWaliController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.people_alt_rounded),
                      hintText: "Masukkan Nama Wali",
                      labelText: "Nama Wali"),
                ),
                TextFormField(
                  controller: NoHpController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.call),
                      hintText: "Masukkan No Telepon",
                      labelText: "No Handphone"),
                ),
                TextFormField(
                  controller: ProfessiController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.work_sharp),
                      hintText: "Masukkan Profesi",
                      labelText: "Professi"),
                ),
                TextFormField(
                  controller: AlamatController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.location_city),
                      hintText: "Masukkan Alamat",
                      labelText: "Alamat"),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                if (widget.data == null)
                  ElevatedButton(
                      child: Text("Tambah"),
                      onPressed: () {
                        addData();
                        Navigator.pop(context);
                      })
                else
                  ElevatedButton(
                      child: Text("Edit"),
                      onPressed: () {
                        editData();
                        Navigator.pop(context);
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class kelasModel {
  int? id;
  String? kelas;
  kelasModel(this.id, this.kelas);
}
