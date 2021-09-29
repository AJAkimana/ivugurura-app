import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/base_action.dart';
import 'package:ivugurura_app/core/redux/base_reducer.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is BaseAction<Topic, CarouselTopic>) {
    return state.copyWith(
        carouselTopicState: baseReducer(state.carouselTopicState, action));
  }
  if (action is BaseAction<Topic, RecentTopic>) {
    return state.copyWith(
        recentTopicState: baseReducer(state.recentTopicState, action));
  }
  if (action is BaseAction<Topic, TopicDetail>) {
    return state.copyWith(
        topicDetailState: baseReducer(state.topicDetailState, action));
  }
  if (action is BaseAction<Category, CategoriesList>) {
    return state.copyWith(
        categoriesState: baseReducer(state.categoriesState, action));
  }
  if (action is BaseAction<Setting, SettingInfo>) {
    return state.copyWith(
        settingState: baseReducer(state.settingState, action));
  }
  if (action is BaseAction<Topic, CategoryTopic>) {
    return state.copyWith(
        categoryTopic: baseReducer(state.categoryTopic, action));
  }
  return state;
}

@immutable
class AppState {
  final BaseState<Topic, CarouselTopic> carouselTopicState;
  final BaseState<Topic, RecentTopic> recentTopicState;
  final BaseState<Topic, TopicDetail> topicDetailState;
  final BaseState<Category, CategoriesList> categoriesState;
  final BaseState<Setting, SettingInfo> settingState;
  final BaseState<Topic, CategoryTopic> categoryTopic;

  AppState(
      {required this.carouselTopicState,
      required this.recentTopicState,
      required this.topicDetailState,
      required this.categoriesState,
      required this.settingState,
      required this.categoryTopic});

  AppState copyWith(
      {BaseState<Topic, CarouselTopic>? carouselTopicState,
      BaseState<Topic, RecentTopic>? recentTopicState,
      BaseState<Topic, TopicDetail>? topicDetailState,
      BaseState<Category, CategoriesList>? categoriesState,
      BaseState<Setting, SettingInfo>? settingState,
      BaseState<Topic, CategoryTopic>? categoryTopic}) {
    return AppState(
        carouselTopicState: carouselTopicState ?? this.carouselTopicState,
        recentTopicState: recentTopicState ?? this.recentTopicState,
        topicDetailState: topicDetailState ?? this.topicDetailState,
        categoriesState: categoriesState ?? this.categoriesState,
        settingState: settingState ?? this.settingState,
        categoryTopic: categoryTopic ?? this.categoryTopic);
  }
}

class ReduxStore {
  Topic topic() => new Topic();
  static Store<AppState> store() {
    // final topic = new Topic();
    return Store<AppState>(appReducer,
        middleware: [thunkMiddleware],
        initialState: AppState(
            carouselTopicState:
                BaseState<Topic, CarouselTopic>.initial(() => new Topic()),
            recentTopicState:
                BaseState<Topic, RecentTopic>.initial(() => new Topic()),
            topicDetailState: BaseState<Topic, TopicDetail>.initial(
                () => new Topic(),
                dataType: 'object'),
            categoriesState: BaseState<Category, CategoriesList>.initial(
                () => new Category()),
            settingState: BaseState<Setting, SettingInfo>.initial(
                () => Setting(
                    language: Language(name: 'English', short_name: 'en')),
                dataType: 'object'),
            categoryTopic:
                BaseState<Topic, CategoryTopic>.initial(() => new Topic())));
  }
}

Store<AppState> appStore = ReduxStore.store();
