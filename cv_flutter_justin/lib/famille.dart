import 'package:flutter/material.dart';

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  final _membres = const [
    {
      'nom': ' Gilbert hakiza',
      
      'profession': 'Enseignant',
    },
    {
      'nom': 'Uwimana Marie',
      
      'profession': 'Commerçante',
    },
    {
      'nom': 'Mbonyurugo justin',
      
      'profession': 'Étudiant',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _membres.length,
      itemBuilder: (context, index) {
        final membre = _membres[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF0284C7),
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            title: Text(
              membre['nom']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Père : ${membre['Mère']}\nProfession : ${membre['profession']}',
              ),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}