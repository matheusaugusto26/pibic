import 'package:aplicacao/screens/home.dart';
import 'package:flutter/material.dart';
import 'screens/termos_e_condicoes.dart';
import 'package:aplicacao/screens/cadastro_sessao_teste.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Dividida/aplicacao_teste_dividido.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Dividida/modelo_teste_dividido.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Dividida/finalizacao_teste_dividido.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Concentrada/aplicacao_teste_concentrado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Concentrada/modelo_teste_concentrado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Concentrada/finalizacao_teste_concentrado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Alternada/aplicacao_teste_alternado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Alternada/modelo_teste_alternado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Alternada/finalizacao_teste_alternado.dart';
import 'package:aplicacao/screens/proximos_passos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:printing/printing.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: 'Software de Avaliação da Atenção',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/termosecondicoes': (context) => const TermosECondicoes(),
        '/cadastrosessaoteste': (context) => const CadastroSessaoTeste(),
        '/modelotestealternado': (context) => const ModeloTesteAlternado(),
        '/aplicacaotestealternado': (context) =>
            const AplicacaoTesteAlternado(),
        '/finalizacaotestealternado': (context) =>
            const FinalizacaoTesteAlternado(),
        '/modelotesteconcentrado': (context) => const ModeloTesteConcentrado(),
        '/aplicacaotesteconcentrado': (context) =>
            const AplicacaoTesteConcentrado(),
        '/finalizacaotesteconcentrado': (context) =>
            const FinalizacaoTesteConcentrado(),
        '/modelotestedividido': (context) => const ModeloTesteDividido(),
        '/aplicacaotestedividido': (context) => const AplicacaoTesteDividido(),
        '/finalizacaotestedividido': (context) =>
            const FinalizacaoTesteDividido(),
        '/proximospassos': (context) => const ProximosPassos()
      },
    );
    return materialApp;
  }
}
