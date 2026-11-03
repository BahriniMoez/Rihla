import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

import '../models/destination.dart';
//import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;

  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  DateTime? _date; 
  String _formule = 'Essentiel';
  bool _conditions = false;
  AutovalidateMode _autoValidation = AutovalidateMode.disabled;

  int get _prixParPersonne => _formule == 'Confort'
      ? (widget.destination.prix * 1.3).round()
      : widget.destination.prix;

  int get _total => _prixParPersonne * widget.voyageurs;
  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final demain = DateTime.now().add(const Duration(days: 1));
    final choisie = await showDatePicker(
      context: context,
      initialDate: _date ?? demain,
      firstDate: demain,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Date de départ',
    );
    
    if (choisie == null) return;

    setState(() {
      _date = choisie;
      final jour = choisie.day.toString().padLeft(2, '0');
      final mois = choisie.month.toString().padLeft(2, '0');
      final annee = choisie.year.toString();
      _dateCtrl.text = '$jour/$mois/$annee';
    });
  }

  InputDecoration _deco(String label, IconData icone, {String? aide}) {
    return InputDecoration(
      labelText: label,
      helperText: aide,
      prefixIcon: Icon(icone),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _validerNom(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre nom';
    if (v.trim().length < 3) return 'Au moins 3 caractères';
    return null;
  }

  String? _validerEmail(String? v) {
    // TODO 2 : vide -> "Indiquez votre e-mail"
    if (v == null || v.trim().isEmpty) return 'Indiquez votre e-mail';
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(v.trim())) {
      return 'E-mail invalide (ex. : nom@mail.tn)';
    }
    return null;
  }

  String? _validerTel(String? v) {
    // TODO 3 : vide -> 'Indiquez votre téléphone'
    if (v == null || v.trim().isEmpty) return 'Indiquez votre téléphone';
    // longueur différente de 8 -> '8 chiffres attendus'
    if (v.trim().length != 8) return '8 chiffres attendus';
    return null;
  }

  void _valider() {
    if (!_formKey.currentState!.validate()){
      setState(() {
        _autoValidation = AutovalidateMode.onUserInteraction;
      });
      return;
    }
    // Provisoire : sera remplacé au palier 5
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulaire valide')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Réserver')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO 4 : récapitulatif (image 64 x 64, nom, durée, voyageurs)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.destination.image,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.destination.nom,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.destination.duree} · ${widget.voyageurs} voyageur(s)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Vos coordonnées',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nomCtrl,
                decoration: _deco('Nom complet', Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),

              const SizedBox(height: 16),

              // TODO 5 : champ E-mail (clavier emailAddress)
              TextFormField(
                controller: _emailCtrl,
                decoration: _deco('E-mail', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),

              const SizedBox(height: 16),

              // TODO 6 : champ Téléphone (clavier phone, chiffres seulement, 8 maximum, texte d'aide '8 chiffres, sans indicatif')
              TextFormField(
                controller: _telCtrl,
                decoration: _deco(
                  'Téléphone',
                  Icons.phone_outlined,
                  aide: '8 chiffres, sans indicatif',
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: _validerTel,
              ),

              const SizedBox(height: 24),
              Text(
                'Votre voyage',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco('Date de départ', Icons.calendar_month_outlined),
                validator: (_) => _date == null ? 'Choisissez une date' : null,
              ),

              const SizedBox(height: 16),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Essentiel',
                    label: Text('Essentiel'),
                    icon: Icon(Icons.backpack_outlined),
                  ),
                  ButtonSegment(
                    value: 'Confort',
                    label: Text('Confort +30 %'),
                    icon: Icon(Icons.hotel_outlined),
                  ),
                ],
                selected: {_formule},
                onSelectionChanged: (choix) {
                  setState(() {
                    _formule = choix.first;
                  });
                },
              ),
              
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _conditions,
                onChanged: (v) => setState(() => _conditions = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text("J'accepte les conditions d'annulation"),
                subtitle: const Text("Annulation gratuite jusqu'à 48 h avant"),
              ),
            ],
          ),
        ),
      ),

      // TODO 7 : bottomNavigationBar avec un FilledButton.icon « Confirmer » qui appelle _valider
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_prixParPersonne DT × ${widget.voyageurs}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$_total DT',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _conditions ? _valider : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmer'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}