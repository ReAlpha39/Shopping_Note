import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController namaC = TextEditingController();
  TextEditingController deskC = TextEditingController();
  TextEditingController hargaC = TextEditingController();
  final dateFormat = DateFormat('dd-MM-yyyy');
  DateTime date;
  String _tanggal;
  String _nama;
  String _deskripsi;
  int _harga;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          DateTimeField(
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
            onSaved: (value) {_nama = value;},
          ),
          TextFormField(
            controller: deskC,
            decoration: InputDecoration(
              labelText: 'Deskripsi'
            ),
            onSaved: (value) {_deskripsi = value;},
          ),
          TextFormField(
            controller: hargaC,
            decoration: InputDecoration(
              labelText: 'Harga'
            ),
            onSaved: (value) {_harga = int.parse(value);},
            validator: (i) {
              if (i == null) {
                return 'harga harus diisi';
              } if (i == '') {
                return 'Harga harus berupa angka';
              } else {
                return null;
              }
            },
          ),
          Row(children: <Widget>[
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
                  updateDoc(_tanggal, _nama, _deskripsi, _harga);
                  Navigator.pop(context);
                }
              },
            )
          ],)
        ]),
      ),
      
    );
  }
  void updateDoc(String doc, String nama, String desk, int harga) async {
    await Firestore.instance.collection('daftarBelanja')
        .document(doc)
        .collection(doc)
        .document(nama)
        .setData({'Nama': nama, 'Deskripsi': desk, 'Harga': harga});
    var dataS = await Firestore.instance.collection('daftarBelanja')
        .document(doc)
        .collection(doc)
        .getDocuments();
    var nilai = dataS.documents.length;
    int totalBelanja;
    var pengeluaran = await Firestore.instance.collection('daftarBelanja')
        .document(doc)
        .collection(doc)
        .document(nama).get();
    totalBelanja = pengeluaran.data['Harga'];
    var dataAwal = await Firestore.instance.collection('daftarBelanja')
        .document(doc).get();
    int valueAwal = dataAwal.data['Total Pengeluaran'];
    if(valueAwal != null){
      await Firestore.instance.collection('daftarBelanja')
        .document(doc).setData({'jumlahDoc': nilai, 'Total Pengeluaran': valueAwal + totalBelanja});
    }else{
      await Firestore.instance.collection('daftarBelanja')
        .document(doc).setData({'jumlahDoc': nilai, 'Total Pengeluaran': totalBelanja});
    }
    
  }
}