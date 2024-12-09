import 'package:flutter/material.dart';

class TicketManager extends ChangeNotifier {
  final List<Map<String, dynamic>> _tickets = [];

  List<Map<String, dynamic>> get tickets => List.unmodifiable(_tickets);

  void adicionarTicket(Map<String, dynamic> ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }

  void removeTicket(Map<String, dynamic> ticket) {
    _tickets.remove(ticket);
    notifyListeners();
  }

  void filterTickets(DateTime? startDate, DateTime? endDate, String? category) {
  _tickets.retainWhere((ticket) {
    final ticketDate = DateTime.parse(ticket['date']);
    final matchesStartDate = startDate == null || ticketDate.isAfter(startDate);
    final matchesEndDate = endDate == null || ticketDate.isBefore(endDate);
    final matchesCategory = category == null || ticket['category'] == category;

    return matchesStartDate && matchesEndDate && matchesCategory;
  });
  notifyListeners();
}

}
