import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/auth/widgets.dart';

class CreateModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController dateController;
  final TextEditingController colorController;
  final String selectedColor;
  final Function(String, String, String) onCreate;

  CreateModal({
    required this.titleController,
    required this.dateController,
    required this.colorController,
    required this.selectedColor,
    required this.onCreate,
  });

  DateTime _dateTime = DateTime.now();

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? pickedDate = await _selectDate(context);
    if (pickedDate != null && pickedDate != _dateTime) {
      _dateTime = pickedDate;
      dateController.text =
          '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}';
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime currentDate = _dateTime;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    return pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header('Adicione nova tarefa'),
          const SizedBox(height: 72),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Título da Atividade',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Escreva um título para continuar';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: dateController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Data da atividade',
                  ),
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                onPressed: () => _showDatePicker(context),
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 50,
                child: DropdownButtonFormField<String>(
                  isExpanded: false,
                  decoration: const InputDecoration(
                    hintText: 'Selecione a cor',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                  ),
                  value: selectedColor,
                  items: [
                    {'name': 'Azul', 'color': Colors.blue},
                    {'name': 'Vermelho', 'color': Colors.red},
                    {'name': 'Verde', 'color': Colors.green},
                    {'name': 'Amarelo', 'color': Colors.yellow.shade700},
                  ].map((Map<String, dynamic> item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: item['color'],
                        width: 24.0,
                        height: 24.0,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    colorController.text = value ?? 'Azul';
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            alignment: AlignmentDirectional.bottomEnd,
            child: ElevatedButton(
              onPressed: () async {
                await onCreate(
                  titleController.text,
                  dateController.text,
                  colorController.text,
                );

                titleController.clear();
                dateController.clear();
                colorController.clear();

                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}
