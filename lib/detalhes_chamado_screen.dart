import 'package:flutter/material.dart';

class DetalhesChamadoScreen extends StatelessWidget {
  final Map<String, dynamic> chamado;

  const DetalhesChamadoScreen({super.key, required this.chamado});

  Color _statusColor(String status) {
    switch (status) {
      case 'Aberto':
        return Colors.green;
      case 'Em andamento':
        return Colors.orange;
      case 'Fechado':
        return Colors.red;
      case 'Resolvido':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chamado['titulo'] ?? 'Chamado'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  chamado['titulo'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.person, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      "Técnico responsável: ${chamado['tecnico'] ?? '---'}",
                      style: const TextStyle(fontSize: 17),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Descrição:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  chamado['descricao'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Detalhes:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  chamado['detalhes'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Status:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _statusColor(chamado['status'] ?? '---').withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    chamado['status'] ?? '---',
                    style: TextStyle(
                      fontSize: 16,
                      color: _statusColor(chamado['status'] ?? '---'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
