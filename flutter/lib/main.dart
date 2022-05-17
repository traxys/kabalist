import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

//const String URL = "http://192.168.1.23:8000";
const String URL = "https://list.familleboyer.net/";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KabaList',
      theme: ThemeData.dark(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.blue,
          ),
      home: Lists(title: 'Lists'),
    );
  }
}

class Lists extends StatefulWidget {
  Lists({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  String? token;
  VoidCallback? addItemCallback;

  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(widget.title),
    );

    if (token != null) {
      return AuthLists(
          token: token as String,
          appBar: appBar,
          logout: () async {
            setState(() => token = null);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove("token");
          });
    } else {
      return Scaffold(
        appBar: appBar,
        body: Center(
            child: Container(
                child: LoginForm(getToken: (String tk) async {
                  setState(() => token = tk);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("token", tk);
                }),
                margin: const EdgeInsets.all(20.0))),
      );
    }
  }
}

class ApiError implements Exception {
  ApiError({required this.code});

  final int code;

  String errMsg() {
    switch (code) {
      case 2:
        return "Account is unknown";
      default:
        return "unkown error: $code";
    }
  }
}

T parseAPIResponse<T>(
    http.Response response, T Function(Map<String, dynamic>?) parser) {
  String rspStr = utf8.decode(response.bodyBytes);
  Map<String, dynamic> rsp = jsonDecode(rspStr);
  if (rsp.containsKey("ok")) {
    return parser(rsp["ok"]);
  } else {
    Map<String, dynamic> err = rsp["err"];
    print("ApiError: ${err["description"]}");
    throw ApiError(code: err["code"]);
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.getToken}) : super(key: key);

  final void Function(String) getToken;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String? error;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final errorTxt;
    if (error == null) {
      errorTxt = <Widget>[];
    } else {
      errorTxt = <Widget>[Text(error!, style: TextStyle(color: Colors.red))];
    }

    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ...errorTxt,
              TextFormField(
                decoration: const InputDecoration(hintText: "Username"),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Username can't be empty";
                  }
                  return null;
                },
                onSaved: (String? nm) => setState(() => username = nm),
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        })),
                obscureText: !showPassword,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Password can't be empty";
                  }
                  return null;
                },
                onSaved: (String? pass) => setState(() => password = pass),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final response = await http.post(
                        Uri.parse(URL + "/login"),
                        headers: {
                          HttpHeaders.contentTypeHeader: "application/json"
                        },
                        body:
                            '{"username": ${jsonEncode(username)}, "password": ${jsonEncode(password)}}',
                      );
                      try {
                        final token = parseAPIResponse(
                            response, (fields) => fields!["token"]);
                        widget.getToken(token);
                      } on ApiError catch (err) {
                        setState(() {
                          error = err.errMsg();
                        });
                      }
                    }
                  },
                  child: const Text('Login'))
            ]));
  }
}

class ListDrawer extends StatefulWidget {
  ListDrawer(
      {Key? key,
      required this.logout,
      required this.token,
      required this.selectList,
      required this.listDeleted,
      required this.openSettings,
      required this.listSorter,
      required this.fetchedList})
      : super(key: key);

  final void Function() logout;
  final String token;
  final void Function(String, ListData) selectList;
  final void Function(String) listDeleted;
  final void Function(List<String>) fetchedList;
  final VoidCallback openSettings;
  final int Function(String, String) listSorter;

  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

enum ListStatus {
  Owned,
  SharedReadonly,
  SharedWritable,
}

class ListData {
  ListData({required this.id, required this.status});

  String id;
  ListStatus status;

  String fmtStatus() {
    switch (status) {
      case ListStatus.Owned:
        return "";
      case ListStatus.SharedReadonly:
        return " (readonly)";
      case ListStatus.SharedWritable:
        return " (shared)";
    }
  }
}

class _ListDrawerState extends State<ListDrawer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? shareError;

  late String shareName;
  bool shareReadonly = false;
  late Future<Map<String, ListData>> lists;

  Future<Map<String, ListData>> fetchLists() async {
    final response = await http.get(
      Uri.parse(URL + "/list"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
      },
    );

    final rsp = parseAPIResponse(
        response,
        (m) => m!["results"]
                .cast<String, Map<String, dynamic>>()
                .map((key, value) {
              final status;
              switch (value["status"]) {
                case "owned":
                  status = ListStatus.Owned;
                  break;
                case "shared_write":
                  status = ListStatus.SharedWritable;
                  break;
                case "shared_read":
                  status = ListStatus.SharedReadonly;
                  break;
                default:
                  throw "Unknown status: ${value["status"]}";
              }
              return MapEntry(key, ListData(id: value["id"], status: status));
            }).cast<String, ListData>());
    widget.fetchedList(List.from(rsp.keys));

    return rsp;
  }

  void addList(String name) async {
    final response = await http.post(Uri.parse(URL + "/list"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
        },
        body: '{"name":${jsonEncode(name)}}');

    parseAPIResponse(response, (m) => null);
    setState(() {
      lists = fetchLists();
    });
  }

  void deleteList(String id) async {
    final response = await http.delete(Uri.parse(URL + "/list/$id"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
    });

    parseAPIResponse(response, (m) => null);
    setState(() {
      lists = fetchLists();
    });
    widget.listDeleted(id);
  }

  void shareList(String listId, String shareWith, bool readonly) async {
    final accountRsp =
        await http.get(Uri.parse(URL + "/search/account/$shareWith"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
    });

    try {
      final accountId = parseAPIResponse(accountRsp, (m) => m!["id"] as String);

      final response = await http.put(Uri.parse(URL + "/share/$listId"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
          },
          body:
              '{"share_with": ${jsonEncode(accountId)}, "readonly": ${jsonEncode(readonly)}}');

      parseAPIResponse(response, (m) => null);
    } on ApiError catch (e) {
      setState(() {
        shareError = e.errMsg();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    lists = fetchLists();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, ListData>>(
        future: lists,
        builder: (context, snapshots) {
          final names;
          final data;
          if (snapshots.hasData) {
            names = List.from(snapshots.data!.entries);
            names.sort((a, b) => widget.listSorter(a.key, b.key));
            data = List.from(names.map((entry) => ListTile(
                title: Text("${entry.key}${entry.value.fmtStatus()}"),
                onTap: () {
                  widget.selectList(entry.key, entry.value);
                  Navigator.pop(context);
                },
                onLongPress: () async {
                  switch (await showDialog<ListAction>(
                      context: context,
                      builder: (BuildContext ctx) {
                        var actions = <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(ctx, ListAction.Delete);
                            },
                            child: Text("Delete List"),
                          )
                        ];
                        if (entry.value.status != ListStatus.SharedReadonly) {
                          actions.add(SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(ctx, ListAction.Share);
                            },
                            child: Text("Share List"),
                          ));
                        }
                        return SimpleDialog(
                            title: Text("List Actions"), children: actions);
                      })) {
                    case ListAction.Delete:
                      deleteList(entry.value.id);
                      break;
                    case ListAction.Share:
                      print("todo share");
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            final errorTxt;
                            if (shareError == null) {
                              errorTxt = <Widget>[];
                            } else {
                              errorTxt = <Widget>[
                                Text(shareError!,
                                    style: TextStyle(color: Colors.red))
                              ];
                            }
                            return AlertDialog(
                                title: Text("Share List"),
                                content: StatefulBuilder(builder:
                                    (BuildContext stCtx, StateSetter setState) {
                                  return Form(
                                      key: _formKey,
                                      child: Container(
                                          margin: EdgeInsets.all(10.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ...errorTxt,
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Share with"),
                                                  autofocus: true,
                                                  validator: (String? value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Name can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved:
                                                      (String? name) async {
                                                    shareName = name!;
                                                  },
                                                ),
                                                CheckboxListTile(
                                                    title: Text('Readonly'),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        shareReadonly = value!;
                                                      });
                                                    },
                                                    value: shareReadonly),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _formKey.currentState!
                                                            .save();
                                                        shareList(
                                                            entry.value.id,
                                                            shareName,
                                                            shareReadonly);
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: const Text('Share'))
                                              ])));
                                }));
                          });
                      break;
                    case null:
                      // Nothing
                      break;
                  }
                })));
          } else if (snapshots.hasError) {
            final error;
            if (snapshots.error is ApiError) {
              error =
                  "An error occured: ${(snapshots.error as ApiError).errMsg()}";
            } else {
              print((snapshots.error as TypeError).stackTrace);
              error = "An unexpected error occured: ${snapshots.error}";
            }
            data = <Widget>[
              ListTile(title: Text(error)),
            ];
          } else {
            data = <Widget>[
              ListTile(leading: CircularProgressIndicator()),
            ];
          }

          return Drawer(
              child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Lists',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
              ...data,
              const Divider(),
              ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Add List'),
                  onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text("Add List"),
                                content: Form(
                                    key: _formKey,
                                    child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "Name"),
                                                autofocus: true,
                                                validator: (String? value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Name can't be empty";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String? name) async {
                                                  addList(name!);
                                                },
                                              ),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState!
                                                          .save();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text('Add'))
                                            ]))))),
                      }),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: widget.logout),
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    widget.openSettings();
                    Navigator.of(context).pop();
                  }),
            ],
          ));
        });
  }
}

class Settings extends StatefulWidget {
  const Settings(
      {Key? key, required this.saveSettings, required this.initialValues})
      : super(key: key);

  final void Function(SettingsValue) saveSettings;
  final SettingsValue initialValues;

  @override
  State<Settings> createState() => _SettingsState();
}

enum SorterKind {
  ALPHABETICAL,
  CUSTOM,
}

class _SettingsState extends State<Settings> {
  late double? listExtent = widget.initialValues.listExtent;
  late SorterKind sorterKind = widget.initialValues.listSorter.kind;
  late List<String> customOrder = widget.initialValues.listSorter.customOrder;

  @override
  Widget build(BuildContext context) {
    print(customOrder);
    List<Widget> extentChooser = [];
    if (listExtent != null) {
      extentChooser = [
        Slider(
            value: listExtent!,
            min: 35,
            max: 60,
            divisions: 25,
            label: listExtent!.round().toString(),
            onChanged: (double value) {
              setState(() {
                listExtent = value;
              });
            })
      ];
    }
    List<Widget> customChooser = [];
    if (sorterKind == SorterKind.CUSTOM) {
      customChooser = [
        ExpansionTile(
            title: Text("Custom Order",
                style: TextStyle(fontWeight: FontWeight.bold)),
            children: <Widget>[
              Container(
                  height: 300,
                  child: ReorderableListView(
                      children: List.from(customOrder.map((name) =>
                          ListTile(title: Text(name), key: Key(name)))),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final String item = customOrder.removeAt(oldIndex);
                          customOrder.insert(newIndex, item);
                        });
                      }))
            ]),
      ];
      /* customChooser
          .addAll(customOrder.map((name) => ListTile(title: Text(name)))); */
    }

    return Column(children: <Widget>[
      CheckboxListTile(
          title: Text("Custom Spacing"),
          value: listExtent != null,
          onChanged: (bool? value) {
            if (value == false) {
              setState(() {
                listExtent = null;
              });
            } else if (value == true) {
              setState(() {
                listExtent = 50;
              });
            }
          }),
      ...extentChooser,
      ListTile(title: Text("Item Sorter")),
      RadioListTile<SorterKind>(
          title: const Text("Alphabetical"),
          groupValue: sorterKind,
          value: SorterKind.ALPHABETICAL,
          onChanged: (val) {
            setState(() {
              sorterKind = val!;
            });
          }),
      RadioListTile<SorterKind>(
          title: const Text("Custom"),
          groupValue: sorterKind,
          value: SorterKind.CUSTOM,
          onChanged: (val) {
            setState(() {
              sorterKind = val!;
            });
          }),
      ...customChooser,
      ElevatedButton(
          onPressed: () {
            widget.saveSettings(SettingsValue(
                listExtent: listExtent,
                listSorter:
                    ListSorter(kind: sorterKind, customOrder: customOrder)));
          },
          child: const Text('Save'))
    ]);
  }
}

class AuthLists extends StatefulWidget {
  AuthLists(
      {Key? key,
      required this.token,
      required this.appBar,
      required this.logout})
      : super(key: key);

  final String token;
  final AppBar appBar;
  final void Function() logout;

  @override
  State<AuthLists> createState() => _AuthListsState();
}

enum ListAction { Delete, Share }

class ListInfo {
  ListInfo({required this.id, required this.name, required this.status});

  final String id;
  final String name;
  final ListStatus status;
}

class AddedItemNotifier extends ChangeNotifier {
  AddedItemNotifier() : super();

  void addedItem() {
    notifyListeners();
  }
}

class ListSorter {
  ListSorter({required this.kind, required this.customOrder});

  final SorterKind kind;
  final List<String> customOrder;

  int Function(String, String) sorter() {
    switch (kind) {
      case SorterKind.ALPHABETICAL:
        return Comparable.compare;
      case SorterKind.CUSTOM:
        return (String a, String b) {
          if (!customOrder.contains(a) || !customOrder.contains(b)) {
            return a.compareTo(b);
          }
          final int idA = customOrder.indexOf(a);
          final int idB = customOrder.indexOf(b);
          return idA.compareTo(idB);
        };
    }
  }
}

class SettingsValue {
  SettingsValue({this.listExtent, required this.listSorter});

  final double? listExtent;
  final ListSorter listSorter;

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (listExtent != null) {
      prefs.setDouble("listExtent", listExtent!);
    } else {
      prefs.remove("listExtent");
    }
    prefs.setStringList("customOrder", listSorter.customOrder);
    prefs.setBool("isCustom", listSorter.kind == SorterKind.CUSTOM);
  }

  static Future<SettingsValue> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? listExtent;
    if (prefs.containsKey("listExtent")) {
      listExtent = prefs.getDouble("listExtent");
    } else {
      listExtent = null;
    }

    final SorterKind kind;
    if (prefs.containsKey("isCustom")) {
      if (prefs.getBool("isCustom")!) {
        kind = SorterKind.CUSTOM;
      } else {
        kind = SorterKind.ALPHABETICAL;
      }
    } else {
      kind = SorterKind.ALPHABETICAL;
    }

    final List<String> customOrder;
    if (prefs.containsKey("customOrder")) {
      final order = prefs.getStringList("customOrder");
      if (order != null) {
        customOrder = order;
      } else {
        customOrder = [];
      }
    } else {
      customOrder = [];
    }

    return SettingsValue(
        listExtent: listExtent,
        listSorter: ListSorter(kind: kind, customOrder: customOrder));
  }

  SettingsValue merge(List<String> lists) {
    List<String> newList = List.from(listSorter.customOrder);
    newList.addAll(lists.where((val) => !listSorter.customOrder.contains(val)));
    return SettingsValue(
        listExtent: listExtent,
        listSorter: ListSorter(kind: listSorter.kind, customOrder: newList));
  }
}

class _AuthListsState extends State<AuthLists> {
  ValueNotifier<ListInfo?> selectedList = ValueNotifier(null);
  AddedItemNotifier addedItem = AddedItemNotifier();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Function()? addItem;
  late String addItemName;
  late String? addItemAmount;
  SettingsValue settingsValues = SettingsValue(
      listSorter: ListSorter(kind: SorterKind.ALPHABETICAL, customOrder: []));
  bool settings = false;

  @override
  void initState() {
    super.initState();
    loadLastUsed();
    loadSettings();
  }

  void loadSettings() async {
    final s = await SettingsValue.load();
    setState(() {
      settingsValues = s;
    });
  }

  Future<ListInfo> getLastUsedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> lastUsed =
        json.decode(prefs.getString("lastUsed")!).cast<String, String>();
    final status = lastUsed["status"]!;
    return ListInfo(
        name: lastUsed["name"]!,
        status: ListStatus.values.firstWhere((e) => e.toString() == status),
        id: lastUsed["id"]!);
  }

  void setLastUsed(ListInfo info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lastUsed",
        '{"id":"${info.id}","status":"${info.status.toString()}","name":"${info.name}"}');
  }

  void clearLastUsed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("lastUsed");
  }

  void loadLastUsed() async {
    final lastUsed = await getLastUsedList();
    setList(lastUsed);
  }

  void doAddItem(String name, String? amount) async {
    final amt;
    if (amount == null || amount.isEmpty) {
      amt = null;
    } else {
      amt = amount;
    }
    final response = await http.post(
        Uri.parse(URL + "/list/${selectedList.value!.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
        },
        body: '{"name": ${jsonEncode(name)}, "amount": ${jsonEncode(amt)}}');

    parseAPIResponse(response, (m) => null);
    addedItem.addedItem();
  }

  void setList(ListInfo? list) {
    if (list == null) {
      setState(() {
        selectedList.value = null;
        addItem = null;
      });
    } else {
      final addItemFn;
      if (list.status == ListStatus.SharedReadonly) {
        addItemFn = null;
      } else {
        addItemFn = () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text("Add Item"),
                  content: Form(
                      key: _formKey,
                      child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ItemInput(
                                  listId: selectedList.value!.id,
                                  token: widget.token,
                                  update: (String? name) {
                                    addItemName = name!;
                                  },
                                ),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: "Amount"),
                                  onSaved: (String? amount) async {
                                    addItemAmount = amount;
                                  },
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        doAddItem(addItemName, addItemAmount);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Add'))
                              ])))));
        };
      }
      setState(() {
        selectedList.value = list;
        addItem = addItemFn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final floatingButton;
    if (addItem == null) {
      floatingButton = null;
    } else {
      floatingButton =
          FloatingActionButton(onPressed: addItem, child: Icon(Icons.add));
    }
    final Widget child;
    if (!settings) {
      child = ListContent(
          list: selectedList,
          token: widget.token,
          addedItem: addedItem,
          listExtent: settingsValues.listExtent);
    } else {
      child = Settings(
          saveSettings: (newValues) {
            newValues.save();
            setState(() {
              settings = false;
              settingsValues = newValues;
            });
          },
          initialValues: settingsValues);
    }

    return Scaffold(
      appBar: widget.appBar,
      drawer: ListDrawer(
          logout: widget.logout,
          token: widget.token,
          listDeleted: (id) async {
            if (selectedList.value?.id == id) {
              setList(null);
            }
            final lastUsed = await getLastUsedList();
            if (lastUsed.id == id) {
              clearLastUsed();
            }
          },
          selectList: (name, data) async {
            final info = ListInfo(id: data.id, name: name, status: data.status);
            setState(() {
              settings = false;
            });
            setList(info);
            setLastUsed(info);
          },
          openSettings: () {
            setState(() {
              settings = true;
            });
          },
          listSorter: settingsValues.listSorter.sorter(),
          fetchedList: (lists) {
            final SettingsValue newSettings = settingsValues.merge(lists);
            setState(() {
              settingsValues = newSettings;
            });
          }),
      body: Center(child: child),
      floatingActionButton: floatingButton,
    );
  }
}

class ItemInput extends StatelessWidget {
  ItemInput({
    Key? key,
    required listId,
    required token,
    required this.update,
  })  : history = fetchHistory(listId, token),
        super(key: key);

  final Future<List<String>> history;
  final void Function(String?) update;

  // TODO: Maybe not fetch everything, but use the query to narrow instead of doing it client side
  static Future<List<String>> fetchHistory(String listId, String token) async {
    final response =
        await http.get(Uri.parse(URL + "/history/$listId?search"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    return parseAPIResponse(response, (m) {
      List<String> values = (m!["matches"] as List<dynamic>)
          .cast<String>()
          .map((String value) => value.toLowerCase())
          .toList();
      values.sort();
      return values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: history,
        builder: (context, snapshot) {
          print(snapshot.error);
          if (!snapshot.hasData) {
            return Autocomplete<String>(
              onSelected: update,
              optionsBuilder: (TextEditingValue _textEditingValue) {
                return const Iterable<String>.empty();
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                fieldTextEditingController.addListener(() {
                  update(fieldTextEditingController.text);
                });
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(hintText: "Name"),
                  autofocus: true,
                );
              },
            );
          } else {
            return Autocomplete<String>(
              onSelected: update,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                List<String> data = snapshot.data as List<String>;
                return data.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                fieldTextEditingController.addListener(() {
                  update(fieldTextEditingController.text);
                });
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(hintText: "Name"),
                  autofocus: true,
                );
              },
            );
          }
        });
  }
}

class ListContent extends StatefulWidget {
  ListContent({
    Key? key,
    required this.list,
    required this.token,
    required this.addedItem,
    required this.listExtent,
  }) : super(key: key);

  final ValueNotifier<ListInfo?> list;
  final AddedItemNotifier addedItem;
  final String token;
  final double? listExtent;

  @override
  State<ListContent> createState() => _ListContentState();
}

class ListItem {
  ListItem({required this.name, this.amount, required this.id});

  int id;
  String name;
  String? amount;

  Widget render(bool stricken) {
    return Text("$name ${amount == null ? '' : '($amount)'}",
        style: TextStyle(
            decoration: stricken ? TextDecoration.lineThrough : null));
  }
}

class Contents {
  Contents({required this.items, required this.readonly});

  bool readonly;
  List<ListItem> items;
}

class OptionalContents {
  OptionalContents({this.contents});

  Contents? contents;
}

class _ListContentState extends State<ListContent> with WidgetsBindingObserver {
  OptionalContents contents = OptionalContents(contents: null);
  bool render = false;
  Set<int> strickedItems = {};
  Set<int> deletedItems = {};
  Timer? timer;
  String? editError;
  String? editName;
  String? editAmount;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late VoidCallback fetchContentsCallback = () {
    this.updateContents();
  };

  Future<OptionalContents> fetchContentsFailable() async {
    ListInfo info;
    if (widget.list.value == null) {
      return OptionalContents(contents: null);
    } else {
      info = widget.list.value!;
    }

    final response =
        await http.get(Uri.parse(URL + "/list/${info.id}"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
    });

    final contents = parseAPIResponse(
        response,
        (m) => Contents(
            readonly: m!["readonly"],
            items: List.from(m["items"].map((item) => ListItem(
                name: item["name"], amount: item["amount"], id: item["id"])))));

    setState(() {
      strickedItems.retainAll(contents.items.map((item) => item.id));
      deletedItems.clear();
    });

    return OptionalContents(contents: contents);
  }

  void updateContents() async {
    try {
      final newContents = await this.fetchContentsFailable();
      setState(() {
        contents = newContents;
      });
    } catch (e) {
      final widget;
      if (e is ApiError) {
        widget = Text(
            "An error occured while fetching the contents: ${e.errMsg()}",
            style: TextStyle(color: Colors.red));
      } else {
        widget = Text("An unexpected error occured: $e",
            style: TextStyle(color: Colors.red));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: widget,
        duration: const Duration(milliseconds: 4000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 280.0,
      ));
    }
  }

  /* Future<OptionalContents> fetchContents() async {
  	try {
		return this.fetchContentsFailable();
	} catch (e) {
	}
  } */

  void strikeItems() async {
    ListInfo info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    updateContents();

    this.strickedItems.forEach((itemId) async {
      final response = await http
          .delete(Uri.parse(URL + "/list/${info.id}/$itemId"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
      });

      parseAPIResponse(response, (m) => null);
      setState(() {
        deletedItems.add(itemId);
      });
    });

    updateContents();
    setState(() {
      this.strickedItems.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    updateContents();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (shouldFetch) {
        updateContents();
      }
    });
    widget.list.addListener(fetchContentsCallback);
    widget.addedItem.addListener(fetchContentsCallback);
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.list.removeListener(fetchContentsCallback);
    widget.addedItem.removeListener(fetchContentsCallback);
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  bool shouldFetch = true;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          shouldFetch = true;
        });
        break;
      default:
        setState(() {
          shouldFetch = false;
        });
        break;
    }
  }

  void doEdit(String? editName, String? editAmount, int itemId) async {
    ListInfo info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    final jsonName;
    if (editName == null || editName.isEmpty) {
      jsonName = null;
    } else {
      jsonName = editName;
    }

    final jsonAmount;
    if (editAmount == null || editAmount.isEmpty) {
      jsonAmount = null;
    } else {
      jsonAmount = editAmount;
    }

    final response = await http.patch(
        Uri.parse(URL + "/list/${info.id}/$itemId"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
        },
        body:
            '{"name": ${jsonEncode(jsonName)}, "amount": ${jsonEncode(jsonAmount)}}');

    parseAPIResponse(response, (m) => null);

    updateContents();
  }

  void editItem(ListItem item) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final errorTxt;
          if (editError == null) {
            errorTxt = <Widget>[];
          } else {
            errorTxt = <Widget>[
              Text(editError!, style: TextStyle(color: Colors.red))
            ];
          }
          return AlertDialog(
              title: Text("Edit Item"),
              content: StatefulBuilder(
                  builder: (BuildContext stCtx, StateSetter setState) {
                return Form(
                    key: _formKey,
                    child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...errorTxt,
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: "New Name"),
                                initialValue: item.name,
                                onSaved: (String? name) async {
                                  editName = name;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "New Amount"),
                                initialValue: item.amount,
                                onSaved: (String? amount) async {
                                  editAmount = amount;
                                },
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      doEdit(editName, editAmount, item.id);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Edit'))
                            ])));
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> inList = [];
    List<Widget> striked = [];
    contents.contents?.items.forEach((item) {
      if (!deletedItems.contains(item.id)) {
        if (strickedItems.contains(item.id)) {
          striked.add(ListTile(
              title: item.render(true),
              onTap: () {
                setState(() => strickedItems.remove(item.id));
              },
              onLongPress: () => editItem(item)));
        } else {
          inList.add(ListTile(
              title: item.render(false),
              onTap: () {
                setState(() => strickedItems.add(item.id));
              },
              onLongPress: () => editItem(item)));
        }
      }
    });
    final List<Widget> items;
    if (striked.isEmpty) {
      items = inList;
    } else {
      items = [...inList, Divider(), ...striked];
    }
    bool readOnly = contents.contents?.readonly ?? true;
    if (!readOnly && strickedItems.isNotEmpty) {
      items.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.red, onPrimary: Colors.white),
          onPressed: strikeItems,
          child: const Text('Delete Striked Items')));
    }
    return ListView(
        padding: const EdgeInsets.all(8),
        itemExtent: widget.listExtent,
        children: [
          ListTile(
              title: Text(
                  "List: ${widget.list.value?.name ?? "Unkown"}${readOnly ? " (readonly)" : ""}")),
          Divider(),
          ...items
        ]);
  }
}
