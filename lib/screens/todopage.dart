import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/homepage.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: getTodos,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final id = items[index]['_id'];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(items[index]['title']),
                    subtitle: Text(items[index]['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == "Delete") {
                        deleteById(id);
                      } else {
                        //
                      }
                    }, itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: "Edit",
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: "Delete",
                          child: Text("Delete"),
                        )
                      ];
                    }),
                  ),
                );
              }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          label: Text("Add Todo")),
    );
  }

  Future<void> getTodos() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['items'];
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
    // print(response.statusCode);
    // print(response.body);
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    //print(response.body);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      return;
    }
    //print(response.statusCode);
  }
}
