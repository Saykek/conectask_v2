import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/common/widgets/temporizador_lectura.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/recompensas_view.dart';
import 'package:conectask_v2/views/task_view.dart';
import 'package:flutter/material.dart';
import '../common/constants/constant.dart';

class AulaView extends StatelessWidget {
  final UserModel user;

  const AulaView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: Text('Aula de ${user.nombre}')),
      body: Stack(
        children: [
          // Fondo del aula
          Positioned.fill(
            child: Image.asset(AppIconsConstants.fondo_aula, fit: BoxFit.cover),
          ),

          // Layout móvil: dos arriba y dos abajo
          if (isMobile) ...[
            Positioned(
              top: 100,
              left: 40,
              child: _buildBoton(
                context,
                Icons.calendar_today,
                AppFieldsConstants.calendario,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CalendarView(
                        fechaInicial: DateTime.now(),
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 100,
              right: 40,
              child: _buildBoton(
                context,
                Icons.timer,
                AppFieldsConstants.temporizador,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TemporizadorLectura(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 310,
              left: 40,
              child: _buildBoton(
                context,
                Icons.star,
                AppFieldsConstants.recompensas,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecompensasView(user: user, usuarioLogueado: user),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 310,
              right: 40,
              child: _buildBoton(
                context,
                Icons.task,
                AppFieldsConstants.tareas,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TasksView(user: user)),
                  );
                },
              ),
            ),
          ],

          // Layout web: más arriba y centrados
          if (!isMobile) ...[
            Positioned(
              top: 60,
              left: 140,
              child: _buildBoton(
                context,
                Icons.calendar_today,
                AppFieldsConstants.calendario,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CalendarView(
                        fechaInicial: DateTime.now(),
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 60,
              right: 140,
              child: _buildBoton(
                context,
                Icons.timer,
                AppFieldsConstants.temporizador,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TemporizadorLectura(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 220,
              left: 220,
              child: _buildBoton(
                context,
                Icons.star,
                AppFieldsConstants.recompensas,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecompensasView(user: user, usuarioLogueado: user),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 220,
              right: 220,
              child: _buildBoton(
                context,
                Icons.task,
                AppFieldsConstants.tareas,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TasksView(user: user)),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBoton(
    BuildContext context,
    IconData icono,
    String texto,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.orangeAccent,
            child: Icon(icono, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
