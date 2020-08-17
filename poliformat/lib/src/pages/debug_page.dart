

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
//import 'package:html/parser.dart' as parse;
import 'package:http/http.dart' as http;




class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  var headers;
  bool logged=false;
  Future<String> _body;
  String _newBody;
 @override
  void initState() {
    super.initState();
    _body = _login("https://intranet.upv.es/exp/aute_intranet");    
  }
  @override
  Widget build(BuildContext context) {
    //final body = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Center(child :Text("Home Page"))
      ),
      body: !logged ? FutureBuilder(
        future: _body,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          return snapshot.data!=null ? SingleChildScrollView(child: Html(data: snapshot.data,onLinkTap: (link) async {
             print("Navigating to $link");
             if(link.length>5)
              _newBody= await _login(link);
            setState(() {
            });
          },)) : Center(child: CircularProgressIndicator());
        } 
      ) :
      SingleChildScrollView(child: Html(data: _newBody ,onLinkTap: (link) async {
          print("Navigating to $link");
          if(link.length>5)
          {
            final response =await _navigate(link);
            _newBody= response.body;
            setState(() {} );
          }
        })
       )
    );
  }
  Future<http.Response> _navigate(String url) async{
    final resp = await http.get(url,headers: headers);
    print("url: $url");
    return resp;
  }
   Future<String> _login(String url) async {
    //final credentials = "${bloc.email}:${bloc.password}";

    //final url='https://alumnos.upv.es/${bloc.email[0]}/${bloc.email}';
    //final url='https://intranet.upv.es/exp/aute_intranet';

    Map<String, String> data ={
      "clau" : "8396",
      "dni" : "73658348",
      "id" : "c",
    };
    var resp = await http.post(url,body: data);//,headers:{'Authorization':'Basic $encoded'});
    final header = resp.headers;
    print("Status Code 1 ${resp.statusCode}");
    print("header 1  ${resp.headers}");
    print("header 1  ${header["set-cookie"]}");
    final loc=resp.headers["location"];
    logged=true;
    headers = {
      "cookie" : header["set-cookie"],
    };
    //resp = await _navigate(header["location"]);
    resp = await _navigate(loc);
    print("Status Code 2 ${resp.statusCode}");
    print("header 2  ${resp.headers}");
    print("url 2 ${resp.headers["location"]}");

    headers['cookie'] = resp.headers["set-cookie"];
    print(headers);
    resp = await _navigate(loc);
    print("Status Code 3 ${resp.statusCode}");
    print("header 3  ${resp.headers}");
    print("url 3 ${resp.headers["location"]}");
    return resp.body;

    /*final resp2 = await http.get("https://poliformat.upv.es/portal/login", headers: newHead);
    print(resp2.body.length);
    print(resp2.headers);
    print(resp2.statusCode);*/
    //if(resp.statusCode==200)
    //{
      //Navigator.pushReplacementNamed(context, 'home',arguments: {'body': resp.body,'header': {'Authorization':'Basic $encoded'}});
     // Navigator.pushReplacementNamed(context, 'poliformat', arguments: resp.body);
    //}
  }
}