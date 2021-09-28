import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/no_display_data.dart';
import 'package:ivugurura_app/widget/topic_list_item.dart';

class TopicListView extends StatefulWidget {
  final Repository repository;
  const TopicListView({
    Key? key,
    required this.repository,
  }) : super(key: key);

  _TopicListView createState() => _TopicListView();
}

class _TopicListView extends State<TopicListView> {
  Repository get _repository => widget.repository;
  bool isLoading = true;
  List<Topic> topics = [];
  dynamic error;

  Future<void> fetchTopics() async {
    print('Its fetching');
    if (!isLoading) {
      setState(() {
        isLoading = true;
        error = null;
        topics = [];
      });
    }
    try {
      final page = await _repository.getListTopics(context);
      setState(() {
        topics = page.itemList;
        isLoading = false;
        error = null;
      });
    } catch (err) {
      isLoading = false;
      error = err;
    }
  }

  @override
  void initState() {
    fetchTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : error != null
            ? DisplayError(error: error, onTryAgain:fetchTopics)
            : topics.isEmpty
                ? NoDisplayData()
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return TopicListItem(topic: topics[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 16,
                      );
                    },
                    itemCount: topics.length,
                    padding: const EdgeInsets.all(16),
                  );
  }
}
