import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../base_action.dart';
import '../store.dart';

Future<void> fetchCategories(BuildContext context) async {
  DispatchedAction<Category, CategoriesList> dispatchedAction;
  dispatchedAction = DispatchedAction<Category, CategoriesList>();

  appStore.dispatch(dispatchedAction.pending());
  try {
    String acceptLang = await getLangFromPrefs();

    final res = await http.get(
        Uri.parse(categoriesUrl + '?categoryType=with-topics'),
        headers: {'Accept-Language': acceptLang});
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'] as List;
    List<Category> categoriesData =
        jsonData.map((e) => Category.fromJson(e)).toList();
    appStore.dispatch(dispatchedAction.fulfilled(categoriesData));
  } catch (error) {
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}
