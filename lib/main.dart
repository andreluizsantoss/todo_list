import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/database/database_admin_connection.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/home_page.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';

import 'app/modules/new_task/new_task_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseAdminConnection databaseAdminConnection = DatabaseAdminConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(databaseAdminConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(databaseAdminConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodosRepository(),
        )
      ],
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9129),
          buttonColor: Color(0xFFFF9129),
          textTheme: GoogleFonts.robotoTextTheme(),
          primarySwatch: Colors.blue,
        ),
        routes: {
          NewTaskPage.routerName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var day = ModalRoute.of(_).settings.arguments;
                  return NewTaskController(
                    repository: context.read<TodosRepository>(),
                    day: day,
                  );
                },
                child: NewTaskPage(),
              ),
        },
        home: ChangeNotifierProvider(
          create: (context) {
            // ! Anterior versão 4.1
            // var repository = Provider.of<TodosRepository>(context);

            // ! A partir versão 4.1
            var repository = context.read<TodosRepository>();

            return HomeController(repository: repository);
          },
          child: HomePage(),
        ),
      ),
    );
  }
}
