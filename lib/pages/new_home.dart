import 'package:flutter/material.dart';

class NewHomes extends StatefulWidget {
  const NewHomes({super.key});

  @override
  State<NewHomes> createState() => _NewHomesState();
}

class _NewHomesState extends State<NewHomes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Row(
          children: [
            Text("Muhammad Yahya"),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tagihan Internet"),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Rp.321.900"),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.all(8.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Terbayar"),
                        Text("04 Aug' 24"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
