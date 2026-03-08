import 'package:flutter/material.dart';

// Simple Ticket Model
class Ticket {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String category;
  final DateTime createdAt;
  String status;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.createdAt,
    this.status = 'Aberto',
  });
}

// Global list to simulate database storage (temporary)
List<Ticket> demoTickets = [
  Ticket(
    id: '1',
    title: 'Erro no Login',
    description: 'Não consigo acessar minha conta com a senha correta.',
    priority: 'Alta',
    category: 'Bug',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Ticket(
    id: '2',
    title: 'Solicitação de Acesso',
    description: 'Preciso de acesso à pasta de relatórios financeiros.',
    priority: 'Média',
    category: 'Acesso',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  void _refresh() {
    setState(() {});
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red.shade100;
      case 'Média':
        return Colors.orange.shade100;
      case 'Baixa':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red.shade900;
      case 'Média':
        return Colors.orange.shade900;
      case 'Baixa':
        return Colors.green.shade900;
      default:
        return Colors.grey.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Chamados'),
      ),
      body: demoTickets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum chamado encontrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: demoTickets.length,
              itemBuilder: (context, index) {
                final ticket = demoTickets[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ticket.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(ticket.priority),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ticket.priority,
                            style: TextStyle(
                              color: _getPriorityTextColor(ticket.priority),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          ticket.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.label_outline, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(ticket.category, style: TextStyle(color: Colors.grey.shade600)),
                            const Spacer(),
                            Text(
                              '${ticket.createdAt.day}/${ticket.createdAt.month} ${ticket.createdAt.hour}:${ticket.createdAt.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      // Future: View details
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/new-ticket');
          _refresh(); // Refresh list after returning
        },
        label: const Text('Novo Chamado'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class TicketFormScreen extends StatefulWidget {
  const TicketFormScreen({super.key});

  @override
  State<TicketFormScreen> createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _priority = 'Média';
  String _category = 'Suporte Geral';
  
  final List<String> _priorities = ['Baixa', 'Média', 'Alta', 'Crítica'];
  final List<String> _categories = ['Suporte Geral', 'Bug', 'Acesso', 'Hardware', 'Rede', 'Outros'];

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      // Simulate saving to database
      final newTicket = Ticket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        priority: _priority,
        category: _category,
        createdAt: DateTime.now(),
      );

      setState(() {
        demoTickets.insert(0, newTicket);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chamado aberto com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Chamado'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencha os detalhes abaixo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título do Problema',
                  hintText: 'Ex: Computador não liga',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _priorities.map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descrição Detalhada',
                  hintText: 'Descreva o problema com o máximo de detalhes possível...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, descreva o problema';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              FilledButton.icon(
                onPressed: _submitTicket,
                icon: const Icon(Icons.send),
                label: const Text('Abrir Chamado'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
