import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/menu_semanal_edit_view.dart';
import 'package:conectask_v2/Utils/date_utils.dart' as miFecha;
import 'package:flutter/material.dart';

class MenuSemanalView extends StatelessWidget {
  final Map<String, Map<String, dynamic>>
  menu; // ej: {'lunes': {'almuerzo': '...', 'cena': '...'}}
  final UserModel user;

  MenuSemanalView({super.key, required this.menu, required this.user});

  final dias = miFecha.DateUtils.diasSemana();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Semanal'),
        actions: [
          if (user.rol == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Editar menú semanal',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MenuSemanalEditView(),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final String dia = dias[index];
          final MenuDiaModel diaModel = MenuDiaModel.fromMap(dia, menu[dia]);

          final String almuerzo = diaModel.almuerzo?.nombre ?? 'Sin asignar';
          final String cena = diaModel.cena?.nombre ?? 'Sin asignar';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 252, 233),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 159, 188, 221),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  miFecha.DateUtils.ponerMayuscula(diaModel.dia),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text('🍽️ Almuerzo: $almuerzo'),
                Text('🌙 Cena: $cena'),
              ],
            ),
          );
        },
      ),
    );
  }
}
