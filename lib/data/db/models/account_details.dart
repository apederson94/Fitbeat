import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

part 'account_details.g.dart';

@HiveType()
class AccountDetails extends HiveObject {
  @HiveField(0)
  String displayName;

  @HiveField(1)
  String email;

  @HiveField(2)
  String id;

  @HiveField(3)
  String photoUrl;

  @HiveField(4)
  String fitbitToken;

  @HiveField(5)
  String userId;

  @HiveField(6)
  List<String> scopes = List<String>();

  @HiveField(7)
  String tokenType;

  @HiveField(8)
  String expiresIn;

  @HiveField(9)
  String googleAccessToken;

  AccountDetails(GoogleSignInAccount account) {
    displayName = account.displayName;
    email = account.email;
    id = account.id;
    photoUrl = account.photoUrl;
  }

  AccountDetails.empty() {
    //do nothing
  }

  bool isEmpty() {
    return email == null;
  }
}
