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
    final hasDuplicates = names.length != names.toSet().length;

    if (hasEmpty || hasDuplicates) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                    final currentName = _controllers[index].text.trim();
                    final allNames = _controllers.map((c) => c.text.trim()).toList();

                    final isEmpty = _showValidation && currentName.isEmpty;
                    final isDuplicate = _showValidation &&
                        allNames.where((name) => name == currentName).length > 1;

                    String? errorText;
                    if (isEmpty) {
                      errorText = 'Name cannot be empty';
                    } else if (isDuplicate) {
                      errorText = 'Name is duplicated';
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (errorText != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                errorText,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              hintText: 'Player ${index + 1}',
                              filled: true,
                              fillColor: errorText != null
                                  ? Colors.red[50]
                                  : Colors.grey[200],
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
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
