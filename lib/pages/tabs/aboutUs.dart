import 'package:fit_tracker/widgets/global/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o Fit Tracker'),
        backgroundColor: pRed,
        foregroundColor: pWhite,
      ),
      body:
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fit Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'O Fit Tracker é um aplicativo criado para ajudá-lo a gerenciar seus treinos de maneira simples e eficiente. '
                          'Com ele, você pode armazenar seus treinos, acompanhar seu progresso e adicionar amigos para se manter motivado.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Card dos criadores, esticado para ocupar toda a largura
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Criadores',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Fábio Andrade',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          Text(
                            '• Lucas Barros',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          Text(
                            '• Pedro Marçal',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          Text(
                            '• Pedro Ribeiro',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funcionalidades',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Armazene e gerencie seus treinos.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      '• Adicione amigos para acompanhar suas atividades.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      '• Acompanhe seu progresso ao longo do tempo.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            CustomBottomBar(),
          ],
        ),
    );
  }
}
