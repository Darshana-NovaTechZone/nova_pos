// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListItem {
  int id;
  String pName;
  String cName;
  String pcs;
  int qnt;
  int cartP;

  // other attributes

  ListItem(
    this.id,
    this.pName,
    this.cName,
    this.pcs,
    this.qnt,
    this.cartP,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pName': pName,
      'cName': cName,
      'pcs': pcs,
      'qnt': qnt,
      'cartP': cartP,
    };
  }

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      map['id'] as int,
      map['pName'] as String,
      map['cName'] as String,
      map['pcs'] as String,
      map['qnt'] as int,
      map['cartP'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListItem.fromJson(String source) => ListItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
