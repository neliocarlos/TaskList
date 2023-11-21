import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/auth/widgets.dart';

class UpdateModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController dateController;
  final TextEditingController colorController;
  final String selectedColor;
  final Function(String, String, String) onUpdate;

  UpdateModal({
    required this.titleController,
    required this.dateController,
    required this.colorController,
    required this.selectedColor,
    required this.onUpdate,
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

  void _resetControllers() {
    titleController.clear();
    dateController.clear();
    colorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _resetControllers();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          _resetControllers();
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header('Editar tarefa'),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selecione a cor do card:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
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
                    await onUpdate(
                      titleController.text,
                      dateController.text,
                      colorController.text,
                    );

                    _resetControllers();

                    Navigator.pop(context);
                  },
                  child: Text('Atualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
