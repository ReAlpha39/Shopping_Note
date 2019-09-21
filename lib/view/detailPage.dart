import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoping_note/models/data.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final tanggal;

  const DetailPage({this.tanggal});
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
      stream: Firestore.instance.collection('daftarBelanja').document(widget.tanggal).collection(widget.tanggal).snapshots(),
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
    final formatCurrency = NumberFormat('###,###');
    return Padding(
      key: ValueKey(item.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.shopping_cart),                         
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.nama, style: TextStyle(fontSize: 20),),
            Text('Rp. ' + '${formatCurrency.format(item.harga)}', style: TextStyle(fontSize: 20),)
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