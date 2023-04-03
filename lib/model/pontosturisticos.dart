import 'package:intl/intl.dart';

class PontosTuristicos{

  static const CAMPO_ID = 'id';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DT_INCLUSAO = 'inclusao';
  static const CAMPO_DIFERENCIAL= 'diferencial';

  int id;
  String descricao;
  DateTime inclusao ;
  String? diferencial;

  PontosTuristicos({required this.id, required this.descricao, required this.inclusao, this.diferencial});

  String get dtinclusaoFomatado {
    if (inclusao == null) {
      return ' ';
    }
    return DateFormat('dd/MM/yyyy').format(inclusao!);

  }
}