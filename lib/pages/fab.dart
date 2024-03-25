import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:idmall/config/config.dart' as config;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FABForm extends StatefulWidget {
  final String taskID;
  const FABForm({super.key, required this.taskID});

  @override
  _FABFormState createState() => _FABFormState();
}

class _FABFormState extends State<FABForm> {
  String? token;
  String? user_id;
  Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _installationAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  // final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  String? _selectedServiceType;
  late File _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _agreeToTerms = false;
  String pdfUrl = '${config.backendBaseUrl}/terms-and-condition'; // Ganti URL dengan URL PDF yang diinginkan
  bool isLoading = true;
  int totalPages = 0;
  Uint8List? pdfBytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerActivation(widget.taskID);
  }

  Future<void> _submitForm() async {
    try {
      var dataNya = {
        'no_ktp': _idNumberController.text,
        'ktp': await MultipartFile.fromFile(_imageFile!.path,
            filename: _imageFile?.path.split('/').last),
        'task_id': widget.taskID,
      };
      
      FormData formData = FormData.fromMap(dataNya);
      
      var response = await dio.post("${config.backendBaseUrl}/subscription/retail/fkb/user/$user_id",
      data:formData,
          // queryParameters: {"taskID": taskID},
          // data: Icons.four_g_mobiledata_outlined,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          }));
      var hasil = response.data;
      var result = hasil['data'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result['status']),
            content: Text(result['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCustomerActivation (taskID) async {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    var response = await dio.get(
        pdfUrl,
        options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode == 200) {
      setState(() {
        pdfBytes = response.data;
        isLoading = false;
        // totalPages = new PDFView{pdfData: pdfBytes};
      });
    } else {
      throw Exception('Failed to load PDF');
    }

    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      token = _pref.getString('token');
      user_id = _pref.getString('user_id');
    });

    print(taskID);
    

    
    response = await dio.get("$linkLaravelAPI/customer/fab",
        queryParameters: {"taskID": taskID},
        options: Options(headers: {
          HttpHeaders.authorizationHeader: token,
        }));
    var hasil = response.data;
    if (hasil['status'] == 'success') {
      setState(() {
        _customerNameController.text =  hasil['data']['name'];
        _installationAddressController.text =  hasil['data']['address'];
        _phoneNumberController.text =  hasil['data']['phone'];
        _idNumberController.text =  hasil['data']['ktp'];
        _selectedServiceType=  hasil['data']['serviceName'];
      });
      
    }else {
      print(hasil);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Kontrak Berlangganan',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _buildTextField(_customerNameController, 'Nama Customer'),
              SizedBox(height: 16.0),
              _buildTextField(
                  _installationAddressController, 'Alamat Pemasangan'),
              SizedBox(height: 16.0),
              _buildTextField(_phoneNumberController, 'Telepon/ Telepon Seluler'),
              SizedBox(height: 16.0),
              _buildKtpUploadField(),
              SizedBox(height: 16.0),
              _buildTextField(_idNumberController, 'Nomor Identitas'),
              SizedBox(height: 16.0),
              // // Container(
              // //     decoration: BoxDecoration(
              // //       borderRadius: BorderRadius.circular(15.0),
              // //       border: Border.all(color: Colors.grey),
              // //     ),
              // //     child: DropdownButtonFormField<String>(
              // //       value: _selectedServiceType,
              // //       onChanged: (String? newValue) {
              // //         setState(() {
              // //           _selectedServiceType = newValue;
              // //         });
              // //       },
              // //       items: <String>[
              // //         'idplay Retail Up To 10Mbps',
              // //         'idplay Retail Up To 20Mbps',
              // //         'idplay Retail Up To 30Mbps',
              // //         'idplay Retail Up To 50 Mbps',
              // //         'idplay Retail Up To 100Mbps',
              // //       ].map<DropdownMenuItem<String>>((String value) {
              // //         return DropdownMenuItem<String>(
              // //           value: value,
              // //           child: Text(value),
              // //         );
              // //       }).toList(),
              // //       decoration: InputDecoration(
              // //         labelText: 'Service Type',
              // //         contentPadding:
              // //             EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              // //         border: InputBorder.none,
              // //       ),
              // //     ),
              // //   ),
              // SizedBox(height: 16.0),
              _buildTextField(_referralCodeController, 'Handler'),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                        if (_agreeToTerms) {
                          _showAgreementPopup(
                              context); // Show agreement popup when checkbox is checked
                        }
                      });
                    },
                  ),
                  Text(
                    'I agree to terms & conditions',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _submitForm();
              // Handle form submission
            },
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              minimumSize: Size(double.infinity, 0), // Set minimum size untuk mengisi lebar layar
              padding: EdgeInsets.symmetric(vertical: 16.0), // Atur padding vertical
            ),
          ),
          
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedServiceType,
        onChanged: (String? newValue) {
          setState(() {
            _selectedServiceType = newValue;
          });
        },
        items: <String>[
          'idplay Retail Up To 10Mbps',
          'idplay Retail Up To 20Mbps',
          'idplay Retail Up To 30Mbps',
          'idplay Retail Up To 50 Mbps',
          'idplay Retail Up To 100Mbps',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Service Type',
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildKtpUploadField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: TextButton.icon(
        onPressed: () async {
          final XFile? image =
              await _picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            setState(() {
              _imageFile = File(image.path);
            });
          }
        },
        icon: Icon(Icons.upload_file), // Change icon to your preference
        label: Text('Upload ID'), // Change label to your preference
      ),
    );
  }

  void _showAgreementPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 500,
              child: SfPdfViewer.network(
                "${config.backendBaseUrl}/terms-and-condition",
                canShowPaginationDialog: true,
                pageSpacing:2,
                ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Add your logic for handling agreement acceptance
                // For example, you can set a variable to indicate agreement acceptance
                // _agreeToTerms = true;
                // Then proceed with further actions.
                Navigator.of(context).pop();
              },
              child: Text('I Agree'),
            ),
          ],
        );
      },
    );
  }
}
