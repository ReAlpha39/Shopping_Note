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
  final formatCurrency = NumberFormat('###,###');
  final dateFormat = DateFormat('yyyy-MM-dd');
  var dataRef = Firestore.instance.collection('Daftar Belanja');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekap Belanja'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          dataHariIni()
        ],
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

  Widget dataHariIni(){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Daftar Belanja').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return CircularProgressIndicator();
          return pengeluaran(snapshot.data);
      },
    );
  }

  Widget pengeluaran(QuerySnapshot querySnapshot){
    int jumItem = querySnapshot.documents.length;
    int index = 0;
    int uangS = 0;
    var now = DateTime.now();
    String tglSekarang = dateFormat.format(now);
    do {
      var dataDoc = BelanjaHarian.fromMap(querySnapshot.documents[index].data);
      var tglS = dateFormat.format(dataDoc.tanggal);
      if(tglSekarang == tglS){
        uangS = dataDoc.totalPengeluaran;
        break;
      }
      index++;
    } while (index < jumItem);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Hari ini', style: TextStyle(fontSize: 15),),
        Text('Rp. ${formatCurrency.format(uangS)}', style: TextStyle(fontSize: 15),)
      ],
    );
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