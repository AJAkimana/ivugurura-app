import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/data/in_memory_store.dart';
import 'package:ivugurura_app/core/data/remote_store.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependenciesProvider extends SingleChildStatelessWidget {
  const DependenciesProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: [
        _DioProvider(),
        _RemoteStoreProvider(),
        _InMemoryStoreProvider(),
        _RepositoryProvider()
      ],
      child: child,
    );
  }
}

class _DioProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final acceptLang = LocalizedApp.of(context).delegate.currentLocale.languageCode;
    final configuration = BaseOptions(
      baseUrl: API_APP_URL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {'Accept-Language': acceptLang}
    );

    return Provider<Dio>(
      create: (_) => Dio(configuration),
      child: child,
    );
  }
}

class _InMemoryStoreProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider<InMemoryStore>(
        create: (_) => InMemoryStore(), child: child);
  }
}

class _RemoteStoreProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ProxyProvider<Dio, RemoteStore>(
      update: (_, dio, __) => RemoteStore(dio: dio),
      child: child,
    );
  }
}

class _RepositoryProvider extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ProxyProvider2<RemoteStore, InMemoryStore, Repository>(
      update: (_, remoteApi, inMemoryStore, __) {
        return Repository(remoteStore: remoteApi, inMemoryStore: inMemoryStore);
      },
      child: child,
    );
  }
}
