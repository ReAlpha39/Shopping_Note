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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              DateTimeField(
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
                        updateDoc(_tanggal, _nama, _deskripsi, _harga);
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
    if(dataAwal.data == null){
      await Firestore.instance.collection('daftarBelanja')
        .document(doc).setData({'jumlahDoc': nilai, 'Total Pengeluaran': totalBelanja});
    }else{
      int valueAwal = dataAwal.data['Total Pengeluaran'];
      await Firestore.instance.collection('daftarBelanja')
        .document(doc).setData({'jumlahDoc': nilai, 'Total Pengeluaran': valueAwal + totalBelanja});
    }
  }
}