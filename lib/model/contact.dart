class Contact {
  int? id; // id bisa null saat insert baru
  String namaKontak;
  String nomorTelepon;

  Contact({this.id, required this.namaKontak, required this.nomorTelepon});

  // Mapping dari Map ke Object
  factory Contact.fromMapObject(Map<String, dynamic> map) {
    return Contact(
      id: map['id'], // Pastikan ini diisi
      namaKontak: map['namaKontak'],
      nomorTelepon: map['nomorTelepon'],
    );
  }

  // Mapping dari Object ke Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'namaKontak': namaKontak,
      'nomorTelepon': nomorTelepon,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
