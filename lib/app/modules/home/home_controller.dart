import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/models/todo_model.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';
import 'package:collection/collection.dart';

class HomeController extends ChangeNotifier {
  final TodosRepository repository;
  int selectTab = 1;
  var dateFormat = DateFormat('dd/MM/yyyy');
  DateTime daySelected;
  DateTime startFilter;
  DateTime endFilter;
  Map<String, List<TodoModel>> listTodos;

  HomeController({@required this.repository}) {
    findAllForWeek();
  }

  Future<void> changeSelectedTab(BuildContext context, int index) async {
    selectTab = index;
    switch (index) {
      case 0:
        filterFinalized();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(Duration(days: (360 * 3))),
          lastDate: DateTime.now().add(Duration(days: (360 * 10))),
        );

        if (day != null) {
          daySelected = day;
          findTodoBySelectedDay();
        }

        break;
    }
    notifyListeners();
  }

  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();

    startFilter = DateTime.now();

    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: (startFilter.weekday - 1)));
    }
    endFilter = startFilter.add(Duration(days: 6));

    var todos = await repository.findByPeriodo(startFilter, endFilter);

    if (todos.isEmpty) {
      listTodos = {dateFormat.format(DateTime.now()): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.datahora));
    }

    this.notifyListeners();
  }

  void checkOrUncheck(TodoModel todo) {
    todo.finalizado = !todo.finalizado;
    this.notifyListeners();
    repository.checkOrUncheckTodo(todo);
  }

  void filterFinalized() {
    listTodos = listTodos.map((key, value) {
      var todosFinalized = value.where((t) => t.finalizado).toList();
      return MapEntry(key, todosFinalized);
    });
    this.notifyListeners();
  }

  Future<void> findTodoBySelectedDay() async {
    var todos = await repository.findByPeriodo(daySelected, daySelected);
    if (todos.isEmpty) {
      listTodos = {dateFormat.format(daySelected): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.datahora));
    }
    this.notifyListeners();
  }

  void update() {
    if (selectTab == 1) {
      this.findAllForWeek();
    } else if (selectTab == 2) {
      this.findTodoBySelectedDay();
    }
  }

  Future<void> deleteTask(TodoModel todoModel) async {
    await repository.deleteTodo(todoModel);
    update();
  }
}
