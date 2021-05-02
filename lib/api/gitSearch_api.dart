
import 'dart:convert';

import 'package:agenda_boa_assignemnt/model/gitRepoModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

enum Sort { asc, desc }
enum Filter {
  stars,
  forks,
  commits,
}
enum SearchBase {
  stars,
  forks,
  commits,
}
enum Pagination {
  Ten,
  Twenty,
  Thirty,
  Forty,
  Fifty,
}

class GitSearchApi {
  String url = "api.github.com";
  String query;
  GitSearchApi({
    @required Sort sort,
    @required SearchBase searchBase,
    @required Filter filter,
    @required Pagination pagination,
    @required int page,
  }) {
    int count = 20;
    switch (pagination) {
      case Pagination.Ten:
        count = 10;
        break;
      case Pagination.Twenty:
        count = 20;
        break;
      case Pagination.Thirty:
        count = 30;
        break;
      case Pagination.Forty:
        count = 40;
        break;
      case Pagination.Fifty:
        count = 50;
        break;
    }
    this.query =
        "/search/repositories?order=${sort.toString().split(".")[1]}&q=${searchBase.toString().split(".")[1]}&sort=${filter.toString().split(".")[1]}&type=Repositories&per_page=$count&page=$page";
  }
  Future<List<GitRepoModel>> fetchSearchRepo() async {
    Response apiResponse = await get(Uri.parse("https://" + url + query));
    if (apiResponse.statusCode == 200) {
      List<dynamic> mapResponse = jsonDecode(apiResponse.body)['items'];
      List<GitRepoModel> repoList = [];
      mapResponse.forEach((value) {
        repoList.add(GitRepoModel.fromJson(value));
      });
      return repoList;
    } else {
      throw Exception('Failed to load album${apiResponse.statusCode}');
    }
  }
}
