import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:idmall/pages/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:idmall/consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:idmall/config/config.dart' as config;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class FABTesting extends StatefulWidget {
  const FABTesting({super.key, required this.taskID});
  final String taskID;

  @override
  State<FABTesting> createState() => _FABTestingState();
}

class _FABTestingState extends State<FABTesting> {
  @override
  int currentstep = 0;
  String? token;
  ui.Image? images;
  Uint8List? _sign;
  Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _installationAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  // final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  String? _selectedServiceType;
  late File _image;
  final ImagePicker _picker = ImagePicker();
  bool _agreeToTerms = false;
  String pdfUrl =
      '${config.backendBaseUrl}/terms-and-condition'; // Ganti URL dengan URL PDF yang diinginkan
  bool isLoading = true;
  int totalPages = 0;
  Uint8List? pdfBytes;
  bool isLoad = false;
  Future<String>? _pdfFuture;
  File? ktpImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerActivation();
  }

  Future getCustomerActivation() async {
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
    });

    response = await dio.get("$linkLaravelAPI/customer/fab",
        queryParameters: {"taskID": widget.taskID},
        options: Options(headers: {
          HttpHeaders.authorizationHeader: token,
        }));
    var hasil = response.data;
    if (hasil['status'] == 'success') {
      setState(() {
        _customerNameController.text = hasil['data']['name'];
        _installationAddressController.text = hasil['data']['address'];
        _phoneNumberController.text = hasil['data']['phone'];
        _idNumberController.text = hasil['data']['ktp'];
        // _selectedServiceType = hasil['data']['serviceName'] ?? "";
      });
    } else {
      print(hasil);
    }
  }

  void getImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Camera"),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Gallery"),
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) return;

    XFile? file = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (file != null) {
        ktpImageFile = File(file!.path);
      }
    });
  }

  Widget build(BuildContext context) {
    final isLastStep = currentstep == getSteps().length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Syarat & Ketentuan"),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        controlsBuilder: (context, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Colors.green),
                  ),
                ),
                onPressed: details.onStepContinue,
                child: isLastStep == true ? Text("Simpan") : Text('Lanjutkan'),
              ),
              TextButton(
                style: currentstep == 0
                    ? null
                    : TextButton.styleFrom(
                        backgroundColor: Colors.amber.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(color: Colors.amber),
                        ),
                      ),
                onPressed: currentstep != 0 ? details.onStepCancel : null,
                child: Text(currentstep != 0 ? 'Kembali' : ''),
              ),
            ],
          );
        },
        currentStep: currentstep,
        onStepContinue: () async {
          if (isLastStep) {
            var finalResponse = await dio.post(
              '${config.backendBaseUrl}/submit-fab/${widget.taskID}',
              options: Options(headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              }),
            );
            if (finalResponse.data['status'] == "success") {
              ScaffoldMessenger.of(context).showMaterialBanner(
                MaterialBanner(
                  content: Text("${finalResponse.data['message']}"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    )
                  ],
                ),
              );
            }
          } else {
            if (currentstep == 0) {
              if (_agreeToTerms == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Mohon setujui syarat & ketentuan sebelum melanjutkan",
                    ),
                    showCloseIcon: true,
                  ),
                );
              } else {
                setState(() {
                  currentstep += 1;
                });
              }
            } else if (currentstep == 1) {
              images = await _signaturePadKey.currentState?.toImage();
              if (ktpImageFile == null ||
                  _signaturePadKey.currentState!.toPathList().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Mohon upload KTP / Tanda Tangan sebelum melanjutkan",
                    ),
                    showCloseIcon: true,
                  ),
                );
              } else {
                final pngByteData =
                    await images!.toByteData(format: ui.ImageByteFormat.png);
                _sign = pngByteData!.buffer.asUint8List();
                String base64Image = base64Encode(_sign!);
                FormData formData =
                    FormData.fromMap({'signature': base64Image});
                FormData formData2 = FormData.fromMap({
                  'ktp': await MultipartFile.fromFile(ktpImageFile!.path,
                      filename: ktpImageFile?.path.split('/').last),
                  'task_id': widget.taskID,
                });
                try {
                  var response = await dio.post(
                    '${config.backendBaseUrl}/subscription/signature/upload/${widget.taskID}',
                    data: formData,
                    options: Options(headers: {
                      "Content-Type": "multipart/form-data",
                      "Authorization": "Bearer $token"
                    }),
                  );

                  var response2 = await dio.post(
                    '${config.backendBaseUrl}/subscription/retail/fkb/user',
                    data: formData2,
                    options: Options(headers: {
                      "Content-Type": "multipart/form-data",
                      "Authorization": "Bearer $token"
                    }),
                  );
                  if (response.data['status'] == 'success' &&
                      response2.data['status'] == 'success') {
                    isLoad = true;

                    setState(() {
                      currentstep += 1;
                    });
                  }
                } on DioException catch (e) {
                  print(e);
                }
              }
            }
          }
        },
        onStepCancel: () {
          setState(() {
            currentstep -= 1;
          });
        },
        steps: getSteps(),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          title: Text("S&K"),
          isActive: currentstep >= 0 ? true : false,
          content: Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Center(
              child: Column(
                children: [
                  Text("Pasal Kontrak Berlangganan IdPlay"),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 600,
                    child: SfPdfViewer.network(
                      "${config.backendBaseUrl}/terms-and-condition",
                      canShowPaginationDialog: true,
                      pageSpacing: 2,
                      scrollDirection: PdfScrollDirection.vertical,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Saya setuju dengan syarat & ketentuan',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
          title: const Text("E-Sign"),
          isActive: currentstep >= 1 ? true : false,
          content: Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Center(
              child: SizedBox(
                height: 600,
                child: SingleChildScrollView(
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
                        _buildTextField(
                            _customerNameController, 'Nama Customer'),
                        SizedBox(height: 16.0),
                        _buildTextField(_installationAddressController,
                            'Alamat Pemasangan'),
                        SizedBox(height: 16.0),
                        _buildTextField(
                            _phoneNumberController, 'Telepon/ Telepon Seluler'),
                        SizedBox(height: 16.0),
                        _buildTextField(_idNumberController, 'Nomor Identitas'),
                        SizedBox(height: 16.0),
                        Container(
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
                              'idplay Retail Up To 10 Mbps',
                              'idplay Retail Up To 20 Mbps',
                              'idplay Retail Up To 30 Mbps',
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                            _referralCodeController, 'Referal Code'),
                        SizedBox(height: 16.0),
                        _buildKtpUploadField(),
                        ktpImageFile != null
                            ? ElevatedButton(
                                child: Text("Clear"),
                                onPressed: () {
                                  setState(() {
                                    ktpImageFile = null;
                                  });
                                },
                              )
                            : Text(""),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: SfSignaturePad(
                            key: _signaturePadKey,
                          ),
                        ),
                        // ElevatedButton(
                        //   child: Text("Save"),
                        //   onPressed: () async {
                        //     images =
                        //         await _signaturePadKey.currentState?.toImage();
                        //     final pngByteData = await images!
                        //         .toByteData(format: ui.ImageByteFormat.png);
                        //     _sign = pngByteData!.buffer.asUint8List();
                        //     String base64Image = base64Encode(_sign!);
                        //     log(base64Image);
                        //   },
                        // ),
                        ElevatedButton(
                          child: Text("Clear"),
                          onPressed: () => {
                            _signaturePadKey.currentState!.clear(),
                          },
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Handle form submission
                        //   },
                        //   child: Text(
                        //     'Submit',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.orange,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     minimumSize: Size(double.infinity,
                        //         0), // Set minimum size untuk mengisi lebar layar
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 16.0), // Atur padding vertical
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Step(
          title: Text("FAB"),
          isActive: currentstep >= 2 ? true : false,
          content: Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Center(
              child: SizedBox(
                height: 600,
                child: isLoad == false
                    ? null
                    : SfPdfViewer.network(
                        "${config.backendBaseUrl}/subscription/fkb/generate-pdf/${widget.taskID}",
                        canShowPaginationDialog: true,
                        pageSpacing: 2,
                      ),
              ),
            ),
          ),
        ),
      ];

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
      child: ktpImageFile != null
          ? Image.file(
              ktpImageFile!,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.fill,
            )
          : TextButton.icon(
              onPressed: () async {
                getImage();
              },
              icon: Icon(Icons.upload_file), // Change icon to your preference
              label: Text('Upload KTP'), // Change label to your preference
            ),
    );
  }

  Future<void> _showDialogTerms(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'Mohon setujui syarat & ketentuan\n'
            'sebelum Anda lanjut ke langkah berikutnya\n',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: InputBorder.none,
      ),
    ),
  );
}
