import 'package:flutter/material.dart';

class EditInformationPage extends StatefulWidget {
  @override
  _EditInformationPageState createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  // Define variables to hold the data being edited
  String _name = 'John Doe';
  int _age = 30;
  String _gender = 'Male';

  // Define form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                initialValue: _name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                initialValue: _age.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value);
                },
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate the form fields
                    if (_formKey.currentState.validate()) {
                      // Save the form fields
                      _formKey.currentState.save();

                      // Update the data source with the new information
                      updateInformation(_name, _age, _gender);

                      // Display a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Information updated')),
                      );

                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateInformation(String name, int age, String gender) {
    // TODO: Update the data source with the new information
  }
}
