import 'package:flutter/material.dart';

class TermosECondicoes extends StatelessWidget {
  const TermosECondicoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Termos e Condições'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Estes são os termos e condições para continuar a Aplicação do Teste.\n'
                'Leia-os atentamente e prossiga com cautela.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            const ScrollableTextBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/cadastrosessaoteste');
              },
              child: const Text('Aceitar e Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollableTextBox extends StatelessWidget {
  const ScrollableTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 800,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
'''
1. Objetivo do Aplicativo   
Este aplicativo foi desenvolvido exclusivamente para fins de pesquisa científica no contexto do projeto de Iniciação Científica (PIBIC). Seu objetivo é avaliar aspectos da atenção em diferentes contextos, por meio de testes controlados aplicados aos participantes.

2. Consentimento do Participante  
Ao utilizar este aplicativo, você declara estar ciente de que está participando voluntariamente de uma pesquisa. Todos os dados coletados serão utilizados apenas para fins acadêmicos e de pesquisa, garantindo o anonimato e a confidencialidade dos participantes.

3. Coleta e Armazenamento de Dados  
Durante a utilização do aplicativo, serão registrados tempos de reação, respostas a estímulos visuais e outras métricas relacionadas à atenção. Esses dados são armazenados de forma segura e não permitem a identificação direta do participante.

4. Direitos do Participante  
Você tem o direito de interromper sua participação a qualquer momento, sem necessidade de justificativa. Em caso de dúvidas ou desconforto, entre em contato com os responsáveis pela pesquisa.

5. Responsabilidade e Limitações  
Este aplicativo não substitui nenhum tipo de diagnóstico clínico. Os testes presentes foram criados para fins experimentais e acadêmicos, e os resultados não devem ser interpretados como laudos médicos.

6. Aceitação dos Termos  
Ao continuar utilizando o aplicativo, você concorda com os termos apresentados acima e autoriza a utilização dos seus dados conforme descrito.
''',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
