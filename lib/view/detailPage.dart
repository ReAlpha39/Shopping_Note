import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoping_note/models/belanja_harian.dart';
import 'package:shoping_note/models/item_belanja.dart';
import 'package:shoping_note/view/formPage.dart';

class DetailPage extends StatefulWidget {
  final tanggal;

  const DetailPage({this.tanggal});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final formatCurrency = NumberFormat('###,###');
  final dateFormat = DateFormat('yyyy-MM-dd');
  var dataRef = Firestore.instance.collection('Daftar Belanja');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Belanja'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: dataHariIni(),
          )
        ],
      ),
      body: _bodyHome(context),
    );
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
        Text('Hari ini', style: TextStyle(fontSize: 13),),
        Text('Rp. ${formatCurrency.format(uangS)}', style: TextStyle(fontSize: 16),)
      ],
    );
  }

    Widget _bodyHome(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Daftar Belanja').document(widget.tanggal).collection(widget.tanggal).snapshots(),
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
    final item = ItemBelanja.fromMap(data.data);
    return Padding(
      key: ValueKey(item.nama),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.shopping_cart),                         
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.nama, style: TextStyle(fontSize: 16),),
            Text('Rp. ' + '${formatCurrency.format(item.harga)}', style: TextStyle(fontSize: 16),)
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text(item.deskripsi),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green,),
                  onPressed: (){
                    editData(data.documentID);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red,),
                  onPressed: () {
                    _delete(data.documentID);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _delete(String id) async {
    var db = Firestore.instance.collection('Daftar Belanja');
    var delDoc = db.document(widget.tanggal).collection(widget.tanggal).document(id);
    await delDoc.delete();
    var dataDoc = await db.document(widget.tanggal).collection(widget.tanggal).getDocuments();
    if(dataDoc.documents.isEmpty){
      await db.document(widget.tanggal).delete();
    }else{
      updateDocHarian(db.document(widget.tanggal).collection(widget.tanggal), widget.tanggal);
    }
  }

  updateDocHarian(CollectionReference collectionReference, String doc) async {
    var dataItem = await collectionReference.getDocuments();
    int jumItem = dataItem.documents.length;
    BelanjaHarian belanjaHarian = BelanjaHarian(
      tanggal: DateTime.parse(doc),
      jumlahDoc: jumItem,
      totalPengeluaran: counterPengeluaran(dataItem)
    );
    await Firestore.instance.collection('Daftar Belanja')
    .document(doc).updateData(belanjaHarian.toMap());
  }

  int counterPengeluaran(QuerySnapshot querySnapshot){
    int jumItem = querySnapshot.documents.length;
    int jumlahUang = 0;
    int index = 0;
    do {
      var data = ItemBelanja.fromMap(querySnapshot.documents[index].data);
      var uang = data.harga;
      jumlahUang = jumlahUang + uang;
      index++;
    } while (index < jumItem);
    return jumlahUang;
  }
  
  editData(String id) {
    String edit = 'Edit Catatan';
    Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(
      title: edit,
      tanggal: widget.tanggal,
      docID: id,
    )));
  }
}