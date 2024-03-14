// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Contact {
  int? id;
  final String nama;
  final String number;
  String? foto;
  String? kategori;
  String? warna;
  String? date;
  Contact({
    this.id,
    required this.nama,
    required this.number,
    this.foto,
    this.kategori,
    this.warna,
    this.date,
  });

  // static List<Contact> dummy = [
  //   Contact(id: 1, nama: 'fajar', number: '0845454445454'),
  //   Contact(id: 2, nama: 'padil', number: '089945454445454'),
  // ];

  Contact copyWith({
    int? id,
    String? nama,
    String? number,
    String? foto,
    String? kategori,
    String? warna,
    String? date,
  }) {
    return Contact(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      number: number ?? this.number,
      foto: foto ?? this.foto,
      kategori: kategori ?? this.kategori,
      warna: warna ?? this.warna,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'number': number,
      'foto': foto,
      'kategori': kategori,
      'warna': warna,
      'date': date,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] != null ? map['id'] as int : null,
      nama: map['nama'] as String,
      number: map['number'] as String,
      foto: map['foto'] != null ? map['foto'] as String : null,
      kategori: map['kategori'] != null ? map['kategori'] as String : null,
      warna: map['warna'] != null ? map['warna'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Contact(id: $id, nama: $nama, number: $number, foto: $foto, kategori: $kategori, warna: $warna, date: $date)';
  }

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.number == number &&
        other.foto == foto &&
        other.kategori == kategori &&
        other.warna == warna &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        number.hashCode ^
        foto.hashCode ^
        kategori.hashCode ^
        warna.hashCode ^
        date.hashCode;
  }
}
