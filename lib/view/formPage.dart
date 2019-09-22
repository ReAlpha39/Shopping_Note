import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shoping_note/models/data.dart';

class FormPage extends StatefulWidget {

  final String title;
  final String tanggal;
  final String docID;

  const FormPage({this.title, this.tanggal, this.docID});
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController namaC = TextEditingController();
  TextEditingController deskC = TextEditingController();
  TextEditingController hargaC = TextEditingController();
  TextEditingController tanggalC = TextEditingController();
  final dateFormat = DateFormat('dd-MM-yyyy');
  DateTime date;
  String _tanggal;
  String _nama;
  String _deskripsi;
  int _harga;
  int vAwal;
  int jumUang;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              DateTimeField(
                controller: tanggalC,
                decoration: InputDecoration(
                  labelText: 'Tanggal'
                ),
                readOnly: true,
                format: dateFormat,
                initialValue: DateTime.now(),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100)
                  );
                },
                onSaved: (value) {_tanggal = dateFormat.format(value);},
              ),
              TextFormField(
                controller: namaC,
                decoration: InputDecoration(
                  labelText: 'Nama'
                ),
                validator: (i) {
                  if (i == ''){
                    return 'Nama harus diisi';
                  }else{
                    return null;
                  }
                },
                onSaved: (value) {_nama = value;},
              ),
              TextFormField(
                maxLines: 3,
                controller: deskC,
                decoration: InputDecoration(
                  labelText: 'Deskripsi'
                ),
                onSaved: (value) {_deskripsi = value;},
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Belanja'
                ),
                onSaved: (value) {_harga = int.parse(value);},
                validator: (i) {
                  if (i == '') {
                    return 'Total Belanja harus diisi';
                  }
                  if (int.tryParse(i) == null) {
                    return 'Total Belanja harus berupa angka';
                  } else {
                    return null;
                  }
                },
                controller: hargaC,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  RaisedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: () {
                      var form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        saveDoc(_tanggal, _nama, _deskripsi, _harga);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],),
              )
            ]),
          ),
        ),
      ),
      
    );
  }
  void saveDoc(String doc, String nama, String desk, int harga) async {
    var dbDoc = Firestore.instance.collection('daftarBelanja')
        .document(doc)
        .collection(doc);
    if(widget.docID == null){
      await dbDoc.document(nama).setData({'Nama': nama, 'Deskripsi': desk, 'Harga': harga});
    }else{
      if(doc == widget.tanggal){
        await dbDoc.document(widget.docID).updateData({'Nama': nama, 'Deskripsi': desk, 'Harga': harga});
      }else{
        
        await dbDoc.document(widget.docID).setData({'Nama': nama, 'Deskripsi': desk, 'Harga': harga});
        var dataS = await dbDoc.getDocuments();
        var nilai = dataS.documents.length;
        await Firestore.instance.collection('daftarBelanja')
        .document(doc).setData({'jumlahDoc': nilai, 'Total Pengeluaran': jumUang});
      }
    }
    var dataS = await dbDoc.getDocuments();
    var nilai = dataS.documents.length;
    moneyCounter(doc);
    updateDataDocTanggal(doc, nilai);
  }

  void updateDataDocTanggal(String doc, int nilai) async {
    var dataAwal = await Firestore.instance.collection('daftarBelanja').document(doc).get();
    if(dataAwal.data == null){
      await Firestore.instance.collection('daftarBelanja')
        .document(doc).setData({'jumlahDoc': nilai, 'Total Pengeluaran': jumUang});
    }else{
      await Firestore.instance.collection('daftarBelanja')
        .document(doc).updateData({'jumlahDoc': nilai, 'Total Pengeluaran': jumUang});
    }
  }

  void moneyCounter(String doc) async {
    var dataSnapshot = await Firestore.instance.collection('daftarBelanja')
        .document(doc)
        .collection(doc)
        .getDocuments();
    var dataL = dataSnapshot.documents;
    dataL.map((dataF) => dataHarga(dataF)).toList();
  }

  void dataHarga(DocumentSnapshot dataDoc) {
    final record = Item.fromSnapshot(dataDoc);
    var data = record.harga;
    if (jumUang == null){
      jumUang = data;
    }else{
      jumUang = jumUang + data;
    }
  }

  void initState(){
    if(widget.docID != null){
      dataAwal();
      super.initState();
    }else{
      tanggalC.text = dateFormat.format(DateTime.now());
    }
  }

  void dataAwal() async {
    var db = Firestore.instance.collection('daftarBelanja')
      .document(widget.tanggal).collection(widget.tanggal).document(widget.docID);
    var data = await db.get();
    namaC.text = data.data['Nama'];
    deskC.text = data.data['Deskripsi'];
    hargaC.text = '${data.data['Harga']}';
    tanggalC.text = widget.tanggal;
    vAwal = data.data['Harga'];
  }
}