import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({super.key});

  @override
  State<MesReservationsScreen> createState() => _MesReservationsScreenState();
}

class _MesReservationsScreenState extends State<MesReservationsScreen> {
  late Future<List<Reservation>> _futurReservations;
  List<Reservation> _reservations = [];
  bool _estInitialise = false;

  @override
  void initState() {
    super.initState();
    _futurReservations = ApiService.getReservations();
  }

  Future<void> _recharger() async {
    final futur = ApiService.getReservations();
    setState(() {
      _futurReservations = futur;
      _estInitialise = false;
    });
    try {
      await futur;
    } catch (_) {}
  }

  String _formaterDate(DateTime date) {
    final jour = date.day.toString().padLeft(2, '0');
    final mois = date.month.toString().padLeft(2, '0');
    return '$jour/$mois/${date.year}';
  }

  Future<void> _annulerReservation(int index, Reservation reservation) async {
    setState(() {
      _reservations.removeAt(index);
    });

    try {
      if (reservation.id != null) {
        await ApiService.supprimerReservation(reservation.id!);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Réservation annulée.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _reservations.insert(index, reservation);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Impossible d\'annuler : erreur serveur.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes voyages'),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: _futurReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return ErreurReseau(
              message: 'Impossible de charger vos réservations.',
              onReessayer: _recharger,
            );
          }

          if (!_estInitialise && snapshot.hasData) {
            _reservations = List.from(snapshot.data!);
            _estInitialise = true;
          }

          if (_reservations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recharger,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      'Aucune réservation pour le moment.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final r = _reservations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            r.destination.image,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.destination.nom,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Départ : ${_formaterDate(r.dateDepart)}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              Text(
                                '${r.voyageurs} voyageur(s) • ${r.formule}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${r.total.toInt()} DT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                          onPressed: () => _annulerReservation(index, r),
                          tooltip: 'Annuler la réservation',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}