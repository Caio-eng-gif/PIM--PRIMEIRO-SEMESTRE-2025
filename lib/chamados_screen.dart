import 'package:flutter/material.dart';
import 'database.dart';
import 'detalhes_chamado_screen.dart';
import 'login_screen.dart';

class ChamadosScreen extends StatefulWidget {
  const ChamadosScreen({super.key});

  @override
  State<ChamadosScreen> createState() => _ChamadosScreenState();
}

class _ChamadosScreenState extends State<ChamadosScreen> {
  late Future<List<Map<String, dynamic>>> _chamadosFuture;

  @override
  void initState() {
    super.initState();
    _loadChamados();
  }

  void _loadChamados() {
    _chamadosFuture = DatabaseHelper.instance.getChamados();
  }

  Future<void> _refreshChamados() async {
    setState(() {
      _loadChamados();
    });
    await _chamadosFuture;
  }

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
        title: const Text('Chamados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Voltar ao login",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _chamadosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar chamados: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum chamado encontrado.'));
          }

          final chamados = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshChamados,
            child: ListView.builder(
              itemCount: chamados.length,
              itemBuilder: (context, index) {
                final chamado = chamados[index];

                return Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                    title: Text(
                      chamado['titulo'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        chamado['descricao'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(chamado['status']).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        chamado['status'],
                        style: TextStyle(
                          color: _statusColor(chamado['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesChamadoScreen(
                            chamado: chamado,
                          ),
                        ),
                      );
                    },
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
