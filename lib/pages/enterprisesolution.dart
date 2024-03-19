import 'package:flutter/material.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/widget/chatbotpage.dart';
import 'package:idmall/widget/shoppingchartpage.dart';

class EnterpriseSolutionPage extends StatefulWidget {
  const EnterpriseSolutionPage({Key? key}) : super(key: key);

  @override
  _EnterpriseSolutionPageState createState() => _EnterpriseSolutionPageState();
}

class _EnterpriseSolutionPageState extends State<EnterpriseSolutionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _companyAddressController = TextEditingController();
  TextEditingController _specificNeedsController = TextEditingController();

  String? _selectedBusinessIndustry;
  String? _selectedBusinessScale;
  String? _selectedNeeds;
  String? _selectedBudget;

  List<String> _businessIndustries = [
    'Industry 1',
    'Industry 2',
    'Industry 3',
    'Industry 4',
  ];

  List<String> _businessScales = [
    'Scale 1',
    'Scale 2',
    'Scale 3',
    'Scale 4',
  ];

  List<String> _needs = [
    'Need 1',
    'Need 2',
    'Need 3',
    'Need 4',
  ];

  List<String> _budgets = [
    'Budget 1',
    'Budget 2',
    'Budget 3',
    'Budget 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
            icon: Icon(Icons.notifications),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatbotPage(),
                ),
              );
            },
            icon: Image.asset('images/Chatbot.png', width: 15, height: 15),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartPage(),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Enterprise\nSolution',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Image.asset(
                      'images/enterprisesolution.png',
                      width: 235,
                      height: 235,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildTextField('Name', _nameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Mobile Number', _mobileNumberController),
              _buildTextField('Company Name', _companyNameController),
              _buildDropdown('Business Industry', _businessIndustries, _selectedBusinessIndustry),
              _buildDropdown('Business Scale', _businessScales, _selectedBusinessScale),
              _buildDropdown('Your Needs', _needs, _selectedNeeds),
              _buildDropdown('Your IT Budget Monthly (IDR)', _budgets, _selectedBudget),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    _submitForm();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String labelText, List<String> items, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (newValue) {
          setState(() {
            value = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() {
    // Handle form submission
    print('Form submitted successfully!');
    // You can access form data using controllers
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    // ...access other form fields in a similar way
  }
}

void main() {
  runApp(MaterialApp(
    home: EnterpriseSolutionPage(),
  ));
}
