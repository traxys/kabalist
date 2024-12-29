import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoint.dart';
import 'package:kabalist_client/api.dart' as kb;
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

kb.ListApi listApiClient(String token) {
  final auth = kb.HttpBearerAuth();
  auth.accessToken = token;
  return kb.ListApi(kb.ApiClient(authentication: auth, basePath: ENDPOINT));
}

kb.AccountApi accountApiClient(String? token) {
  var auth;
  if (token != null) {
    auth = kb.HttpBearerAuth();
    auth.accessToken = token;
  }
  return kb.AccountApi(kb.ApiClient(basePath: ENDPOINT, authentication: auth));
}

kb.DefaultApi miscApiClient(String token) {
  final auth = kb.HttpBearerAuth();
  auth.accessToken = token;
  return kb.DefaultApi(kb.ApiClient(authentication: auth, basePath: ENDPOINT));
}

kb.ShareApi shareApiClient(String token) {
  final auth = kb.HttpBearerAuth();
  auth.accessToken = token;
  return kb.ShareApi(kb.ApiClient(authentication: auth, basePath: ENDPOINT));
}

kb.PantryApi pantryApiClient(String token) {
  final auth = kb.HttpBearerAuth();
  auth.accessToken = token;
  return kb.PantryApi(kb.ApiClient(authentication: auth, basePath: ENDPOINT));
}

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

                  final instance = accountApiClient(null);
                  final loginRequest =
                      kb.LoginRequest(username: username!, password: password!);
                  try {
                    final response = await instance.login(loginRequest);
                    widget.getToken(response!.ok.token);
                  } on kb.ApiException catch (err) {
                    setState(() {
                      error = err.toString();
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
  final void Function(String, kb.ListInfo) selectList;
  final void Function(String) listDeleted;
  final void Function(List<String>) fetchedList;
  final VoidCallback openSettings;
  final int Function(String, String) listSorter;

  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

String fmtStatus(kb.ListStatus status, String owned) {
  switch (status) {
    case kb.ListStatus.owned:
      return "";
    case kb.ListStatus.sharedRead:
      return " (readonly from $owned)";
    case kb.ListStatus.sharedWrite:
      return " (shared by $owned)";
    default:
      return "";
  }
}

class ExtendedListInfo {
  ExtendedListInfo({required this.info, required this.owner});

  final kb.ListInfo info;
  final String owner;
}

class _ListDrawerState extends State<ListDrawer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? shareError;

  late String shareName;
  bool shareReadonly = false;
  late Future<Map<String, ExtendedListInfo>> lists;

  Future<Map<String, ExtendedListInfo>> fetchLists() async {
    final instance = listApiClient(widget.token);
    final rsp = (await instance.listLists())!.ok.results;

    widget.fetchedList(List.from(rsp.keys));

    final accountInfo = accountApiClient(widget.token);
    final owners = {};
    Map<String, ExtendedListInfo> resolvedRsp = {};
    for (final entry in rsp.entries) {
      var ownerInfo = owners[entry.value.owner];
      if (ownerInfo == null) {
        try {
          ownerInfo = (await accountInfo.getAccountName(entry.value.owner))
              ?.ok
              .username;
        } on kb.ApiException catch (e) {
          /* Unknown Account, Should not happen but let's be conservative */
          if (e.code == 7) {
            ownerInfo = "<unknown>";
          } else {
            throw e;
          }
        }
      }
      resolvedRsp[entry.key] =
          ExtendedListInfo(owner: ownerInfo, info: entry.value);
    }

    return resolvedRsp;
  }

  void addList(String name) async {
    final instance = listApiClient(widget.token);
    final request = kb.CreateListRequest(name: name);

    await instance.createList(request);

    setState(() {
      lists = fetchLists();
    });
  }

  void deleteList(String id) async {
    final instance = listApiClient(widget.token);

    await instance.deleteList(id);

    setState(() {
      lists = fetchLists();
    });
    widget.listDeleted(id);
  }

  void shareList(String listId, String shareWith, bool readonly) async {
    final miscInstance = miscApiClient(widget.token);

    try {
      final account = (await miscInstance.searchAccount(shareWith))!.ok.id;

      final shareInstance = shareApiClient(widget.token);

      final request =
          kb.ShareListRequest(shareWith: account, readonly: readonly);
      await shareInstance.shareList(listId, request);
    } on kb.ApiException catch (e) {
      setState(() {
        shareError = e.toString();
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
    return FutureBuilder<Map<String, ExtendedListInfo>>(
        future: lists,
        builder: (context, snapshots) {
          final names;
          final data;
          if (snapshots.hasData) {
            names = List.from(snapshots.data!.entries);
            names.sort((a, b) => widget.listSorter(a.key, b.key));
            data = List.from(names.map((entry) => ListTile(
                title: Text(
                    "${entry.value.info.name}${fmtStatus(entry.value.info.status, entry.value.owner)}"),
                onTap: () {
                  widget.selectList(entry.key, entry.value.info);
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
                        if (entry.value.info.status != kb.ListStatus.sharedRead) {
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
                      deleteList(entry.key);
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
                                                            entry.key,
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
            if (snapshots.error is kb.ApiException) {
              error =
                  "An error occured: ${(snapshots.error as kb.ApiException).toString()}";
            } else if (snapshots.error is Error) {
              print((snapshots.error as Error).stackTrace);
              error = "An unexpected error occured: ${snapshots.error}";
            } else {
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

class ListDesc {
  ListDesc({required this.id, required this.name, required this.status});

  final String id;
  final String name;
  final kb.ListStatus status;
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
  ValueNotifier<ListDesc?> selectedList = ValueNotifier(null);
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

  Future<ListDesc> getLastUsedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> lastUsed =
        json.decode(prefs.getString("lastUsed")!).cast<String, String>();
    final status = lastUsed["status"]!;
    return ListDesc(
        name: lastUsed["name"]!,
        status: kb.ListStatus.values.firstWhere((e) => e.toString() == status),
        id: lastUsed["id"]!);
  }

  void setLastUsed(ListDesc info) async {
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

  void setList(ListDesc? list) {
    setState(() {
      selectedList.value = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (!settings) {
      child = SelectedList(
          list: selectedList,
          token: widget.token,
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
          selectList: (id, data) async {
            final info = ListDesc(id: id, name: data.name, status: data.status);
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
    final instance = miscApiClient(token);

    final matches =
        (await instance.historySearch(listId, search: null))!.ok.matches;

    return matches.map((String value) => value.toLowerCase()).toList();
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
                return ([textEditingValue.text])
                    .followedBy(data.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                }));
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

class SelectedList extends StatelessWidget {
  SelectedList({
    Key? key,
    required this.list,
    required this.token,
    required this.listExtent,
  }) : super(key: key);

  final ValueNotifier<ListDesc?> list;
  final String token;
  final double? listExtent;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text(list.value?.name ?? "Unknown"),
                bottom: TabBar(tabs: <Widget>[
                  Tab(icon: Icon(Icons.assignment)),
                  Tab(icon: Icon(Icons.home_filled))
                ])),
            body: TabBarView(children: <Widget>[
              ListContent(
                  list: this.list,
                  token: this.token,
                  listExtent: this.listExtent),
              PantryContent(
                  list: this.list,
                  token: this.token,
                  listExtent: this.listExtent),
            ])));
  }
}

class PantryContent extends StatefulWidget {
  PantryContent({
    Key? key,
    required this.list,
    required this.token,
    required this.listExtent,
  }) : super(key: key);

  final ValueNotifier<ListDesc?> list;
  final String token;
  final double? listExtent;

  @override
  State<PantryContent> createState() => _PantryContentState();
}

class PantryContents {
  PantryContents({required this.items, required this.readonly});

  bool readonly;
  List<kb.PantryItem> items;
}

class OptionalPantryContents {
  OptionalPantryContents({this.contents});

  PantryContents? contents;
}

class _PantryContentState extends State<PantryContent>
    with WidgetsBindingObserver {
  OptionalPantryContents contents = OptionalPantryContents(contents: null);
  Timer? timer;
  String? editError;
  String addItemName = "";
  int? editTarget;
  int? editAmount;
  int addItemTarget = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late VoidCallback fetchContentsCallback = () {
    this.updateContents();
  };

  Future<OptionalPantryContents> fetchContentsFailable() async {
    ListDesc info;
    if (widget.list.value == null) {
      return OptionalPantryContents(contents: null);
    } else {
      info = widget.list.value!;
    }

    final listInstance = listApiClient(widget.token);
    final listResponse = (await listInstance.readList(info.id))!.ok;

    final pantryInstance = pantryApiClient(widget.token);
    final pantryResponse = (await pantryInstance.getPantry(info.id))!.ok;

    return OptionalPantryContents(
        contents: PantryContents(
      items: pantryResponse.items,
      readonly: listResponse.readonly,
    ));
  }

  void updateContents() async {
    try {
      final newContents = await this.fetchContentsFailable();
      setState(() {
        contents = newContents;
      });
    } catch (e) {
      final widget;
      if (e is kb.ApiException) {
        widget = Text(
            "An error occured while fetching the contents: ${e.toString()}",
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateContents();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (shouldFetch) {
        updateContents();
      }
    });
    widget.list.addListener(fetchContentsCallback);
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.list.removeListener(fetchContentsCallback);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void doEdit(int? amount, int? target, int itemId) async {
    ListDesc info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    final instance = pantryApiClient(widget.token);
    final request = kb.EditPantryItemRequest(target: target, amount: amount);
    await instance.setPantryItem(info.id, itemId, request);

    updateContents();
  }

  void decrementItem(kb.PantryItem item) async {
    ListDesc info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    final instance = pantryApiClient(widget.token);
    final request =
        kb.EditPantryItemRequest(target: null, amount: item.amount - 1);
    await instance.setPantryItem(info.id, item.id, request);

    updateContents();
  }

  void doDelete(int itemId) async {
    ListDesc info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    final instance = pantryApiClient(widget.token);
    await instance.deletePantryItem(info.id, itemId);

    updateContents();
  }

  void editItem(kb.PantryItem item) {
    setState(() {
      editTarget = item.target;
      editAmount = item.amount;
    });
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
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          ...errorTxt,
                          Text("Amount"),
                          NumberPicker(
                            value: editAmount ?? 0,
                            maxValue: 1 << 31,
                            minValue: 0,
                            onChanged: (value) =>
                                setState(() => editAmount = value),
                          ),
                          Text("Target"),
                          NumberPicker(
                            value: editTarget ?? 0,
                            maxValue: 1 << 31,
                            minValue: 0,
                            onChanged: (value) =>
                                setState(() => editTarget = value),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white),
                                    onPressed: () async {
                                      doDelete(item.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete')),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        doEdit(editAmount, editTarget, item.id);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Edit'))
                              ])
                        ])));
              }));
        });
  }

  void refillList() async {
    ListDesc info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }
    final instance = pantryApiClient(widget.token);
    await instance.refillPantry(info.id);
  }

  void doAddItem(String listId, String name, int target) async {
    final instance = pantryApiClient(widget.token);
    final request = kb.AddToPantryRequest(name: name, target: target);

    await instance.addToPantry(listId, request);

    updateContents();
  }

  void addItem(String listId) {
    setState(() => addItemTarget = 0);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text("Add Pantry Item"),
            content: StatefulBuilder(
                builder: (BuildContext stCtx, StateSetter setState) => Form(
                    key: _formKey,
                    child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: "Name"),
                                onSaved: (String? name) async {
                                  addItemName = name!;
                                },
                              ),
                              NumberPicker(
                                value: addItemTarget,
                                maxValue: 1 << 31,
                                minValue: 0,
                                onChanged: (value) =>
                                    setState(() => addItemTarget = value),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      doAddItem(
                                          listId, addItemName, addItemTarget);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Add'))
                            ]))))));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    contents.contents?.items.sort((a, b) => a.name.compareTo(b.name));
    contents.contents?.items.forEach((item) {
      items.add(ListTile(
          title: Text("${item.name} (${item.amount}/${item.target})"),
          onTap: () => decrementItem(item),
          onLongPress: () => editItem(item)));
    });
    bool readOnly = contents.contents?.readonly ?? true;

    if (!readOnly) {
      items.add(ElevatedButton(
          onPressed: refillList, child: const Text('Refill From Pantry')));
    }

    VoidCallback? addItemFn;
    if (widget.list.value != null && !readOnly) {
      addItemFn = () => addItem(widget.list.value!.id);
    }

    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.all(8),
          itemExtent: widget.listExtent,
          children: items),
      floatingActionButton:
          FloatingActionButton(onPressed: addItemFn, child: Icon(Icons.add)),
    );
  }
}

class ListContent extends StatefulWidget {
  ListContent({
    Key? key,
    required this.list,
    required this.token,
    required this.listExtent,
  }) : super(key: key);

  final ValueNotifier<ListDesc?> list;
  final String token;
  final double? listExtent;

  @override
  State<ListContent> createState() => _ListContentState();
}

Widget renderItem(kb.Item item, bool stricken) {
  return Text("${item.name} ${item.amount == null ? '' : '(${item.amount})'}",
      style:
          TextStyle(decoration: stricken ? TextDecoration.lineThrough : null));
}

class Contents {
  Contents({required this.items, required this.readonly});

  bool readonly;
  List<kb.Item> items;
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
    ListDesc info;
    if (widget.list.value == null) {
      return OptionalContents(contents: null);
    } else {
      info = widget.list.value!;
    }

    final instance = listApiClient(widget.token);
    final response = (await instance.readList(info.id))!.ok;

    setState(() {
      strickedItems.retainAll(response.items.map((item) => item.id));
      deletedItems.clear();
    });

    return OptionalContents(
        contents: Contents(
      items: response.items,
      readonly: response.readonly,
    ));
  }

  void updateContents() async {
    try {
      final newContents = await this.fetchContentsFailable();
      setState(() {
        contents = newContents;
      });
    } catch (e) {
      final widget;
      if (e is kb.ApiException) {
        widget = Text(
            "An error occured while fetching the contents: ${e.toString()}",
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
    ListDesc info;
    if (widget.list.value == null) {
      return;
    } else {
      info = widget.list.value!;
    }

    updateContents();

    this.strickedItems.forEach((itemId) async {
      final instance = listApiClient(widget.token);
      await instance.deleteItem(info.id, itemId);

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
    WidgetsBinding.instance.addObserver(this);
    updateContents();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (shouldFetch) {
        updateContents();
      }
    });
    widget.list.addListener(fetchContentsCallback);
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.list.removeListener(fetchContentsCallback);
    WidgetsBinding.instance.removeObserver(this);
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
    ListDesc info;
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

    final instance = listApiClient(widget.token);
    final request = kb.UpdateItemRequest(name: jsonName, amount: jsonAmount);
    await instance.updateItem(info.id, itemId, request);

    updateContents();
  }

  void editItem(kb.Item item) {
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

  void doAddItem(String listId, String name, String? amount) async {
    final amt;
    if (amount == null || amount.isEmpty) {
      amt = null;
    } else {
      amt = amount;
    }
    final instance = listApiClient(widget.token);
    final request = kb.AddToListRequest(name: name, amount: amt);

    await instance.addList(listId, request);

    updateContents();
  }

  void addItem(String listId) {
    String addItemName = "";
    String? addItemAmount;

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
                            listId: listId,
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
                                  doAddItem(listId, addItemName, addItemAmount);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Add'))
                        ])))));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> inList = [];
    List<Widget> striked = [];
    contents.contents?.items.forEach((item) {
      if (!deletedItems.contains(item.id)) {
        if (strickedItems.contains(item.id)) {
          striked.add(ListTile(
              title: renderItem(item, true),
              onTap: () {
                setState(() => strickedItems.remove(item.id));
              },
              onLongPress: () => editItem(item)));
        } else {
          inList.add(ListTile(
              title: renderItem(item, false),
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
              backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: strikeItems,
          child: const Text('Delete Striked Items')));
    }

    VoidCallback? addItemCallback;
    if (widget.list.value != null && !readOnly) {
      addItemCallback = () => addItem(widget.list.value!.id);
    }

    return Scaffold(
        body: ListView(
            padding: const EdgeInsets.all(8),
            itemExtent: widget.listExtent,
            children: items),
        floatingActionButton: FloatingActionButton(
            onPressed: addItemCallback, child: Icon(Icons.add)));
  }
}
