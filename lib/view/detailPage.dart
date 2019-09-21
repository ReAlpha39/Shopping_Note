import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Belanja'),
      ),
      body: Container(),
    );
  }
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