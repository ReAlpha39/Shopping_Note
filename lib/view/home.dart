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
      body: _bodyHome(context),
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

  Widget _bodyHome(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('daftarBelanja').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.monetization_on, size: 30,),
        title: Text(record.reference.documentID),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Jumlah belanja: ' + record.jumlahDoc.toString(), style: TextStyle(fontSize: 20),),
            Text('Jumlah pengeluaran: ' + record.pengeluaran.toString(), style: TextStyle(fontSize: 20),)
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: () {},
        ),
      ),
      
    );
  }
}

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