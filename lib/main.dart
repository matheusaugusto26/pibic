import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Alternada/aplicacao_teste_alternado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Alternada/finalizacao_teste_alternado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Alternada/modelo_teste_alternado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Concentrada/aplicacao_teste_concentrado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Concentrada/finalizacao_teste_concentrado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Concentrada/modelo_teste_concentrado.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Dividida/aplicacao_teste_dividido.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Dividida/finalizacao_teste_dividido.dart';
import 'package:aplicacao/screens/Teste%20Aten%C3%A7%C3%A3o%20Dividida/modelo_teste_dividido.dart';
import 'package:aplicacao/screens/home.dart';
import 'package:aplicacao/screens/termos_e_condicoes.dart';
import 'package:aplicacao/screens/cadastro_sessao_teste.dart';
import 'package:aplicacao/screens/proximos_passos.dart';
import 'package:aplicacao/screens/resultados_anteriores.dart';
import 'package:aplicacao/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Erro ao inicializar o Firebase:\n$e',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Software de Avaliação da Atenção',
      theme: AppTheme.theme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/termosecondicoes': (context) => const TermosECondicoes(),
        '/cadastrosessaoteste': (context) => const CadastroSessaoTeste(),

        // Teste Alternado
        '/modelotestealternado': (context) => const ModeloTesteAlternado(),
        '/aplicacaotestealternado': (context) => const AplicacaoTesteAlternado(),
        '/finalizacaotestealternado': (context) => const FinalizacaoTesteAlternado(),

        // Teste Concentrado
        '/modelotesteconcentrado': (context) => const ModeloTesteConcentrado(),
        '/aplicacaotesteconcentrado': (context) => const AplicacaoTesteConcentrado(),
        '/finalizacaotesteconcentrado': (context) => const FinalizacaoTesteConcentrado(),

        // Teste Dividido
        '/modelotestedividido': (context) => const ModeloTesteDividido(),
        '/aplicacaotestedividido': (context) => const AplicacaoTesteDividido(),
        '/finalizacaotestedividido': (context) => const FinalizacaoTesteDividido(),

        // Próximos Passos
        '/proximospassos': (context) => const ProximosPassos(),

        // Resultados Anteriores
        '/resultadosAnteriores': (context) => const ResultadosAnteriores(),

      },
    );
  }
}
