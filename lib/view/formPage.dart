import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            decoration: InputDecoration(
              labelText: 'Nama'
            ),
            onSaved: (value) {_nama = value;},
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Deskripsi'
            ),
            onSaved: (value) {_deskripsi = value;},
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Harga'
            ),
            onSaved: (value) {_harga = int.parse(value);},
          ),
        ]),
      ),
      
    );
  }
}