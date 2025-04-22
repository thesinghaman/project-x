import 'package:get/get.dart';
import 'package:sundrift/app/translations/en_us.dart';
import 'package:sundrift/app/translations/es_es.dart';
import 'package:sundrift/app/translations/fr_fr.dart';
import 'package:sundrift/app/translations/zh_cn.dart';
import 'package:sundrift/app/translations/ja_jp.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'es_ES': esES,
        'fr_FR': frFR,
        'zh_CN': zhCN,
        'ja_JP': jaJP,
      };
}
