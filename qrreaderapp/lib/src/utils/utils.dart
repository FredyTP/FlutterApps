import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
openScan(BuildContext context, ScanModel scan) async {
  if(scan.tipo=='http')
  {
    final url=scan.valor;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  else
  {
    Navigator.pushNamed(context, 'maps',arguments: scan);
  }
}