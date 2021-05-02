
class GitRepoModel {
  int id;
  String nodeId;
  String name;
  String fullName;
  Owner owner;
  String htmlUrl;
  String description;
  int size;
  bool private;
  int stargazersCount;
  int forks;
  int watchersCount;
  String language;
  double score;

  GitRepoModel(
      {this.id,
      this.nodeId,
      this.name,
      this.fullName,
      this.owner,
      this.private,
      this.htmlUrl,
      this.description,
      this.size,
      this.forks,
      this.stargazersCount,
      this.watchersCount,
      this.language,
      this.score});

  GitRepoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nodeId = json['node_id'];
    name = json['name'];
    private = json['private'];
    fullName = json['full_name'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    htmlUrl = json['html_url'];
    description = json['description'];
    forks = json['forks'];
    size = json['size'];
    stargazersCount = json['stargazers_count'];
    watchersCount = json['watchers_count'];
    language = json['language'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['private'] = this.nodeId;
    data['name'] = this.name;
    data['full_name'] = this.fullName;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['html_url'] = this.htmlUrl;
    data['description'] = this.description;
    data['size'] = this.size;
    data['stargazers_count'] = this.stargazersCount;
    data['watchers_count'] = this.watchersCount;
    data['language'] = this.language;
    data['score'] = this.score;
    return data;
  }
}

class Owner {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String htmlUrl;

  Owner({this.login, this.id, this.nodeId, this.avatarUrl, this.htmlUrl});

  Owner.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    htmlUrl = json['html_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['avatar_url'] = this.avatarUrl;
    data['html_url'] = this.htmlUrl;
    return data;
  }
}
