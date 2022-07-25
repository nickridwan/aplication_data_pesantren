class SantriModel {
  String? id;
  String? nameSantri;
  String? kelas;
  String? waliSantri;
  String? noHp;
  String? pekerjaan;
  String? alamat;

  SantriModel(
      {this.id,
      this.nameSantri,
      this.kelas,
      this.waliSantri,
      this.noHp,
      this.pekerjaan,
      this.alamat});

  SantriModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameSantri = json['name_santri'];
    kelas = json['kelas'];
    waliSantri = json['wali_santri'];
    noHp = json['no_hp'];
    pekerjaan = json['pekerjaan'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_santri'] = this.nameSantri;
    data['kelas'] = this.kelas;
    data['wali_santri'] = this.waliSantri;
    data['no_hp'] = this.noHp;
    data['pekerjaan'] = this.pekerjaan;
    data['alamat'] = this.alamat;
    return data;
  }
}

List<SantriModel> allData = [
  SantriModel(
      nameSantri: "Kecoa",
      kelas: "10A",
      waliSantri: "Sudirman",
      noHp: "0980",
      pekerjaan: "ngasah",
      alamat: "ngajuk"),
  SantriModel(
      nameSantri: "Kucing",
      kelas: "10B",
      waliSantri: "Sudirman",
      noHp: "0980",
      pekerjaan: "ngasah",
      alamat: "ngajuk"),
  SantriModel(
      nameSantri: "Minang",
      kelas: "10A",
      waliSantri: "Sudirman",
      noHp: "0980",
      pekerjaan: "ngasah",
      alamat: "ngajuk"),
];
