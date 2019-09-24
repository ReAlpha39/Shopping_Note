import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoping_note/models/data.dart';
import 'package:intl/intl.dart';
import 'package:shoping_note/models/item_belanja.dart';
import 'package:shoping_note/view/formPage.dart';

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
    final formatCurrency = NumberFormat('###,###');
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
                    editData(item.nama);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red,),
                  onPressed: () {
                    _delete(item.nama);
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
    int totalBelanja;
    var pengeluaran = await db.document(widget.tanggal)
        .collection(widget.tanggal)
        .document(id).get();
    var dataAwal = await db.document(widget.tanggal).get();
    totalBelanja = pengeluaran.data['Harga'];
    await db.document(widget.tanggal).collection(widget.tanggal)
    .document(id).delete();
    int valueAwal = dataAwal.data['Total Pengeluaran'];
    var dataS = await db.document(widget.tanggal)
        .collection(widget.tanggal)
        .getDocuments();
    var nilai = dataS.documents.length;
    await db.document(widget.tanggal).updateData({'jumlahDoc': nilai, 'Total Pengeluaran': valueAwal - totalBelanja});
    if(nilai == null || nilai == 0){
      await db.document(widget.tanggal).delete();
      //Navigator.pop(context);
    }
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