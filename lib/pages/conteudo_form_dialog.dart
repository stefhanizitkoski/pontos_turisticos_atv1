
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/pontosturisticos.dart';

class ConteudoFormDialog extends StatefulWidget{
  final PontosTuristicos? pontosTuristicos;

  ConteudoFormDialog({Key? key, this.pontosTuristicos}) : super (key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}
class ConteudoFormDialogState extends State<ConteudoFormDialog>{

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final inclusaoController = TextEditingController();
  final diferencialController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    if (widget.pontosTuristicos != null){
      descricaoController.text = widget.pontosTuristicos!.descricao;
      inclusaoController.text = widget.pontosTuristicos!.dtinclusaoFomatado;
      diferencialController.text = widget.pontosTuristicos!.diferencial!;
    } else {
      inclusaoController.text = _dateFormat.format(DateTime.now());
    }
  }

  Widget build(BuildContext context){
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe a descrição';
                }
                return null;
                },
        ),
            TextFormField(
              controller: diferencialController,
              decoration: InputDecoration(labelText: 'Diferencial'),
            ),
          TextFormField(
            controller: inclusaoController,
            decoration: InputDecoration(labelText: 'Data de inclusão',
            prefixIcon: IconButton(
              onPressed: _mostrarCalendario,

              icon: Icon(Icons.calendar_today),
          ),
          suffixIcon: IconButton(
            onPressed: () => inclusaoController.clear(),
            icon: Icon(Icons.close),

            ),
            ),
            readOnly: true,
          ),
        ],
        )
        );
    }
    void _mostrarCalendario(){
    final dataFormatada = inclusaoController.text;
    var data = DateTime.now();

    if(dataFormatada.isNotEmpty){
      data = _dateFormat.parse(dataFormatada);

    }
    showDatePicker(
        context: context,
        initialDate: data,
        firstDate: data.subtract(Duration(days:365 + 5)),
        lastDate: data.add(Duration(days:365 + 5)),
    ).then((DateTime? dataSelecionada){
      if(dataSelecionada != null){
        setState(() {
          inclusaoController.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  PontosTuristicos get novoPonto => PontosTuristicos(
      id: widget.pontosTuristicos?.id ?? 0,
      descricao: descricaoController.text,
      inclusao: _dateFormat.parse(inclusaoController.text),
      diferencial: diferencialController.text
  );
}
