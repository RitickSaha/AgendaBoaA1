import 'package:agenda_boa_assignemnt/api/gitSearch_api.dart';
import 'package:agenda_boa_assignemnt/bloc/GitRepo_bloc.dart';
import 'package:agenda_boa_assignemnt/model/gitRepoModel.dart';
import 'package:agenda_boa_assignemnt/views/widgets/LoadingWidget.dart';
import 'package:agenda_boa_assignemnt/views/widgets/RepoWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pagination = 20;
  bool isLoading = true;
  SearchBase selectedSearch = SearchBase.stars;
  Sort selectedSort = Sort.desc;
  Pagination selectedPagination = Pagination.Twenty;
  ScrollController scrollController = ScrollController();
  Filter selectedFilter = Filter.stars;
  GitRepoBloc gitRepoBloc;

  @override
  void initState() {
    newMethod();
    gitRepoBloc = GitRepoBloc(
      sort: selectedSort,
      searchBase: selectedSearch,
      filter: selectedFilter,
      pagination: selectedPagination,
      page: 0,
    );
    gitRepoBloc.setApiRequest.add(Events.UpdateFIilter);
    super.initState();
  }

  void newMethod() {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          _fetchPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000001),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 30),
        ),
        shadowColor: Colors.transparent,
        elevation: null,
      ),
      body: Center(
        child: Stack(
          children: [
            GlassmorphicContainer(
              border: 2,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF000000).withAlpha(55),
                  Color(0xFF000000).withAlpha(55),
                ],
              ),
              blur: 10,
              borderRadius: 30,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              alignment: Alignment.center,
              borderGradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF000000).withAlpha(55),
                    Color(0xC4FFFFFF).withAlpha(45),
                  ],
                  stops: [
                    0.06,
                    1
                  ]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Github's Top Repository",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          _showBottomSheet();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: Colors.blue,
                            ),
                            Text(
                              "Filter",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height -
                      ((MediaQuery.of(context).size.width *
                          MediaQuery.of(context).size.aspectRatio)),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          StreamBuilder<List<GitRepoModel>>(
                            stream: gitRepoBloc.getRepoStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: snapshot.data
                                      .map((e) => RepoWidget(e))
                                      .toList(),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                          if (isLoading) LoadingWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Filter",
                          style: TextStyle(fontSize: 25),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverFillRemaining(
                          fillOverscroll: false,
                          hasScrollBody: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Search By:",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    clipBehavior: Clip.hardEdge,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: SearchBase.values
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedSearch = e;
                                              });
                                            },
                                            child: Chip(
                                              backgroundColor: selectedSearch ==
                                                      e
                                                  ? Colors.blue.withOpacity(0.3)
                                                  : Colors.white
                                                      .withOpacity(0.3),
                                              label: Row(
                                                children: [
                                                  e != SearchBase.forks
                                                      ? Icon(
                                                          e == SearchBase.stars
                                                              ? Icons
                                                                  .star_border_purple500_outlined
                                                              : Icons.edit,
                                                          size: 20,
                                                          color:
                                                              selectedSearch ==
                                                                      e
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white,
                                                        )
                                                      : SvgPicture.asset(
                                                          "assets/fork.svg",
                                                          height: 18,
                                                          color:
                                                              selectedSearch ==
                                                                      e
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white,
                                                        ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    e
                                                        .toString()
                                                        .split(".")[1]
                                                        .replaceFirst(
                                                            e.toString().split(
                                                                ".")[1][0],
                                                            e
                                                                .toString()
                                                                .split(".")[1]
                                                                    [0]
                                                                .toUpperCase()),
                                                    style: TextStyle(
                                                        color:
                                                            selectedSearch == e
                                                                ? Colors.blue
                                                                : Colors.white,
                                                        fontWeight:
                                                            selectedSearch == e
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                        fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                              Text(
                                "Filter By:",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    clipBehavior: Clip.hardEdge,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: Filter.values
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedFilter = e;
                                              });
                                            },
                                            child: Chip(
                                              backgroundColor: selectedFilter ==
                                                      e
                                                  ? Colors.blue.withOpacity(0.3)
                                                  : Colors.white
                                                      .withOpacity(0.3),
                                              label: Row(
                                                children: [
                                                  e != Filter.forks
                                                      ? Icon(
                                                          e == Filter.stars
                                                              ? Icons
                                                                  .star_border_purple500_outlined
                                                              : Icons.edit,
                                                          size: 20,
                                                          color:
                                                              selectedFilter ==
                                                                      e
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white,
                                                        )
                                                      : SvgPicture.asset(
                                                          "assets/fork.svg",
                                                          height: 18,
                                                          color:
                                                              selectedFilter ==
                                                                      e
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white,
                                                        ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    e
                                                        .toString()
                                                        .split(".")[1]
                                                        .replaceFirst(
                                                            e.toString().split(
                                                                ".")[1][0],
                                                            e
                                                                .toString()
                                                                .split(".")[1]
                                                                    [0]
                                                                .toUpperCase()),
                                                    style: TextStyle(
                                                        color:
                                                            selectedFilter == e
                                                                ? Colors.blue
                                                                : Colors.white,
                                                        fontWeight:
                                                            selectedFilter == e
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                        fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                              Text(
                                "Order By:",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    clipBehavior: Clip.hardEdge,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: Sort.values
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedSort = e;
                                              });
                                            },
                                            child: Chip(
                                              backgroundColor: selectedSort == e
                                                  ? Colors.blue.withOpacity(0.3)
                                                  : Colors.white
                                                      .withOpacity(0.3),
                                              label: Row(
                                                children: [
                                                  Icon(
                                                    selectedSort == e
                                                        ? Icons.arrow_downward
                                                        : Icons.arrow_upward,
                                                    size: 20,
                                                    color: selectedSort == e
                                                        ? Colors.blue
                                                        : Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    e
                                                        .toString()
                                                        .split(".")[1]
                                                        .replaceFirst(
                                                            e.toString().split(
                                                                ".")[1][0],
                                                            e
                                                                .toString()
                                                                .split(".")[1]
                                                                    [0]
                                                                .toUpperCase()),
                                                    style: TextStyle(
                                                        color: selectedSort == e
                                                            ? Colors.blue
                                                            : Colors.white,
                                                        fontWeight:
                                                            selectedSort == e
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                        fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Repo Count Per Page:",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: DropdownButton<Pagination>(
                                        items: Pagination.values
                                            .map((Pagination value) {
                                          return new DropdownMenuItem<
                                              Pagination>(
                                            value: value,
                                            child: Text(
                                              value.toString().split(".").last,
                                              style: TextStyle(
                                                  color: value ==
                                                          selectedPagination
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: value ==
                                                          selectedPagination
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                            ),
                                          );
                                        }).toList(),
                                        underline: Container(),
                                        onChanged: (e) {
                                          setState(() {
                                            selectedPagination = e;
                                          });
                                        },
                                        value: selectedPagination,
                                      )),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  gitRepoBloc.filter = selectedFilter;
                                  gitRepoBloc.searchBase = selectedSearch;
                                  gitRepoBloc.sort = selectedSort;
                                  gitRepoBloc.pagination = selectedPagination;
                                  gitRepoBloc.page = 1;
                                  gitRepoBloc.setApiRequest
                                      .add(Events.UpdateFIilter);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Apply Filter",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _fetchPage() {
    isLoading = true;
    setState(() {});
    gitRepoBloc.setApiRequest.add(Events.LoadMore);
  }

  void updateLoadingState() {
    isLoading = false;
    setState(() {});
  }
}
