import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _ouvrirLien(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir : $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF0284C7)),
            title: const Text('Téléphone'),
            subtitle: const Text('+243 9926 89 346'),
            onTap: () => _ouvrirLien(context, 'tel:+243992689346'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF0284C7)),
            title: const Text('E-mail'),
            subtitle: const Text('mugishambonyurugojustin@exemple.com'),
            onTap: () => _ouvrirLien(context, 'mailto:mugishambonyurugojustin@exemple.com'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Color(0xFF0284C7)),
            title: const Text('Adresse'),
            subtitle: const Text('Goma, Nord-Kivu, République Démocratique du Congo'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.code, color: Color(0xFF0284C7)),
            title: const Text('GitHub'),
            subtitle: const Text('https://github.com/votre-utilisateur/cv_flutter_justin'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _ouvrirLien(context, 'https://github.com'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.work_outline, color: Color(0xFF0284C7)),
            title: const Text('https://whatsapp.com'),
            subtitle: const Text('https://whatsapp.com'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _ouvrirLien(context, 'https://whatsapp.com'),
          ),
        ),
      ],
    );
  }
}