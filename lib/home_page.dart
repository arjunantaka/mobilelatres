import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMenuCard(
              context,
              title: 'News',
              description: 'Get the latest news articles.',
              icon: Icons.article_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(menu: 'articles'),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Blogs',
              description: 'Explore interesting blogs.',
              icon: Icons.book_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(menu: 'blogs'),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Reports',
              description: 'Read insightful reports.',
              icon: Icons.report_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(menu: 'reports'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon, size: 30),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
