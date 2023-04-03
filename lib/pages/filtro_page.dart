
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/pontosturisticos.dart';

class FiltroPage extends StatefulWidget {

  static const chaveUserOrdenacaoDecrescente = 'userOrdenacaoDecrescente';
  static const chaveCampoDescricao = 'campoDescricao';
  static const chaveCampoDiferenciais = 'CampoDiferencial';
  static const routeName = '/filtro';
  static const chaveCampoOrdenacao = 'campoOrdenacao';


  @override
  _FiltroPageState createState() => _FiltroPageState();

}

class _FiltroPageState extends State<FiltroPage> {

  final _campoParaOrdenacao = {
    PontosTuristicos.CAMPO_ID: 'Codigo',
    PontosTuristicos.CAMPO_DESCRICAO: 'Descrição',
    PontosTuristicos.CAMPO_DT_INCLUSAO: 'Inclusão',
    PontosTuristicos.CAMPO_DIFERENCIAL: 'Diferencial'

  };

  late final SharedPreferences _prefes;
  final _descricaoController = TextEditingController();
  final _diferencialController = TextEditingController();
  String _campoOrdenacao = PontosTuristicos.CAMPO_ID;
  bool _usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void iniiState(){
    super.initState();
    _carregaDadosSharedPreferences();

  }

  void _carregaDadosSharedPreferences() async {
    _prefes = await SharedPreferences.getInstance();
    setState(() {
      _campoOrdenacao = _prefes.getString(FiltroPage.chaveCampoOrdenacao) ?? PontosTuristicos.CAMPO_ID;
      _usarOrdemDecrescente = _prefes.getBool(FiltroPage.chaveUserOrdenacaoDecrescente) == true;
      _descricaoController.text = _prefes.getString(FiltroPage.chaveCampoDescricao) ?? '' ;
      _diferencialController.text = _prefes.getString(FiltroPage.chaveCampoDiferenciais) ?? '' ;
    });

  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text('Filtro e Ordenação'),
        ),
          body: _criarBody(),
    ),

      onWillPop: _onVoltarClick,
    );

  }

  Widget _criarBody(){
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top:10),
          child: Text( 'Campos para a Ordenação'),
          ),
        for (final campo in _campoParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                  value: campo, 
                  groupValue: _campoOrdenacao, 
                  onChanged: _onCampoParaOrdenacaoChanged,
            ),
            Text(_campoParaOrdenacao[campo]!),
          ],
        ),
        Divider(),
        Row(
          children: [
            Checkbox(
                value: _usarOrdemDecrescente,
                onChanged: _onUsarOrdemDecrescenteChanged,
            ),
            Text('Favor usar ordem decrescente'),
          ],
        ),
        Divider(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'A descrição começa com:',
          ),
            controller: _descricaoController ,
            onChanged: _onFiltroDescricaoChanged,
          ),
        )
      ],
    );
  }

  void _onCampoParaOrdenacaoChanged(String? valor){
    _prefes.setString(FiltroPage.chaveCampoOrdenacao, valor!);
    _alterouValores = true;
    setState(() {
      _campoOrdenacao = valor;
    });

  }

  void _onUsarOrdemDecrescenteChanged (bool? valor){
    _prefes.setBool(FiltroPage.chaveUserOrdenacaoDecrescente, valor!);
    _alterouValores = true;
    setState(() {
      _usarOrdemDecrescente = valor;
    });

  }

  void _onFiltroDescricaoChanged (String? valor){
    _prefes.setString(FiltroPage.chaveCampoDescricao, valor!);
    _alterouValores = true;
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }
}
