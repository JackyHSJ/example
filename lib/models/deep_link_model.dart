

class DeepLinkModel {
  DeepLinkModel({
    required this.inviteCode,
    required this.name,
    required this.avatar,
});
  String inviteCode;
  String name;
  String avatar;

  String createUrl(String baseUri) {
    final Map<String, dynamic>  parameters = {};
    if(inviteCode.isNotEmpty){
      parameters['InviteCode'] = inviteCode;
    }
    if(name.isNotEmpty){
      parameters['name'] = name;
    }
    if(avatar.isNotEmpty){
      parameters['avatar'] = avatar;
    }

    final uri = Uri.parse(baseUri).replace(queryParameters: parameters);
    return uri.toString();
  }
}