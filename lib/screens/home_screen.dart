import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_gastos_app/providers/theme_manager.dart';
import 'package:controle_gastos_app/providers/ticket_manager.dart';
import 'detail_screen.dart';
import 'add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketManager = Provider.of<TicketManager>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final isDarkMode = themeManager.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Controle de Gastos',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.blue[300],
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 28,
            ),
            onPressed: () => themeManager.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt, size: 28),
            tooltip: 'Filtrar Tickets',
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ticketManager.tickets.length,
              itemBuilder: (context, index) {
                final ticket = ticketManager.tickets[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: isDarkMode
                      ? Colors.blueGrey[900]
                      : Colors.blue[50],
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      ticket['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Valor: R\$ ${ticket['value'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Data: ${ticket['date'].split(' ')[0]}',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(ticket: ticket),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: FloatingActionButton(
          backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.blue[300],
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const AddScreen(),
            );
          },
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final ticketManager = Provider.of<TicketManager>(context, listen: false);
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            'Filtrar Tickets',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Data Inicial (YYYY-MM-DD)',
                ),
              ),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'Data Final (YYYY-MM-DD)',
                ),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final startDate = DateTime.tryParse(startDateController.text);
                final endDate = DateTime.tryParse(endDateController.text);
                final category = categoryController.text;

                ticketManager.filterTickets(startDate, endDate, category);
                Navigator.of(context).pop();
              },
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }
}
