class Secret {
  final String pk;
  final String offluserId;
  final String offpassword;
  final String AUTH0DOMAIN;
  final String AUTH0CLIENTID;
  final String AUTH0REDIRECTURI;
  final String link;
  Secret({
    this.pk = "",
    this.offluserId = "",
    this.offpassword = "",
    this.link ="",
    this.AUTH0CLIENTID="",
    this.AUTH0DOMAIN="",
    this.AUTH0REDIRECTURI=""
  });
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(
        pk: jsonMap["pk"],
        offluserId: jsonMap["offluserId"],
        offpassword: jsonMap["offpassword"],
      AUTH0DOMAIN: jsonMap["AUTH0DOMAIN"],
      AUTH0CLIENTID: jsonMap["AUTH0CLIENTID"],
      AUTH0REDIRECTURI: jsonMap["AUTH0_REDIRECT_URI"],
      link: jsonMap["link"]

    );
  }
}
