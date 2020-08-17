import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parse;
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var headers;

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    final body=args["body"];
    headers=args["header"];
    final lista = _parsearHtml(body);
    return Scaffold(
      appBar: AppBar(
        title: Center(child :Text("Disco W - UPV"))
      ),
      body: _crearLista(context, lista),
    );
  }

  _navigate(BuildContext context,String href) async
  {
    String url='https://alumnos.upv.es'+href;
 
    final resp = await http.get(url,headers: headers);
    if(resp.statusCode==200)
    {
      Navigator.pushReplacementNamed(context, 'home',arguments: {"body": resp.body, "header" : headers});
    }
  }

  _descargar(String url) async
  {
    
    //final documentsDirectory = await getApplicationDocumentsDirectory();
    final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    print(downloadsDirectory.path);

    await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    await FlutterDownloader.enqueue(
      url: 'https://alumnos.upv.es' + url,
      savedDir: downloadsDirectory.path,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      headers: headers,
    );
  }

  _crearLista(BuildContext context, var list)
  {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context , i){
        return ListTile(
          title: Text(list[i].text),
          leading: i==0 ? Icon(Icons.arrow_back) : (list[i].attributes["href"].contains('.') ? Icon(Icons.file_download) : Icon(Icons.folder)),
          onTap: ()=>list[i].attributes["href"].contains('.') ? _descargar(list[i].attributes["href"]) : _navigate(context,list[i].attributes["href"]),
        );
      },
    );
  }

  _parsearHtml(String html)
  {
    var doc = parse.parse(html);
    final list = doc.getElementsByTagName("A");

    for(int i=0; i<list.length;i++)
    {
      print(list[i].text);
      print(list[i].attributes["href"]);
    }
    return list;
  }



}