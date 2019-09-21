class ConferenceWinner {
  String key;
  String name;
  String event;
  String award;

  ConferenceWinner(this.name, this.event, this.award);

  ConferenceWinner.fromJson(Map<String, dynamic> json, String key)
      : key = key,
        name = json["name"],
        event = json["event"],
        award = json["award"];
}