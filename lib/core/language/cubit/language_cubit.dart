import 'package:app_chat/core/language/inherited_language_widget.dart';
import 'package:app_chat/data/local_cache.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState(languageModeEnum: LanguageModeEnum.en));

  Future<void> init() async {
    final languageModeString = await LocalCache.getString(StringCache.language);
    if (languageModeString.isEmpty) {
      emit(const LanguageState(languageModeEnum: LanguageModeEnum.en));
    } else {
      emit(LanguageState(languageModeEnum: LanguageModeEnum.values.byName(languageModeString)));
    }
  }

  Future<void> changeLanguage(LanguageModeEnum languageModeEnum) async {
    await LocalCache.setString(StringCache.language, languageModeEnum.name);
    emit(LanguageState(languageModeEnum: languageModeEnum));
  }
}
