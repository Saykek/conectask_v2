import 'package:conectask_v2/models/recompensa_model.dart';
import 'package:conectask_v2/views/recompensa_detail_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ResumenRecompensas extends StatelessWidget {
  final UserModel user;
  final List<RecompensaModel> recompensas;

  const ResumenRecompensas({
    super.key,
    required this.user,
    required this.recompensas,
  });

  @override
  Widget build(BuildContext context) {
    final nivel = user.nivel ?? 0;
    final puntos = user.puntos ?? 0;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Nombre
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 16),
                Text(
                  user.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('usuarios/${user.id}')
                  .onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Text('Cargando puntos...');
                }

                final data = Map<String, dynamic>.from(
                  snapshot.data!.snapshot.value as Map,
                );
                final puntos = data['puntos'] ?? 0;

                return Text(
                  '⭐ Puntos acumulados: $puntos',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Puntos y nivel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('⭐ Puntos: $puntos'),
                Text('🔢 Nivel: $nivel'),
              ],
            ),
            const SizedBox(height: 8),

            // Barra de progreso (simulada)
            LinearProgressIndicator(
              value: (puntos % 100) / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 16),

            // Insignias (simuladas)
            const Text(
              '🏅 Insignias:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Responsable')),
                Chip(label: Text('Ayudante')),
              ],
            ),

            const SizedBox(height: 16),

            // Recompensas disponibles (REEMPLAZADO: ahora reales)
            const Text(
              '🎁 Recompensas disponibles:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: recompensas.map((r) {
                return ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    shape: const StadiumBorder(), 
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: const Color.fromARGB(255, 7, 73, 51),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecompensaDetailView(
          recompensa: r,
          user: user,
        ),
      ),
    );
  },
  icon: const Icon(Icons.card_giftcard),
  label: Text('${r.nombre} - ${r.coste} pts'),
);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}