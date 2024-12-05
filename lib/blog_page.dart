import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late Future<List<dynamic>> blogData;

  Future<List<dynamic>> fetchBlogs() async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/blogs/'));
    if (response.statusCode == 200) {
      return List<dynamic>.from(json.decode(response.body)['blogs']);
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  void initState() {
    super.initState();
    blogData = fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blogs')),
      body: FutureBuilder<List<dynamic>>(
        future: blogData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No blogs available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var blog = snapshot.data![index];
              return ListTile(
                title: Text(blog['title']),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: blog['id'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
