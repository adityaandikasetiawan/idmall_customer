// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class FABTesting extends StatefulWidget {
  const FABTesting({super.key, required this.taskID});
  final String taskID;

  @override
  State<FABTesting> createState() => _FABTestingState();
}

class _FABTestingState extends State<FABTesting> {
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
  bool _agreeToTerms = false;
  String pdfUrl =
      '${config.backendBaseUrl}/terms-and-condition'; // Ganti URL dengan URL PDF yang diinginkan
  bool isLoading = true;
  int totalPages = 0;
  Uint8List? pdfBytes;
  bool isLoad = false;
  File? ktpImageFile;
  File? signImageFile;
  bool isSign = false;
  bool isUploadSign = false;

  @override
  void initState() {
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

    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
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
    } else {}
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
              child: const Text("Camera"),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Gallery"),
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
        ktpImageFile = File(file.path);
      }
    });
  }

  void getImageSign() async {
    bool? isCamera2 = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Camera"),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Gallery"),
            ),
          ],
        ),
      ),
    );

    if (isCamera2 == null) return;

    XFile? file2 = await ImagePicker().pickImage(
        source: isCamera2 ? ImageSource.camera : ImageSource.gallery);
    if (file2 != null) {
      setState(() {
        signImageFile = File(file2.path);
      });
      signImageFile = await convertImageToPng(signImageFile!);
    }
  }

  Future<File?> convertImageToPng(File imageFile) async {
    try {
      // Baca gambar sebagai objek Image
      img.Image? image = img.decodeImage(await imageFile.readAsBytes());

      // Jika gambar berhasil dibaca, ubah ke format PNG
      if (image != null) {
        // Buat objek Image dalam format PNG
        img.Image pngImage =
            img.copyResize(image, width: image.width, height: image.height);

        // Buat file sementara untuk menyimpan gambar PNG
        // Ambil path file tanpa ekstensi .jpg
        String imagePathWithoutExtension =
            imageFile.path.replaceAll('.jpg', '');

        // Buat file sementara untuk menyimpan gambar PNG
        File pngFile = File('$imagePathWithoutExtension.png');

        // Tulis gambar PNG ke file sementara
        await pngFile.writeAsBytes(img.encodePng(pngImage));

        // Kembalikan file PNG yang telah dibuat
        return pngFile;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentstep == getSteps().length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Syarat & Ketentuan"),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Colors.green),
                  ),
                ),
                onPressed: details.onStepContinue,
                child: isLastStep == true
                    ? const Text("Simpan")
                    : const Text('Lanjutkan'),
              ),
              TextButton(
                style: currentstep == 0
                    ? null
                    : TextButton.styleFrom(
                        backgroundColor: Colors.amber.shade400,
                        shape: const RoundedRectangleBorder(
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
                "Authorization": "Bearer $token",
                "Cache-Control": "no-cache"
              }),
            );
            if (finalResponse.data['status'] == "success") {
              ScaffoldMessenger.of(context).showMaterialBanner(
                MaterialBanner(
                  content: Text("${finalResponse.data['message']}"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationScreen(),
                          ),
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
                  const SnackBar(
                    content: Text(
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
              if (ktpImageFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Mohon upload KTP / Tanda Tangan sebelum melanjutkan",
                    ),
                    showCloseIcon: true,
                  ),
                );
              } else {
                String base64Image = "";
                if (isSign == false && isUploadSign == true) {
                  base64Image = base64Encode(signImageFile!.readAsBytesSync());
                } else if (isSign == true && isUploadSign == false) {
                  images = await _signaturePadKey.currentState?.toImage();
                  final pngByteData =
                      await images!.toByteData(format: ui.ImageByteFormat.png);
                  _sign = pngByteData!.buffer.asUint8List();
                  base64Image = base64Encode(_sign!);
                }
                FormData formData = FormData.fromMap({
                  'signature': base64Image,
                  "type": "AUTOGRAPH",
                });
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
                      "Authorization": "Bearer $token",
                      "Cache-Control": "no-cache"
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
                  // ignore: unused_catch_clause
                } on DioException catch (e) {}
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
          title: const Text("S&K"),
          isActive: currentstep >= 0 ? true : false,
          content: Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Center(
              child: Column(
                children: [
                  const Text("Pasal Kontrak Berlangganan IdPlay"),
                  const SizedBox(
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
                      const Text(
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
            padding: const EdgeInsets.only(
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
                        const Column(
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
                        // const SizedBox(height: 16.0),
                        // _buildTextField(
                        //     _customerNameController, 'Nama Customer'),
                        // const SizedBox(height: 16.0),
                        // _buildTextField(_installationAddressController,
                        //     'Alamat Pemasangan'),
                        // const SizedBox(height: 16.0),
                        // _buildTextField(
                        //     _phoneNumberController, 'Telepon/ Telepon Seluler'),
                        // const SizedBox(height: 16.0),
                        // _buildTextField(_idNumberController, 'Nomor Identitas'),
                        // const SizedBox(height: 16.0),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(15.0),
                        //     border: Border.all(color: Colors.grey),
                        //   ),
                        //   child: DropdownButtonFormField<String>(
                        //     value: _selectedServiceType,
                        //     onChanged: (String? newValue) {
                        //       setState(() {
                        //         _selectedServiceType = newValue;
                        //       });
                        //     },
                        //     items: <String>[
                        //       'idplay Retail Up To 10 Mbps',
                        //       'idplay Retail Up To 20 Mbps',
                        //       'idplay Retail Up To 30 Mbps',
                        //       'idplay Retail Up To 50 Mbps',
                        //       'idplay Retail Up To 100Mbps',
                        //     ].map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Text(value),
                        //       );
                        //     }).toList(),
                        //     decoration: const InputDecoration(
                        //       labelText: 'Service Type',
                        //       contentPadding: EdgeInsets.symmetric(
                        //           horizontal: 16.0, vertical: 12.0),
                        //       border: InputBorder.none,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 16.0),
                        // _buildTextField(
                        //     _referralCodeController, 'Referal Code'),
                        // const SizedBox(height: 16.0),
                        const SizedBox(height: 16.0),
                        const Center(
                          child: Text(
                            "Upload KTP/SIM/Passport",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        _buildKtpUploadField(),
                        ktpImageFile != null
                            ? ElevatedButton(
                                child: const Text("Clear"),
                                onPressed: () {
                                  setState(() {
                                    ktpImageFile = null;
                                  });
                                },
                              )
                            : const SizedBox(),
                        const SizedBox(height: 16.0),
                        const Center(
                          child: Text(
                            "Tanda Tangan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isSign = true;
                                  isUploadSign = false;
                                });
                              },
                              child: const Text("E-Sign"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isSign = false;
                                  isUploadSign = true;
                                });
                              },
                              child: const Text("Upload"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        isSign == true
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: SfSignaturePad(
                                  key: _signaturePadKey,
                                ),
                              )
                            : const SizedBox(),
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
                        isSign == true
                            ? ElevatedButton(
                                child: const Text("Clear"),
                                onPressed: () => {
                                  _signaturePadKey.currentState!.clear(),
                                },
                              )
                            : const SizedBox(),
                        isUploadSign == true
                            ? _buildSignUpload()
                            : const SizedBox(),
                        signImageFile != null
                            ? ElevatedButton(
                                child: const Text("Clear"),
                                onPressed: () {
                                  setState(() {
                                    signImageFile = null;
                                  });
                                },
                              )
                            : const SizedBox(),

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
          title: const Text("FAB"),
          isActive: currentstep >= 2 ? true : false,
          content: Padding(
            padding: const EdgeInsets.only(
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
              icon: const Icon(
                  Icons.upload_file), // Change icon to your preference
              label: const Text(
                  'Upload Card ID'), // Change label to your preference
            ),
    );
  }

  Widget _buildSignUpload() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: signImageFile != null
          ? Image.file(
              signImageFile!,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.fill,
            )
          : TextButton.icon(
              onPressed: () async {
                getImageSign();
              },
              icon: const Icon(
                  Icons.upload_file), // Change icon to your preference
              label: const Text(
                  'Upload Card ID'), // Change label to your preference
            ),
    );
  }
}
