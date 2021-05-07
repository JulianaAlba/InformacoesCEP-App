import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  TextEditingController _textEditingControllerCEP = TextEditingController();
  String _resultadoDadosCep = "";

// Comunicação síncrona é de resposta instantânea
// Comunicação assíncrona requer determinado tempo (desconhecido) de resposta
  _recuperarCep() async{

    String cep =  _textEditingControllerCEP.text;
    String url = "https://viacep.com.br/ws/${cep}/json/";

    //print(cep);


    //Se o cep digitado não for nulo ou não for menos que 8, então vamos executar o código e acessar a API para obter resultados
    if ((cep != null) && (cep.length==8) ){
      http.Response resposta;
      //await quer dizer que vai aguardar a execução da resposta e só vai guardar quando receber essa resposta
      resposta = await http.get(url);

      //Decode decodifica um objeto de string para um objeto json
      //json.decode(resposta.body);
      //Como a estrutura de json é igual a lista Map, então vamos fazer a representação dessa forma, pois aí pegamos especificamente todos os campos que a API CEP nos retorna e podemos acessá-las individualmente posteriormente
      //CAPTURA DE RESPOSTA TRANSFORMANDO EM JSON E ADICIONANDO DENTRO DE UM MAP
      Map<String, dynamic> retorno = json.decode(resposta.body);
      String logradouro = retorno["logradouro"]; //os dois dados do Map devem ser escritos da mesma forma, ex logradouro e logradouro. O retonor[logradouro] = receberá um dado ao acessar a EPI, cujo valor é dinâmico
      String complemento = retorno["complemento"];
      String bairro = retorno["bairro"];
      String localidade = retorno["localidade"];
      String uf = retorno["uf"];


      //CAPTURA DIRETA DE RESPOSTA (mas não é necessário após a configurção geral acima)
      //body já é uma string, então não preciso converter e ela me retorna o conteúdo completo que preciso
      //print("A resposta foi ${resposta.body}");
      //status code é referente ao resultado da requisição, ou seja, 200 equivale a requisição completada e retornada com sucesso, onde se fosse 404 seria erro
      //print("A resposta foi ${resposta.statusCode.toString()}");


      print(" Logradouro: ${logradouro}\n Complemento: ${complemento}\n Bairro: ${bairro}\n Localidade: ${localidade}\n Uf: ${uf}");

      setState(() {
          _resultadoDadosCep = (" Logradouro: ${logradouro}\n Complemento: ${complemento}\n Bairro: ${bairro}\n Localidade: ${localidade}\n Uf: ${uf}");
      });

    }
    else{
      print("Insira um valor válido!");
      setState(() {
        _resultadoDadosCep = ("Insira um valor válido!");
      });

    }

  }


  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        backgroundColor: Color.fromRGBO(226, 229, 229, 1),

        appBar: AppBar(
          title: Text("Consumo de Serviço Web"),
          backgroundColor: Color.fromRGBO(43, 55, 127, 1),
        ),


        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                    child: TextField(
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        labelText: "Insira um CEP sem pontos ou traços",

                      ),

                      //habilitar ou desabilitar campo de TextField
                      enabled: true,
                      //número máximo de caracteres, porém permite que a digitação continue no TextField
                      maxLength: 8,
                      //como verdadeira, impede que seja digitado mais caracteres do que o definido anteriormente, ideal para cpf, tel ou CEP nesse caso
                      maxLengthEnforced: true,

                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(17, 172, 202, 1),
                      ),

                      controller: _textEditingControllerCEP,

                    ),

                  ),



                  RaisedButton(
                    child: Text("Clique aqui",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    color: Color.fromRGBO(43, 55, 127, 1),
                    onPressed: _recuperarCep,
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(_resultadoDadosCep,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(17, 172, 202, 1),
                      ),),

                  ),
                ],

              ),
            ),

          ),

        ),


        /*bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(25),
          ),
        ),*/

      );
  }
}
