import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://' + url; // Menambahkan 'https://' jika tidak ada
    }

    final Uri _url = Uri.parse(url);

    print("Launching URL: $_url");

    // Gunakan mode peluncuran yang lebih umum
    if (await canLaunchUrl(_url)) {
      print("Launching URL successfully: $_url");
      await launchUrl(_url, mode: LaunchMode.platformDefault);
    } else {
      print("Could not launch URL: $_url");
      throw 'Could not launch $url';
    }
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
                  // Gambar yang dapat diklik untuk membuka URL
                  GestureDetector(
                    onTap: () {
                      if (detail?['url'] != null) {
                        _launchURL(detail!['url']);
                      }
                    },
                    child: Image.network(
                      detail!['image_url'] ?? '',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Judul yang dapat diklik untuk membuka URL
                  GestureDetector(
                    onTap: () {
                      if (detail?['url'] != null) {
                        _launchURL(detail!['url']);
                      }
                    },
                    child: Text(
                      detail!['title'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(detail!['summary']),
                  Spacer(),
                  // Floating action button untuk membuka URL
                  FloatingActionButton(
                    onPressed: () {
                      if (detail?['url'] != null) {
                        _launchURL(detail!['url']);
                      }
                    },
                    child: Icon(Icons.open_in_browser),
                  ),
                ],
              ),
            ),
    );
  }
}
