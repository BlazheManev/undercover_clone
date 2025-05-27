import 'package:flutter/material.dart';

class PlayerNameDialog extends StatefulWidget {
  final int totalPlayers;
  final Function(List<String>) onSubmit;

  const PlayerNameDialog({required this.totalPlayers, required this.onSubmit});

  @override
  _PlayerNameDialogState createState() => _PlayerNameDialogState();
}

class _PlayerNameDialogState extends State<PlayerNameDialog> {
  late List<TextEditingController> _controllers;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.totalPlayers,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final names = _controllers.map((c) => c.text.trim()).toList();
    final hasEmpty = names.any((name) => name.isEmpty);

    if (hasEmpty) {
      setState(() {
        _showValidation = true;
      });
      return;
    }

    widget.onSubmit(names);
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Player Names',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(widget.totalPlayers, (index) {
                    final isEmpty =
                        _controllers[index].text.trim().isEmpty &&
                        _showValidation;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: TextField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          hintText: 'Player ${index + 1}',
                          filled: true,
                          fillColor: isEmpty
                              ? Colors.red[50]
                              : Colors.grey[200],
                          border: OutlineInputBorder(),
                          suffixIcon: isEmpty
                              ? Icon(Icons.error_outline, color: Colors.red)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
