import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

extension dynamicListConversion on List<dynamic> {
  List<String> convertToStringList() {
    List<String> tmp = List<String>();
    this.forEach((value) => {
      tmp.add(value.toString())
    });

    return tmp;
  }
}

extension googleSignInAccountConversion on GoogleSignInAccount {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> tmp = Map<String, dynamic>();
    tmp['displayName'] = this.displayName;
    tmp['email'] = this.email;
    tmp['id'] = this.id;
    tmp['photoUrl'] = this.photoUrl;


    return tmp;
  }
}

extension timeStrip on DateTime {
  DateTime stripTime() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    dateFormat.format(this);
    return this;
  }

}