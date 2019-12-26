
class FitbeatDeeplink {
  String target;
  String path;

  FitbeatDeeplink(String stringRepresentation) {
    List<String> splitString = stringRepresentation.split(new RegExp(r'^fitbeat://'));
    RegExp targetMatcher = new RegExp(r'^[a-zA-Z]*');
    target = targetMatcher.stringMatch(splitString[1]);
    path = splitString[1].replaceFirst(targetMatcher, '');
  }
}