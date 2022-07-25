import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
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
  myHomePage({Key? key}) : super(key: key);

  get keyword => null;

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  List<SantriModel> data = [];
  bool loading = false;
  TextEditingController searchController = TextEditingController();

  // get data
  Future<void> getSantri() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http
          .get(Uri.parse("http://192.168.10.5:8081/db_pesantren/getData.php"));
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
    print("berhasil loading");
    await Future.delayed(Duration(seconds: 1));
    InitData();
    setState(() {});
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
    setState(() {
      data = data
          .where((element) => element.nameSantri!
              .toLowerCase()
              .contains(widget.keyword.toLowerCase()))
          .toList();
      print("Masuk Pencarian");
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
                            controller: searchController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                filled: true,
                                // fillColor: Colors.transparent,
                                hintText: "Search...",
                                prefixIcon: Icon(Icons.search_rounded)),
                            // onChanged: ,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey[200],
                        width: 55,
                        height: 55,
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
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            height: 3,
                                            width: 60,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Filter",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: .7,
                                                  width: 50,
                                                  color: Colors.grey[300],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                  Icons.filter_list_rounded),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Daerah"),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child: Text("Cirebon"),
                                                )),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child: Text("Kuningan"),
                                                )),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child: Text("Indramayu"),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child: Text("Cirebon"),
                                                )),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child: Text("Kuningan"),
                                                )),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child: Text("Indramayu"),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Kelas"),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child:
                                                      Center(child: Text("7")),
                                                )),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child:
                                                      Center(child: Text("8")),
                                                )),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 7),
                                                  child:
                                                      Center(child: Text("9")),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            icon: Icon(Icons.filter_list_alt),
                          ),
                        ),
                      )
                    ],
                  ),
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
                            shadowColor: Colors.orange,
                            elevation: 3,
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
                                    padding: EdgeInsets.only(right: 3, left: 3),
                                    child: Text("-"),
                                  ),
                                  Text(data[index].alamat ?? '-'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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

// Shimmer getShimmerLoading() {
//   return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ,
//       );
// }
