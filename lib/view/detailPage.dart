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
      body: _bodyHome(context),
    );
  }

    Widget _bodyHome(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('daftarBelanja').document('21-09-2019').collection('21-09-2019').snapshots(),
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
    final item = Item.fromSnapshot(data);
    return Padding(
      key: ValueKey(item.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.shopping_cart),                         
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.nama, style: TextStyle(fontSize: 20),),
            Text('Rp. ' + item.harga.toString(), style: TextStyle(fontSize: 20),)
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text(item.deskripsi),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue,),
                  onPressed: (){},
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red,),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
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