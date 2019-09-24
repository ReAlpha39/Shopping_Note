import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoping_note/models/belanja_harian.dart';
import 'package:shoping_note/view/detailPage.dart';
import 'package:shoping_note/view/formPage.dart';
import 'package:intl/intl.dart';

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(title: 'Tambah Catatan',)));
  }

  Widget _bodyHome(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Daftar Belanja').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 14),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = BelanjaHarian.fromMap(data.data);
    final formatCurrency = NumberFormat('###,###');
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Padding(
      key: ValueKey(dateFormat.format(record.tanggal)),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.monetization_on, size: 30,),
        title: Text(dateFormat.format(record.tanggal), style: TextStyle(fontSize: 16),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Jumlah Belanja: ' + record.jumlahDoc.toString(), style: TextStyle(fontSize: 15),),
            Text('Jumlah Pengeluaran: Rp. ' + '${formatCurrency.format(record.totalPengeluaran)}', style: TextStyle(fontSize: 15),)
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(tanggal: data.documentID)));
          },
        ),
      ),
    );
  }
}