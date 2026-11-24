import 'package:flutter/material.dart';
import 'api_service.dart';
import 'famillemambre.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  List<FamilleMembre> _membres = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  Future<void> _chargerMembres() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await ApiService.getMembres();
      if (!mounted) return;
      setState(() {
        _membres = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _afficherFormulaire({FamilleMembre? membreExistant}) {
    final nomCtrl = TextEditingController(text: membreExistant?.nom ?? '');
    final postnomCtrl = TextEditingController(text: membreExistant?.postnom ?? '');
    final prenomCtrl = TextEditingController(text: membreExistant?.prenom ?? '');
    final lieuCtrl = TextEditingController(text: membreExistant?.lieuNaissance ?? '');
    final dateCtrl = TextEditingController(text: membreExistant?.dateNaissance ?? '');
    final parenteCtrl = TextEditingController(text: membreExistant?.parente ?? '');
    final formKey = GlobalKey<FormState>();
    bool saving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Future<void> enregistrer() async {
              if (!formKey.currentState!.validate()) return;

              final nouveau = FamilleMembre(
                id: membreExistant?.id,
                nom: nomCtrl.text.trim(),
                postnom: postnomCtrl.text.trim(),
                prenom: prenomCtrl.text.trim(),
                lieuNaissance: lieuCtrl.text.trim(),
                dateNaissance: dateCtrl.text.trim(),
                parente: parenteCtrl.text.trim(),
              );

              setDialogState(() => saving = true);
              try {
                if (membreExistant == null) {
                  await ApiService.createMembre(nouveau);
                } else if (membreExistant.id != null) {
                  await ApiService.updateMembre(membreExistant.id!, nouveau);
                }
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                await _chargerMembres();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      membreExistant == null
                          ? 'Membre ajouté avec succès.'
                          : 'Membre modifié avec succès.',
                    ),
                  ),
                );
              } catch (e) {
                setDialogState(() => saving = false);
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString().replaceFirst('Exception: ', '')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }

            return AlertDialog(
              title: Text(
                membreExistant == null ? 'Ajouter un membre' : 'Modifier le membre',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nomCtrl,
                        decoration: const InputDecoration(labelText: 'Nom *'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Nom obligatoire' : null,
                      ),
                      TextFormField(
                        controller: postnomCtrl,
                        decoration: const InputDecoration(labelText: 'Postnom *'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Postnom obligatoire'
                            : null,
                      ),
                      TextFormField(
                        controller: prenomCtrl,
                        decoration: const InputDecoration(labelText: 'Prénom *'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Prénom obligatoire' : null,
                      ),
                      TextFormField(
                        controller: lieuCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Lieu de naissance *'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Lieu de naissance obligatoire'
                            : null,
                      ),
                      TextFormField(
                        controller: dateCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Date de naissance (AAAA-MM-JJ) *',
                          hintText: '1995-06-15',
                        ),
                        validator: (v) {
                          final val = v?.trim() ?? '';
                          if (val.isEmpty) return 'Date obligatoire';
                          final reg = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                          if (!reg.hasMatch(val)) {
                            return 'Format attendu : AAAA-MM-JJ';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: parenteCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Parenté *',
                          hintText: 'Père, Mère, Frère, Sœur...',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Parenté obligatoire' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving ? null : () => Navigator.pop(ctx),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: saving ? null : enregistrer,
                  child: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmerSuppression(FamilleMembre membre) async {
    if (membre.id == null) return;
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(
          'Voulez-vous vraiment supprimer ${membre.prenom} ${membre.nom} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirme != true) return;

    try {
      await ApiService.deleteMembre(membre.id!);
      await _chargerMembres();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre supprimé.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membres de famille'),
        actions: [
          IconButton(
            onPressed: _chargerMembres,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _afficherFormulaire(),
        tooltip: 'Ajouter un membre',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _chargerMembres,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : _membres.isEmpty
                  ? const Center(
                      child: Text('Aucun membre enregistré. Appuyez sur + pour ajouter.'),
                    )
                  : RefreshIndicator(
                      onRefresh: _chargerMembres,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _membres.length,
                        itemBuilder: (context, index) {
                          final m = _membres[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  m.prenom.isNotEmpty
                                      ? m.prenom[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              title: Text('${m.prenom} ${m.nom} ${m.postnom}'),
                              subtitle: Text(
                                '${m.parente} • Né(e) le ${m.dateNaissance} à ${m.lieuNaissance}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _afficherFormulaire(membreExistant: m),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmerSuppression(m),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}