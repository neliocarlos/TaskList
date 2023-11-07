import 'dart:async';

import 'package:flutter/material.dart';

import 'guest_book_message.dart';
import 'src/widgets.dart';

class GuestBook extends StatefulWidget {
  const GuestBook(
      {required this.addMessage, required this.messages, super.key});

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _title,
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
                  TextFormField(
                    controller: _description,
                    decoration: const InputDecoration(
                      hintText: 'Descreva a atividade',
                    ),
                  ),
                  const SizedBox(width: 8, height: 12),
                  SizedBox(
                    width: constraints.maxWidth * .3,
                    child: StyledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await widget.addMessage(_title.text);
                          _title.clear();
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.send),
                          SizedBox(width: 4),
                          Text('SEND'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (var message in widget.messages)
            Paragraph('${message.name}: ${message.message}'),
          const SizedBox(height: 8),
        ],
      );
    });
  }
}
