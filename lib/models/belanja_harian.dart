import 'dart:convert';

class BelanjaHarian {
    DateTime tanggal;
    int jumlahDoc;
    int totalPengeluaran;

    BelanjaHarian({
        this.tanggal,
        this.jumlahDoc,
        this.totalPengeluaran,
    });

    factory BelanjaHarian.fromJson(String str) => BelanjaHarian.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BelanjaHarian.fromMap(Map<String, dynamic> json) => BelanjaHarian(
        tanggal: DateTime.parse(json["Tanggal"]),
        jumlahDoc: json["jumlahDoc"],
        totalPengeluaran: json["Total Pengeluaran"],
    );

    Map<String, dynamic> toMap() => {
        "Tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "jumlahDoc": jumlahDoc,
        "Total Pengeluaran": totalPengeluaran,
    };
}