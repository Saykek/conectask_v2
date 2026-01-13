import 'package:conectask_v2/models/recompensa_model.dart';
import 'package:conectask_v2/controllers/recompensa_controller.dart';
import 'package:conectask_v2/views/recompensa_detail_view.dart';
import 'package:conectask_v2/views/recompensas_historial_canjeos_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';

class ResumenRecompensas extends StatelessWidget {
  final UserModel user;
  final UserModel usuarioLogueado;

  const ResumenRecompensas({
    super.key,
    required this.user,
    required this.usuarioLogueado,
  });

  @override
  Widget build(BuildContext context) {
    final RecompensaController _controller = RecompensaController();

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
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Ver historial de canjeos',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecompensasHistorialCanjeosView(
                          usuarioLogueado: usuarioLogueado,
                          usuarioHistorial: user,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Datos en tiempo real desde Firebase
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

                final puntos = data['puntos'] ?? 0; // activos
                final totales = data['puntos_acumulados'] ?? 0; // históricos

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.savings,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Puntos\ndisponibles', // 🔹 dos líneas
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$puntos',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Puntos\ntotales', // 🔹 dos líneas
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$totales',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.emoji_events,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '\nNivel', // 🔹 título arriba
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${totales ~/ 100}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: ((totales % 100) / 100).clamp(0.0, 0.999),
                      minHeight: 12,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // Insignias (simuladas)
            Row(
              children: [
                Icon(
                  Icons.military_tech, // 🔹 icono de medalla
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Insignias:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(
                  label: Text('Responsable'),
                  backgroundColor: Color.fromARGB(255, 215, 238, 231),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Chip(
                  label: Text('Ayudante'),
                  backgroundColor: Color.fromARGB(255, 215, 238, 231),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Recompensas disponibles
            Row(
              children: [
                Icon(
                  Icons.card_giftcard, // 🔹 icono de regalo
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Recompensas disponibles:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // StreamBuilder para que se actualice automáticamente
            StreamBuilder<List<RecompensaModel>>(
              stream: _controller.streamRecompensasPara(user),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay recompensas disponibles');
                }

                final recompensas = snapshot.data!;
                final screenWidth = MediaQuery.of(context).size.width;
                final isMobile = screenWidth < 600;
                final isWeb = screenWidth >= 1024;

                if (isMobile) {
                  // 🔹 Versión móvil
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.2,
                    children: recompensas.map((r) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ), // separación vertical
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: const Color.fromARGB(
                              255,
                              7,
                              73,
                              51,
                            ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.card_giftcard, size: 18),
                              const SizedBox(height: 6),
                              Text(
                                r.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '${r.coste} puntos',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (isWeb) {
                  // 🔹 Versión web (fila: icono + nombre + puntos)
                  final webColumns = (screenWidth ~/ 220).clamp(1, 4);
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: webColumns,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 2,
                    childAspectRatio: 4.5, // recompensas mas finas
                    children: recompensas.map((r) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.card_giftcard, size: 18),
                          label: Text(
                            '${r.nombre} - ${r.coste} puntos',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: const Color.fromARGB(
                              255,
                              7,
                              73,
                              51,
                            ),
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
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  // 🔹 Versión tablet
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.2,
                    children: recompensas.map((r) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ), // separación vertical
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: const Color.fromARGB(
                              255,
                              7,
                              73,
                              51,
                            ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.card_giftcard, size: 20),
                              const SizedBox(height: 6),
                              Text(
                                r.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                '${r.coste} puntos',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
