
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/pontosturisticos.dart';
import 'conteudo_form_dialog.dart';
import 'filtro_page.dart';

class PontosTuristicosPage extends StatefulWidget {

  @override
  _PontosTuristicosState createState() => _PontosTuristicosState();

}

  class _PontosTuristicosState extends State<PontosTuristicosPage>{

  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZAR = 'visualizar';
  static const ACAO_EDITAR = 'editar';


  final pontosTuristicos = <PontosTuristicos>
  [
    PontosTuristicos(
        id: 1,
        descricao: 'Fratelli',
        inclusao: DateTime.now().add(Duration(days: 5)),
        diferencial: 'Pizzaria'
    )
  ];

  var _ultimoId = 1;

  @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: _criarAppBar(),
        body: _criarBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: _abrirForm,
          tooltip: 'Novo ponto turistico',
          child: Icon(Icons.add),
        ),

      );
  }

  void _abrirForm({PontosTuristicos? pontoAtual, int? index, bool? modovisualizar}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(pontoAtual == null ? 'Novo Ponto Turistico' : 'Alterar ponto turistico ${pontoAtual.id}'),
            content: ConteudoFormDialog(key: key, pontosTuristicos: pontoAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              if (modovisualizar == null || modovisualizar == false)
                TextButton(
                  onPressed: () {
                    if (key.currentState != null && key.currentState!.dadosValidados()){
                      setState(() {
                        final novoPonto = key.currentState!.novoPonto;
                        if (index == null){
                          novoPonto.id = ++_ultimoId;
                        }else{
                          pontosTuristicos[index] = novoPonto;
                        }
                        pontosTuristicos.add(novoPonto);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Salvar'),
                ),
            ],
          );
        }
    );
  }
  AppBar _criarAppBar(){
    return AppBar(
      title : const Text ('Gerenciador de Tarefas'),
      actions: [
        IconButton(
            onPressed: _abrirPaginaFiltro,
            icon: Icon(Icons.filter_list)),
      ],
    );
  }

 Widget _criarBody(){
    if( pontosTuristicos.isEmpty){
      return Center(
        child: const Text('Nenhum ponto turistico cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
      );
    }
    return ListView.separated(
        itemCount: pontosTuristicos.length,
        itemBuilder: (BuildContext context, int index){
          final tarefa = pontosTuristicos[index];
          return PopupMenuButton<String>(
              child: ListTile(
                title: Text('${tarefa.id} - ${tarefa.descricao}'),
                subtitle: Text('Data de Inclusão - ${tarefa.dtinclusaoFomatado}'),
          ),
            itemBuilder: (BuildContext context) => _criarItensMenu(),
            onSelected: (String valorSelecionado){
                if(valorSelecionado == ACAO_EDITAR){
                  _abrirForm(pontoAtual: tarefa, index: index, modovisualizar: false);
                }else if (valorSelecionado == ACAO_VISUALIZAR) {
                  _abrirForm(pontoAtual: tarefa, index: index, modovisualizar: true);
                }else {
                  _excluir(index);
                }
            }
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        );
  }
  void _excluir(int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red,),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Atenção'),
                )
              ],
            ),
            content: Text('Esse registro será deleteado permanentemente'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar')
           ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {
              pontosTuristicos.removeAt(indice);
          });
          },
                child: Text("OK")
          )
        ],
          );
       }
    );
  }
  List<PopupMenuEntry<String>> _criarItensMenu(){
    return[
      PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children:  [
            Icon(Icons.visibility, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left:10),
              child: Text('Visualizar'),
            )
          ],
        ),
      ),
      PopupMenuItem(
          value: ACAO_EDITAR,
          child: Row(
          children:  [
          Icon(Icons.edit, color: Colors.black),
          Padding(
              padding: EdgeInsets.only(left:10),
              child: Text('Editar'),
            )
         ],
        ),
      ),
      PopupMenuItem(
        value: ACAO_EXCLUIR,
        child: Row(
          children:  [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left:10),
              child: Text('Excluir'),
            )
          ],
        ),
      )
    ];
  }

  void _abrirPaginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores){
      if ( alterouValores == true){

        }
      }
    );
  }
}