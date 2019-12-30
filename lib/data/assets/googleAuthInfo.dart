import 'package:fitbeat/utils/extensions.dart';

class GoogleAuthInfo {
  String clientId;
  String projectId;
  String authUri;
  String tokenUri;
  String authProviderCertUrl;
  String clientSecret;
  List<String> redirectUris;
  List<String> scopes;

  GoogleAuthInfo(Map<String, dynamic> jsonObject) {
    final json = jsonObject['installed'];
    clientId = json['client_id'];
    projectId = json['project_id'];
    authUri = json['auth_uri'];
    tokenUri = json['token_uri'];
    authProviderCertUrl = json['auth_provider_x509_cert_url'];
    clientSecret = json['client_secret'];
    List<dynamic> tmpArray = json['redirect_uris'];
    redirectUris = tmpArray.convertToStringList();
    tmpArray = json['scopes'];
    scopes = tmpArray.convertToStringList();
  }
}
