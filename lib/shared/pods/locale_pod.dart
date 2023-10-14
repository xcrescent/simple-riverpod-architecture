import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brl_app/core/local_storage/app_storage_pod.dart';
import 'package:brl_app/shared/exception/base_exception.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
///This Notifier class used to get current locale and change local in DB
class LocaleNotifier extends AutoDisposeNotifier<Locale> {
  final _localeBoxKey = 'locale';

  @override
  Locale build() {
    final locale = ref.watch(appStorageProvider).get(key: _localeBoxKey);

    if (locale != null) {
      return AppLocalizations.supportedLocales
          .where((element) => element.languageCode == locale)
          .map((e) => Locale(e.languageCode))
          .first;
    } else {
      return AppLocalizations.supportedLocales.first;
    }
  }

  Future<void> changeLocale({required Locale locale}) async {
    final isSupported = AppLocalizations.supportedLocales.contains(locale);
    if (isSupported) {
      state = locale;
      await ref.read(appStorageProvider).put(
            key: _localeBoxKey,
            value: locale.languageCode,
          );
    } else {
      throw BaseException(message: 'Language not supported');
    }
  }
}

final localePod = NotifierProvider.autoDispose<LocaleNotifier, Locale>(
  LocaleNotifier.new,
  name: 'localePod',
);
