import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoping_note/view/formPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekap Belanja'),
        backgroundColor: Colors.green,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          navigateToFormPage();
        },
      ),
      
    );
  }
  void navigateToFormPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage()));
  }
}

class Record {
  final int jumlahDoc;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      :  assert(map['jumlahDoc'] != null),
        jumlahDoc = map['jumlahDoc'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$jumlahDoc>";
}