import 'dart:convert';

import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/core/res/FileManager.dart';

class JsonFileManager extends FileManager {
  Future<dynamic> loadFromFile(String file) async {
    bool succes = await checkFile(file, true);
    if (succes) {
      String data = checkedFIle!.readAsStringSync();
      try {
        dynamic thing = jsonDecode(data);
        return thing;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  //TODO: make this function more dynamic
  // currentrly its only available for the Setting typed classes
  Future<void> processDifferences(String file) async {
    List<Setting> list = [];
    await loadFromFile(file).then((loadedFile) {
      if (loadedFile == null) {
        return;
      }
      int index = 0;
      for (var set in SettingVars.Settings) {
        //preform linear search through the filed settings
        bool found = false;
        for (var l in loadedFile) {
          if (l == null) {
            print("Found NULL entry while processing file differences");
            continue;
          }
          Setting loadedSetting = Setting.fromJson(l);
          if (loadedSetting.name == set.name) {
            print("DEBUG");
            list.add(loadedSetting);
            found = true;
          }
        }
        // if we didnt find this one,
        if (!found) {
          list.add(set);
        }

        index++;
      }
      String jsonString = jsonEncode(list);
      write(SettingVars.SETTINGS_FILE, jsonString);
      print("return reached");
      return;
    });
  }
}
