import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Form(
        child: Column(children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nama'
            ),
            
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Deskripsi'
            ),
            
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Harga'
            ),
            
          )
        ]),
      ),
      
    );
  }
}