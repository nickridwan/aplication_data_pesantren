import 'package:app_pesantren/Page/menu_filter.dart';
import "package:http/http.dart" as http;
// import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'Page/FormData.dart';
import 'Page/detail.dart';
import 'model/santri_model.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: myHomePage(),
    );
  }
}

class myHomePage extends StatefulWidget {
  myHomePage({Key? key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  static List<SantriModel> data = [];
  bool loading = false;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool cekData = true;

  // get data
  Future<void> getSantri() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http
          .get(Uri.parse("http://192.168.10.7:8081/db_pesantren/getData.php"));
      print(response.body);
      data = (json.decode(response.body) as List?) != null &&
              (json.decode(response.body) as List).isNotEmpty
          ? (json.decode(response.body) as List)
              .map((f) => SantriModel.fromJson(f))
              .toList()
          : [];
    } catch (e) {
      print('error $e');
    }
    setState(() {
      loading = false;
    });
  }

// Loading
  Future<void> RefreshData() async {
    await Future.delayed(Duration(seconds: 1));
    InitData();
    setState(() {
      getSantri();
    });
  }

// Proses Loading
  void InitData() {
    data.clear();
    getSantri();
  }

  @override
  void initState() {
    super.initState();
    // Get Data
    getSantri();
    // Loading Pull
    InitData();
    // Search
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      (enteredKeyword.isEmpty)
          ? data
          : data
              .where((Element) => Element.nameSantri!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
      print(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Santri"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => addFormData())))
              .then((value) => getSantri())),
      body: !loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            onChanged: (value) =>
                                _runFilter(searchController.text),
                            controller: searchController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                filled: true,
                                // fillColor: Colors.transparent,
                                hintText: "Search...",
                                prefixIcon: Icon(Icons.search_rounded)),
                          ),
                        ),
                      ),
                      // FILTER BOTTOM SHEET
                      Container(
                        color: Colors.grey[200],
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: IconButton(
                            hoverColor: Colors.green,
                            onPressed: () => showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                context: context,
                                builder: (context) {
                                  return menuFilter();
                                }),
                            icon: Icon(Icons.filter_list_alt),
                          ),
                        ),
                      )
                    ],
                  ),
                  // Widget List Builder
                  Expanded(
                    child: RefreshIndicator(
                        onRefresh: RefreshData,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(5),
                          itemCount: data.isEmpty ? 0 : data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              semanticContainer: true,
                              borderOnForeground: true,
                              elevation: 1.8,
                              child: ListTile(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: ((context) => detail(
                                              data: data[index],
                                            ))))
                                    .then((value) => getSantri()),
                                leading: CircleAvatar(
                                  child: Icon(Icons.people_alt_outlined),
                                ),
                                title: Text(data[index].nameSantri ?? '-'),
                                subtitle: Row(
                                  children: [
                                    Text(data[index].kelas ?? '-',
                                        style: TextStyle(color: Colors.green)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 3, left: 3),
                                      child: Text("-"),
                                    ),
                                    Text(data[index].alamat ?? '-'),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
              color: Colors.greenAccent,
            )),
    );
  }
}
