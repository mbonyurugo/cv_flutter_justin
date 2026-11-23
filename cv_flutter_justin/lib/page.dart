import 'package:flutter/material.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  Widget _sectionCard({
    required String titre,
    required IconData icone,
    required List<Widget> enfants,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: const Color(0xFF0284C7)),
                const SizedBox(width: 8),
                Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...enfants,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF0284C7),
                    child: Icon(Icons.person, size: 44, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mugisha Mbonyurugo Justin',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Étudiant en Informatique & Développeur',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _sectionCard(
            titre: 'Formation',
            icone: Icons.school,
            enfants: const [
              Text(
                'Licence en Informatique',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Parcours universitaire — Développement logiciel & systèmes'),
            ],
          ),
          _sectionCard(
            titre: 'Expériences & Projets',
            icone: Icons.work,
            enfants: const [
              Text(
                'Application Mobile CV Flutter',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Développement d\'une application multi-écrans avec Flutter & Dart.'),
              SizedBox(height: 10),
              Text(
                'Projets Académiques & Bases de Données',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Conception de bases de données, scripts Python et applications C# / Web.'),
            ],
          ),
          _sectionCard(
            titre: 'Compétences Techniques',
            icone: Icons.code,
            enfants: const [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Flutter / Dart')),
                  Chip(label: Text('Python')),
                  Chip(label: Text('C#')),
                  Chip(label: Text('SQL Server')),
                  Chip(label: Text('Réseaux & WordPress')),
                  Chip(label: Text('Git / GitHub')),
                ],
              ),
            ],
          ),
          _sectionCard(
            titre: 'Langues & Centres d\'intérêt',
            icone: Icons.language,
            enfants: const [
              Text('Langues : Français, Anglais, Swahili'),
              SizedBox(height: 8),
              Text('Centres d\'intérêt : Développement mobile, bases de données, architecture réseau, veille technologique.'),
            ],
          ),
        ],
      ),
    );
  }
}