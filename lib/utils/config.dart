import 'package:fluro/fluro.dart';
import 'package:vc_deca_flutter/models/announcement.dart';
import 'package:vc_deca_flutter/models/conference.dart';
import 'package:vc_deca_flutter/models/conference_agenda_item.dart';
import 'package:vc_deca_flutter/models/conference_winner.dart';
import 'package:vc_deca_flutter/models/version.dart';

final router = new Router();

Version appVersion = new Version("2.1.0+1");
String appStatus = "";
String appFull = "Version ${appVersion.toString()}";

String getDbUrl(String ref) {
  return "https://vc-deca.firebaseio.com/$ref/.json";
}

List<String> permsList = new List();

List<Announcement> announcementList = new List();
List<Conference> conferenceList = new List();
List<ConferenceWinner> winnerList = new List();
List<ConferenceAgendaItem> agendaList = new List();

String appLegal = """
MIT License
Copyright (c) 2019 Equinox Initiative
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";