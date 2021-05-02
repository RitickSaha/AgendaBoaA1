import 'dart:async';
import 'dart:developer';

import 'package:agenda_boa_assignemnt/api/gitSearch_api.dart';
import 'package:agenda_boa_assignemnt/bloc/blocBase.dart';
import 'package:agenda_boa_assignemnt/model/gitRepoModel.dart';

enum Events { UpdateFIilter, LoadMore }

class GitRepoBloc extends BlocBase {
  StreamController<List<GitRepoModel>> _gitRepo =
      StreamController<List<GitRepoModel>>.broadcast();
  StreamController<Events> _apiRequest = StreamController<Events>();
  GitSearchApi gitApiInstance;
  Stream<List<GitRepoModel>> get getRepoStream => _gitRepo.stream;
  Sink<Events> get setApiRequest => _apiRequest.sink;

  List<GitRepoModel> repoModel = [];
  var sort = Sort.desc;
  var searchBase = SearchBase.stars;
  var filter = Filter.stars;
  var pagination = Pagination.Ten;
  var page = 1;

  GitRepoBloc({
    this.filter,
    this.pagination,
    this.page,
    this.searchBase,
    this.sort,
  }) {
    gitApiInstance = GitSearchApi(
      sort: sort,
      searchBase: searchBase,
      filter: filter,
      pagination: pagination,
      page: page,
    );
    _apiRequest.stream.listen((event) {
      switch (event) {
        case Events.UpdateFIilter:
          gitApiInstance = GitSearchApi(
            sort: sort,
            searchBase: searchBase,
            filter: filter,
            pagination: pagination,
            page: page,
          );
          _fetchRepo();
          break;
        case Events.LoadMore:
          log("Page: $page ,,,,, Items ${repoModel.length} Count $pagination");
          gitApiInstance = GitSearchApi(
            sort: sort,
            searchBase: searchBase,
            filter: filter,
            pagination: pagination,
            page: ++page,
          );
          _loadMore();
          break;
        default:
      }
    });
  
  }

  @override
  void dispose() {
    _gitRepo.close();
    _apiRequest.close();
  }

  Future<void> _fetchRepo() async {
    try {
      repoModel = await gitApiInstance.fetchSearchRepo();
      _gitRepo.sink.add(await gitApiInstance.fetchSearchRepo());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loadMore() async {
    try {
      var event = await gitApiInstance.fetchSearchRepo();
      repoModel.addAll(event);
      _gitRepo.sink.add(repoModel);
    } catch (e) {
      log(e.toString());
    }
  }
}
