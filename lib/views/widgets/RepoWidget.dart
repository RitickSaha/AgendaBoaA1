import 'package:agenda_boa_assignemnt/model/gitRepoModel.dart';
import 'package:agenda_boa_assignemnt/views/webView/headlessWebView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RepoWidget extends StatelessWidget {
  final GitRepoModel e;
  RepoWidget(this.e);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return InAppWebViewExampleScreen(e.owner.htmlUrl);
                }),
              );
            },
            child: ClipOval(
              child: Image.network(
                e.owner.avatarUrl,
              ),
            ),
          ),
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return InAppWebViewExampleScreen(e.htmlUrl);
                }),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.fullName.replaceFirst(
                    e.fullName[0],
                    e.fullName[0].toUpperCase(),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    e.owner.login,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  e.description ?? "No Discription Provided",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star_border_purple500_outlined),
                        SizedBox(
                          width: 4,
                        ),
                        Text(e.stargazersCount.toString())
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye),
                        SizedBox(
                          width: 4,
                        ),
                        Text(e.watchersCount.toString())
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/fork.svg",
                          height: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(e.forks.toString())
                      ],
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    Chip(
                      backgroundColor: Colors.blue.withOpacity(0.3),
                      label: Text(
                        e.language == null ? "Not Set" : e.language.toString(),
                        style: TextStyle(color: Colors.blue),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (e.private)
                      Chip(
                        backgroundColor: Colors.yellow.withOpacity(0.3),
                        label: Text(
                          "Private",
                          style: TextStyle(color: Colors.yellow),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    if (!e.private)
                      Chip(
                        backgroundColor: Colors.green.withOpacity(0.3),
                        label: Text(
                          "Public",
                          style: TextStyle(color: Colors.green),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.white.withOpacity(0.3),
        )
      ],
    );
  }
}
