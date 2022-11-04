import 'dart:convert';
import 'dart:io';

import 'package:testing_bloc_course/model/person.dart';

class Repository {
  Future<Iterable<Person>> getPersons(String url) => HttpClient()
      // getUrl returns a request
      .getUrl(Uri.parse(url))
      // when we close the request we get a response
      .then((req) => req.close())
      // we transform the response object to string
      .then((res) => res.transform(utf8.decoder).join())
      // we decode the string to dynamic list
      .then((str) => json.decode(str) as List<dynamic>)
      // we parse the list to Person from json
      .then((list) => list.map((e) => Person.fromJson(e)));
}
