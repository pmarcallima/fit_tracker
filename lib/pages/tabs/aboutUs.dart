
import 'package:fit_tracker/widgets/global/appbar.dart';
import 'package:fit_tracker/widgets/global/bottombar.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
CustomAppBar(titleText: "Sobre nós", icon: (Icons.info)),
      
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Fit Tracker',
                content:
                    'O Fit Tracker é um aplicativo criado para ajudá-lo a gerenciar seus treinos de maneira simples e eficiente. '
                    'Com ele, você pode armazenar seus treinos, acompanhar seu progresso e adicionar amigos para se manter motivado.',
              ),
              _buildCreatorsCard(),
              _buildInfoCard(
                title: 'Funcionalidades',
                content:
                    '• Armazene e gerencie seus treinos.\n'
                    '• Adicione amigos para acompanhar suas atividades.\n'
                    '• Acompanhe seu progresso ao longo do tempo.',
              ),
              SizedBox(height: 80), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 3), 
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorsCard() {
    return Container(
      width: double.infinity, // Ocupar toda a largura disponível
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
              ...[
                '• Fábio Andrade',
                '• Lucas Alkmim',
                '• Pedro Marçal',
                '• Pedro Ribeiro',
              ].map(
                    (creator) => Text(
                  creator,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
