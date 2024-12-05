import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<List<dynamic>> reportData;

  Future<List<dynamic>> fetchReports() async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/reports/'));
    if (response.statusCode == 200) {
      return List<dynamic>.from(json.decode(response.body)['reports']);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  @override
  void initState() {
    super.initState();
    reportData = fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report')),
      body: FutureBuilder<List<dynamic>>(
        future: reportData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reports available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var report = snapshot.data![index];
              return ListTile(
                title: Text(report['title']),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: report['id'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
