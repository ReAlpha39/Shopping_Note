import 'dart:convert';

class ItemBelanja {
    String nama;
    String deskripsi;
    int harga;

    ItemBelanja({
        this.nama,
        this.deskripsi,
        this.harga,
    });

    factory ItemBelanja.fromJson(String str) => ItemBelanja.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ItemBelanja.fromMap(Map<String, dynamic> json) => ItemBelanja(
        nama: json["Nama"],
        deskripsi: json["Deskripsi"],
        harga: json["Harga"],
    );

    Map<String, dynamic> toMap() => {
        "Nama": nama,
        "Deskripsi": deskripsi,
        "Harga": harga,
    };
}