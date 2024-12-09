import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_gastos_app/providers/ticket_manager.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final ticketManager = Provider.of<TicketManager>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: Colors.blueGrey[300]),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor',
                labelStyle: TextStyle(color: Colors.blueGrey[300]),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Nenhuma data selecionada'
                        : 'Data: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.blueGrey[300] : Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Selecione a Data', style: TextStyle(color: Colors.blue),),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.blueGrey[700] : Colors.blue[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final descricao = _descricaoController.text;
                  final valor = double.tryParse(_valorController.text) ?? 0.0;

                  if (descricao.isNotEmpty &&
                      valor > 0 &&
                      _selectedDate != null) {
                    ticketManager.adicionarTicket({
                      'title': descricao,
                      'value': valor,
                      'date': _selectedDate.toString(),
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preencha todos os campos corretamente!'),
                      ),
                    );
                  }
                },
                child: const Text('Adicionar', style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
