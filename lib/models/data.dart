import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final int jumlahDoc;
  final int pengeluaran;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['jumlahDoc'] != null),
        assert(map['Total Pengeluaran'] != null),
        jumlahDoc = map['jumlahDoc'],
        pengeluaran = map['Total Pengeluaran'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$jumlahDoc:$pengeluaran>";
}

class Item {
  final String nama;
  final String deskripsi;
  final int harga;
  final DocumentReference reference;

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Nama'] != null),
        assert(map['Deskripsi'] != null),
        assert(map['Harga'] != null),
        nama = map['Nama'],
        deskripsi = map['Deskripsi'],
        harga = map['Harga'];

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Item<$nama:$deskripsi:$harga>";
}