import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_contact_page.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(MyApp());
}

// MyApp only sets up MaterialApp
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      home: HomePage(),
    );
  }
}

// HomePage contains the contact list
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Map<String, String>> contacts = [];
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  // Fetch contacts from backend
  Future<void> fetchContacts() async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/getusersf'); // Android emulator
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          contacts = data.map<Map<String, String>>((user) => {
                'name': (user['name'] ?? '') as String,
                'number': (user['number'] ?? '') as String,
              }).toList();
          errorMessage = null;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch contacts: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching contacts: $e';
        isLoading = false;
      });
    }
  }

  // Send new contact to backend
  Future<void> addContact(Map<String, String> newContact) async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/create');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': newContact['name'],
          'number': newContact['number'],
          'email': newContact['email'] ?? '',
          'address': newContact['address'] ?? '',
        }),
      );

      if (response.statusCode == 200) {
        print('Contact added successfully');
      } else {
        print('Failed to add contact: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding contact: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : contacts.isEmpty
                  ? Center(
                      child: Text(
                        'No contacts found',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Container(
                          width: double.infinity,
                          height: 100,
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  contact['name']![0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              // Name & number
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contact['name']!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple[700],
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    contact['number']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddContactPage()),
            );

            if (result != null && result is Map<String, String>) {
              await addContact(result); // send to backend
              setState(() {
                contacts.add(result); // update local list
              });
            }
          },
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
