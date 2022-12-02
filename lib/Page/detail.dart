import 'package:app_pesantren/widget/popUpMenu.dart';
import 'package:app_pesantren/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../model/santri_model.dart';
import 'FormData.dart';
import '../main.dart';

class detail extends StatefulWidget {
  SantriModel data;
  detail({required this.data, this.onTap});
  final GestureTapCallback? onTap;
  @override
  State<detail> createState() => _detailState();
}

final StyleFont = TextStyle(fontSize: 16);

class _detailState extends State<detail> {
  bool loading = false;
  List<SantriModel> data = [];
  
  // delete data
  Future<void> deleteData() async {
    final res = await http.post(
        Uri.parse("http://192.168.10.7:8081/db_pesantren/deleteData.php"),
        body: {"id": widget.data.id});
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => myHomePage())));
  }

  void Confirm() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text("Yakin Hapus ${widget.data.nameSantri}?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      deleteData();
                      Alert(
                        context: context,
                        title: "Success",
                        desc: "Data Telah Disimpan",
                        type: AlertType.success,
                        buttons: [
                          DialogButton(
                              child: Text("OK", style: TextStyle(fontSize: 20)),
                              onPressed: () => Navigator.pop(context))
                        ],
                      );
                    },
                    child: Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red, onPrimary: Colors.white)),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                    ))
              ],
              elevation: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data.nameSantri}"),
        actions: [
          popUpMenu(
              ListMenu: [
                PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.edit_note),
                      title: Text("Edit"),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => addFormData(
                                data: widget.data,
                              ))))),
                ),
                PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text("Delete"),
                  onTap: () => Confirm(),
                ))
              ],
              icon: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.more_vert)))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        child: ListView(children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    height: 100.0,
                    width: 80,
                    color: Colors.green[100],
                    child: Icon(Icons.person),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.data.nameSantri}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Container(
                            height: .5,
                            width: 30,
                            color: Colors.grey,
                          ),
                        ),
                        Text("${widget.data.kelas}",
                            style: TextStyle(
                              fontSize: 15,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Data Pribadi",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [Text("Nama Wali: ${widget.data.waliSantri}")],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [Text("No HP: ${widget.data.noHp}")],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [Text("Pekerjaan: ${widget.data.pekerjaan}")],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [Text("Alamat: ${widget.data.alamat}")],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
