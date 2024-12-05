import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<dynamic>> newsData;

  Future<List<dynamic>> fetchNews() async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/'));
    if (response.statusCode == 200) {
      try {
        var jsonResponse = json.decode(response.body);

        // Pastikan jsonResponse tidak null dan memiliki field `results`
        if (jsonResponse != null && jsonResponse['results'] != null) {
          return List<dynamic>.from(jsonResponse['results']);
        } else if (jsonResponse != null && jsonResponse is List) {
          // Jika API mengembalikan List langsung
          return jsonResponse;
        } else {
          throw Exception('Articles not found in the response');
        }
      } catch (e) {
        throw Exception('Error parsing JSON: $e');
      }
    } else {
      throw Exception(
          'Failed to load news, status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    newsData = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News')),
      body: FutureBuilder<List<dynamic>>(
        future: newsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var article = snapshot.data![index];
              return ListTile(
                title: Text(article['title'] ?? 'No Title'),
                onTap: () {
                  // Konversi ID ke String sebelum mengirimkannya
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments:
                        article['id'].toString(), // Konversi ID ke String
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
