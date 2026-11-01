import 'package:flutter/material.dart';

final ValueNotifier<bool> isHindi = ValueNotifier(true);
const accent = Color(0xFF5B4BFF);

void main() => runApp(const StudyNestApp());

class StudyNestApp extends StatelessWidget {
  const StudyNestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyNest',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isHindi,
      builder: (context, hi, _) {
        final pages = <Widget>[
          const TodayPage(),
          const Center(child: Text('Focus')),
          const Center(child: Text('Books')),
          const Center(child: Text('Alarms')),
          const Center(child: Text('Profile')),
        ];
        return Scaffold(
          appBar: AppBar(
            title: Text(hi ? 'नमस्ते, टॉपर!' : 'Hello, Topper!'),
            actions: [
              TextButton(
                onPressed: () => isHindi.value = !hi,
                child: Text(hi ? 'EN' : 'हिं'),
              ),
            ],
          ),
          body: pages[tab],
          bottomNavigationBar: NavigationBar(
            selectedIndex: tab,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: [
              NavigationDestination(icon: const Icon(Icons.checklist), label: hi ? 'आज' : 'Today'),
              NavigationDestination(icon: const Icon(Icons.timer), label: hi ? 'फोकस' : 'Focus'),
              NavigationDestination(icon: const Icon(Icons.menu_book), label: hi ? 'किताबें' : 'Books'),
              NavigationDestination(icon: const Icon(Icons.alarm), label: hi ? 'अलार्म' : 'Alarms'),
              NavigationDestination(icon: const Icon(Icons.person), label: hi ? 'प्रोफ़ाइल' : 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

class Task {
  String title;
  bool done;
  Task(this.title, {this.done = false});
}

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});
  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final List<Task> tasks = [Task('Physics: Ch.5'), Task('Maths: 20 Qs')];
  final TextEditingController ctrl = TextEditingController();

  void add() {
    final v = ctrl.text.trim();
    if (v.isEmpty) return;
    setState(() => tasks.insert(0, Task(v)));
    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final done = tasks.where((t) => t.done).length;
    final p = tasks.isEmpty ? 0.0 : done / tasks.length;
    final hi = isHindi.value;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: p,
                  strokeWidth: 8,
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$done/${tasks.length}',
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                onSubmitted: (_) => add(),
                decoration: InputDecoration(
                  hintText: hi ? 'पढ़ाई का टास्क जोड़ें…' : 'Add a study task…',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: add, child: Text(hi ? 'जोड़ें' : 'Add')),
          ],
        ),
        const SizedBox(height: 10),
        ...tasks.map(
          (t) => Card(
            child: CheckboxListTile(
              value: t.done,
              onChanged: (v) => setState(() => t.done = v ?? false),
              title: Text(
                t.title,
                style: TextStyle(decoration: t.done ? TextDecoration.lineThrough : null),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
