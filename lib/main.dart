import 'package:flutter/material.dart';
import 'add_contact_page.dart';

void main() {
  runApp(MyApp());
}

// MyApp only sets up MaterialApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<String> names = ['Bhagirath', 'Aniruddh', 'Pavan', 'Meet', 'Parth'];
  List<String> numbers = [
    '8780551298',
    '6358899514',
    '8760116019',
    '8849924499',
    '9099406040',
  ];

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
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                    names[index][0].toUpperCase(),
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
                      names[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[700],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      numbers[index],
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
      // Use Builder to get correct context for Navigator
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddContactPage()),
            );

            if (result != null && result is Map<String, String>) {
              setState(() {
                names.add(result['name']!);
                numbers.add(result['number']!);
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
