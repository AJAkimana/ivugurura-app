import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../base_action.dart';
import '../store.dart';

Future<void> fetchCategories(BuildContext context) async {
  DispatchedAction<Category, CategoriesList> dispatchedAction;
  dispatchedAction = DispatchedAction<Category, CategoriesList>();

  appStore.dispatch(dispatchedAction.pending());
  try {
    String? acceptLang =
        LocalizedApp.of(context).delegate.currentLocale.languageCode;

    final res = await http.get(Uri.parse(categoriesUrl),
        headers: {'Accept-Language': acceptLang});
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'] as List;
    List<Category> categoriesData =
        jsonData.map((e) => Category.fromJson(e)).toList();
    appStore.dispatch(dispatchedAction.fulfilled(categoriesData));
  } catch (error) {
    print('{=======================Category list');
    print(error.toString());
    print('=========================}');
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}
