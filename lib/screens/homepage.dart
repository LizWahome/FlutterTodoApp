import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/todopage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Tiitle"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
                maxLines: 5,
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      addTodo();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const TodoPage()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Add Todo"),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTodo() async {
    try {
      print("Getting response");
      final title = titleController.text;
      final description = descriptionController.text;
      final body = {
        "title": title,
        "description": description,
        "is_completed": false
      };
      const url = "https://api.nstack.in/v1/todos";
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      print(response.statusCode);
      print("Response got");
      if (response.statusCode == 201) {
        showSuccessSnackbar("Todo Successfully Created");
      } else {
        showErrorSnackbar("Something went wrong");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showSuccessSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
