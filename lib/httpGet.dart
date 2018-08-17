import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ATM.dart';

var url = "http://192.168.0.100/atmwebservice.php";

Future<List<ATM>> fetchATM() async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    var atmjsonlist = jsonDecode(response.body);
    assert (atmjsonlist is List);

    List<ATM> atmlist = new List<ATM>();

    for (var atm in atmjsonlist){
        atmlist.add(ATM.fromJson(atm));
    }

    return atmlist;

  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}


