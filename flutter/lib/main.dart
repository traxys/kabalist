import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

const String URL = "http://192.168.1.23:8000";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lists',
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
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
                    icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility),
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
                    body: '{"username": "$username", "password": "$password"}',
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
      required this.listDeleted})
      : super(key: key);

  final void Function() logout;
  final String token;
  final void Function(String, ListData) selectList;
  final void Function(String) listDeleted;

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

    return rsp;
  }

  void addList(String name) async {
    final response = await http.post(Uri.parse(URL + "/list"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
        },
        body: '{"name":"$name"}');

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
          body: '{"share_with": "$accountId", "readonly": $readonly}');

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
          final data;
          if (snapshots.hasData) {
            data = List.from(snapshots.data!.entries.map((entry) => ListTile(
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
            data.sort((a, b) => a.title.data!.compareTo(b.title.data!) as int);
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
            ],
          ));
        });
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

class _AuthListsState extends State<AuthLists> {
  ValueNotifier<ListInfo?> selectedList = ValueNotifier(null);
  AddedItemNotifier addedItem = AddedItemNotifier();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Function()? addItem;
  late String addItemName;
  late String? addItemAmount;

  @override
  void initState() {
    super.initState();
    loadLastUsed();
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
      amt = '"$amount"';
    }
    final response =
        await http.post(Uri.parse(URL + "/list/${selectedList.value!.id}"),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
            },
            body: '{"name": "$name", "amount": $amt}');

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
                                TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: "Name"),
                                  autofocus: true,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Name can't be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (String? name) async {
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
            setList(info);
            setLastUsed(info);
          }),
      body: Center(
        child: ListContent(
            list: selectedList, token: widget.token, addedItem: addedItem),
      ),
      floatingActionButton: floatingButton,
    );
  }
}

class ListContent extends StatefulWidget {
  ListContent({
    Key? key,
    required this.list,
    required this.token,
    required this.addedItem,
  }) : super(key: key);

  final ValueNotifier<ListInfo?> list;
  final AddedItemNotifier addedItem;
  final String token;

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
  late Future<OptionalContents> contents;
  bool render = false;
  Set<int> strickedItems = {};
  Set<int> deletedItems = {};
  Timer? timer;

  Future<OptionalContents> fetchContents() async {
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

  void strikeItems() async {
    ListInfo info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    setState(() {
      contents = fetchContents();
    });

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

    setState(() {
      contents = fetchContents();
      this.strickedItems.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    contents = fetchContents();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (shouldFetch) {
        setState(() {
          contents = fetchContents();
        });
      }
    });
    widget.list.addListener(() {
      setState(() {
        contents = fetchContents();
      });
    });
    widget.addedItem.addListener(() {
      setState(() {
        contents = fetchContents();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OptionalContents>(
        future: contents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.contents == null) {
              return SizedBox.shrink();
            }
            List<Widget> inList = [];
            List<Widget> striked = [];
            snapshot.data!.contents!.items.forEach((item) {
              if (!deletedItems.contains(item.id)) {
                if (strickedItems.contains(item.id)) {
                  striked.add(ListTile(
                      title: item.render(true),
                      onTap: () {
                        setState(() => strickedItems.remove(item.id));
                      }));
                } else {
                  inList.add(ListTile(
                      title: item.render(false),
                      onTap: () {
                        setState(() => strickedItems.add(item.id));
                      }));
                }
              }
            });
            final List<Widget> items;
            if (striked.isEmpty) {
              items = inList;
            } else {
              items = [...inList, Divider(), ...striked];
            }
            bool readOnly = snapshot.data!.contents!.readonly;
            if (!readOnly && strickedItems.isNotEmpty) {
              items.add(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, onPrimary: Colors.white),
                  onPressed: strikeItems,
                  child: const Text('Delete Striked Items')));
            }
            return ListView(padding: const EdgeInsets.all(8), children: [
              ListTile(
                  title: Text(
                      "List: ${widget.list.value!.name}${readOnly ? " (readonly)" : ""}")),
              Divider(),
              ...items
            ]);
          } else if (snapshot.hasError) {
            print("Err: ${snapshot.error}");
            if (snapshot.error is ApiError?) {
              return Text(
                  "An error occured while fetching the contents: ${(snapshot.error! as ApiError).errMsg()}",
                  style: TextStyle(color: Colors.red));
            } else {
              return Text("An unexpected error occured: ${snapshot.error}",
                  style: TextStyle(color: Colors.red));
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
