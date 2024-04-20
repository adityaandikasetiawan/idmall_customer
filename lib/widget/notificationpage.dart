import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pembayaran'),
              Tab(text: 'Status Bar'),
            ],
            indicatorColor:
                Colors.orange, // Warna latar belakang tab saat aktif
            labelColor: Colors.orange, // Warna teks pada tab saat aktif
          ),
        ),
        body: TabBarView(
          children: [
            PromotionsPage(),
            StatusBarPage(),
          ],
        ),
      ),
    );
  }
}

class PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPromotionCard(
            context,
            'images/promo1.png',
            'Promosi 1',
            'Deskripsi Promosi 1',
          ),
          _buildPromotionCard(
            context,
            'images/promo1.png',
            'Promosi 4',
            'Deskripsi Promosi 4',
          ),
          _buildPromotionCard(
            context,
            'images/promo2.png',
            'Puasa tuh nahan lapar & haus, internetannya jangan ditahan!',
            'Internet idPlay unlimited bebas kuota lagi promo, nih. Cocok buat kaum mendang-mending. Cus, cek promonya!',
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(
    BuildContext context,
    String imagePath,
    String title,
    String description,
  ) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            height: 200,
            width: 380,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.white,
          thickness: 0.5,
        ),
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(
                  255, 0, 0, 0), // Warna teks menjadi orange
            ),
          ),
          subtitle: Text(description),
        ),
      ],
    );
  }
}

class StatusBarPage extends StatefulWidget {
  @override
  _StatusBarPageState createState() => _StatusBarPageState();
}

class _StatusBarPageState extends State<StatusBarPage> {
  int _currentStep = 0;
  bool _stepOneComplete = false;
  bool _stepTwoComplete = false;
  bool _stepThreeComplete = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Theme(
          data: Theme.of(context).copyWith(),
          child: Stepper(
            currentStep: _currentStep,
            onStepTapped: (int index) {
              // Tidak melakukan apa-apa ketika langkah di-tap
            },
            onStepCancel: _currentStep == 2 ? null : _handleCancel,
            onStepContinue: _currentStep == 2 ? null : _handleContinue,
            steps: [
              Step(
                title: Text('Step 1'),
                content: Text('Content for Step 1'),
                isActive: !_stepOneComplete,
                state:
                    _stepOneComplete ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Step 2'),
                content: Text('Content for Step 2'),
                isActive: !_stepTwoComplete,
                state:
                    _stepTwoComplete ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Step 3'),
                content: Text('Content for Step 3'),
                isActive: !_stepThreeComplete,
                state:
                    _stepThreeComplete ? StepState.complete : StepState.indexed,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    setState(() {
      if (_currentStep == 0) {
        _stepOneComplete = true;
      } else if (_currentStep == 1) {
        _stepTwoComplete = true;
      } else if (_currentStep == 2) {
        _stepThreeComplete = true;
      }
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _handleCancel() {
    setState(() {
      if (_currentStep > 0) {
        if (_currentStep == 1) {
          _stepOneComplete = false;
        } else if (_currentStep == 2) {
          _stepTwoComplete = false;
        } else if (_currentStep == 3) {
          _stepThreeComplete = false;
        }
        _currentStep--;
      }
    });
  }
}
