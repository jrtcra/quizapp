import 'package:flutter/material.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/topics/drawer.dart';
import 'package:quizapp/topics/topic_item.dart';
import 'package:quizapp/shared/shared.dart';
import 'package:quizapp/services/models.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
        future: FirestoreService().getTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var topics = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.deepPurple,
                  title: const Text('Topics'),
                ),
                drawer: TopicDrawer(topics: topics),
                body: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: topics
                        .map((topic) => TopicItem(topic: topic))
                        .toList()),
                bottomNavigationBar: const BottomNavBar());
          } else {
            return const Text('no topics found');
          }
        });
  }
}
