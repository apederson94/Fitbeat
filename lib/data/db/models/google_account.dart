
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

part 'google_account.g.dart';

@HiveType()
class GoogleAccount extends HiveObject {

  @HiveField(0)
  String displayName;

  @HiveField(1)
  String email;

  @HiveField(2)
  String id;

  @HiveField(3)
  String photoUrl;

  GoogleAccount(GoogleSignInAccount account) {
    displayName = account.displayName;
    email = account.email;
    id = account.id;
    photoUrl = account.photoUrl;
  }

  GoogleAccount.empty() {
    //do nothing
  }
}