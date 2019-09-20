import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController namaC = TextEditingController();
  TextEditingController deskC = TextEditingController();
  TextEditingController hargaC = TextEditingController();
  final dateFormat = DateFormat('dd-MM-yyyy');
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Form(
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
          ),
          TextFormField(
            controller: namaC,
            decoration: InputDecoration(
              labelText: 'Nama'
            ),
            
          ),
          TextFormField(
            controller: deskC,
            decoration: InputDecoration(
              labelText: 'Deskripsi'
            ),
            
          ),
          TextFormField(
            controller: hargaC,
            decoration: InputDecoration(
              labelText: 'Harga'
            ),
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
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {},
            )
          ],)
        ]),
      ),
      
    );
  }
}