import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final String menu;
  final int id;

  DetailPage({required this.menu, required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detail;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  void _fetchDetail() async {
    final response = await http.get(
      Uri.parse(
          'https://api.spaceflightnewsapi.net/v4/${widget.menu}/${widget.id}'),
    );
    setState(() {
      detail = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(detail?['title'] ?? 'Loading...')),
      body: detail == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(detail!['image_url'] ?? '', height: 200),
                  SizedBox(height: 10),
                  Text(detail!['title'], style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text(detail!['summary']),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      // Open URL
                    },
                    child: Icon(Icons.open_in_browser),
                  ),
                ],
              ),
            ),
    );
  }
}
