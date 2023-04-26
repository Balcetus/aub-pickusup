import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report Page',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text(
              'Office of Protection, Main Gate Building, +961-​1-350000 Extension: 2400',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
