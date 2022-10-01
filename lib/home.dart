import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_db_blog/hive_data_store.dart';
import 'package:flutter_hive_db_blog/user_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nameEditingCtr = TextEditingController();
  TextEditingController hobbyEditingCtr = TextEditingController();
  TextEditingController descriptionEditingCtr = TextEditingController();

  final HiveDataStore dataStore = HiveDataStore();
  ValueNotifier<bool> isUpdate = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("Flutter Hive Database"),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveDataStore.box.listenable(),
          builder: (context, Box box, widget) {
          return SafeArea(
              child: box.length > 0 ?
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.length,
                  itemBuilder: (BuildContext context, int index) {
                    var userData = box.getAt(index);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          border: Border.all(color: Colors.blue.shade900),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Text(userData.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                      ),
                                      VerticalDivider(color: Colors.blue.shade900,thickness: 2,),
                                      Text(userData.description, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                RichText(text: TextSpan(text: 'Hobby: ', style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                                    children: <TextSpan>[
                                      TextSpan(text: userData.hobby, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      isUpdate.value = true;
                                      nameEditingCtr.text = userData.name;
                                      hobbyEditingCtr.text = userData.hobby;
                                      descriptionEditingCtr.text = userData.description;
                                      _showDialog(context,index);
                                    },
                                    child: Icon(Icons.edit, size: 30, color: Colors.blue.shade900,),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: ()async{
                                              await showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Are you sure you want to delete ${userData.name}?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(Colors.blue.shade900),
                                                        elevation: MaterialStateProperty.all(3),
                                                        shadowColor: MaterialStateProperty.all(Colors.blue.shade900), //Defines shadowColor
                                                      ),
                                                      onPressed: () {dataStore.deleteUser(index: index);},
                                                      child: const Text('Yes', style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade900),
                                                        elevation: MaterialStateProperty.all(3),
                                                        shadowColor: MaterialStateProperty.all(Colors.blue.shade900), //Defines shadowColor
                                                      ),
                                                      onPressed: () {Navigator.of(context, rootNavigator: true).pop(); },
                                                      child: const Text('No',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                      child: Icon(Icons.delete,size:30,color: Colors.blue.shade900,))
                                ],
                              )),
                        ],
                      ),
                    );
                  }):const Center(child: Text("No Data Found"),));
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () {
          isUpdate.value = false;
          _showDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialog(BuildContext context,[int? index]) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameEditingCtr,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: hobbyEditingCtr,
                      decoration: const InputDecoration(labelText: "Hobby"),
                    ),
                    TextField(
                      controller: descriptionEditingCtr,
                      decoration: const InputDecoration(labelText: "Description"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.blue.shade900)),
                        onPressed: () {
                          if(isUpdate.value){
                            final user = UserModel(
                              name: nameEditingCtr.text,
                              hobby: hobbyEditingCtr.text,
                              description: descriptionEditingCtr.text,
                            );
                            dataStore.updateUser(userModel: user, index:
                            index!).then((value) {
                              nameEditingCtr.clear();
                              hobbyEditingCtr.clear();
                              descriptionEditingCtr.clear();
                              Navigator.pop(context);
                            });
                          }
                          else{
                            final user = UserModel(
                              name: nameEditingCtr.text,
                              hobby: hobbyEditingCtr.text,
                              description: descriptionEditingCtr.text,
                            );
                            dataStore.addUser(userModel: user).then((value) {
                              nameEditingCtr.clear();
                              hobbyEditingCtr.clear();
                              descriptionEditingCtr.clear();
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Text(isUpdate.value?"Update":"Add"),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
