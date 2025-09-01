import 'package:flutter/material.dart';
import 'package:deathnote_apps/data/note.dart';
import 'package:deathnote_apps/data/database_local.dart';

class ViewScreen extends StatefulWidget {
  final Note note;

  const ViewScreen({super.key, required this.note});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Notes"),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Created: ${widget.note.createdAt.day}/${widget.note.createdAt.month}/${widget.note.createdAt.year} "
              "| Updated: ${widget.note.updatedAt.day}/${widget.note.updatedAt.month}/${widget.note.updatedAt.year}",
            ),
            const SizedBox(height: 10),
            Text(
              widget.note.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(10),
                thickness: 6,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.note.content,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final titleController =
              TextEditingController(text: widget.note.title);
          final contentController =
              TextEditingController(text: widget.note.content);

          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text("Edit Note"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Content",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedNote = widget.note.copyWith(
                        title: titleController.text,
                        content: contentController.text,
                        updatedAt: DateTime.now(),
                      );
                      await DatabaseLocal().updateNote(updatedNote);
                      if (!context.mounted) return;
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop(updatedNote);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text("Edit Notes"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
