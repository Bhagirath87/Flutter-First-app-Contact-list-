import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Contact',
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.length>=20 || value.isEmpty ? 'Enter name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.length!=10 ||value.isEmpty ? 'Enter number' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'name': nameController.text,
                      'number': numberController.text,
                    });
                  }
                },
                child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
