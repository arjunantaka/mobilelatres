import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final String menu;

  ListPage({required this.menu});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/${widget.menu}'),
    );
    setState(() {
      data = json.decode(response.body)['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.menu.toUpperCase())),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(
                  data[index]['image_url'] ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text(
                    data[index]['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    data[index]['summary']?.length > 100
                        ? '${data[index]['summary']?.substring(0, 100)}...'
                        : data[index]['summary'] ?? '',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          menu: widget.menu,
                          id: data[index]['id'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
