import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  final String uid;

  const EditPage({Key? key, required this.uid}) : super(key: key);

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _existingSubjectsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _newSubjectFormKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _subjectsData = [];
  final TextEditingController _newSubnameController = TextEditingController();
  final TextEditingController _newTotalController = TextEditingController();
  final TextEditingController _newCurrentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSubjectsData();
  }

  Future<void> _fetchSubjectsData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('subdata')
              .doc(widget.uid)
              .get();

      if (snapshot.exists) {
        final userData = snapshot.data();
        if (userData != null && userData.containsKey('subjects')) {
          final List<dynamic> subjectsList =
              userData['subjects'] as List<dynamic>;

          final List<Map<String, dynamic>> subjectsData = [];

          for (final subject in subjectsList) {
            if (subject is Map<String, dynamic> &&
                subject.containsKey('subname') &&
                subject.containsKey('curr') &&
                subject.containsKey('total')) {
              subjectsData.add(subject);
            }
          }

          setState(() {
            _subjectsData = subjectsData;
          });
        }
      }
    } catch (e) {
      print('Error fetching subjects data: $e');
    }
  }

  Future<void> _saveExistingSubjectsData() async {
    if (_existingSubjectsFormKey.currentState!.validate()) {
      _existingSubjectsFormKey.currentState!.save();

      final List<Map<String, dynamic>> updatedSubjectsData = [];

      for (final subjectData in _subjectsData) {
        final Map<String, dynamic> updatedSubjectData = {
          'subname': subjectData['subname'],
          'curr': subjectData['curr'],
          'total': subjectData['total'],
        };

        updatedSubjectsData.add(updatedSubjectData);
      }

      try {
        await FirebaseFirestore.instance
            .collection('subdata')
            .doc(widget.uid)
            .update({'subjects': updatedSubjectsData});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subjects data saved successfully')),
        );
      } catch (e) {
        print('Error saving subjects data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving subjects data')),
        );
      }
    }
  }

  void _addNewSubject() {
    if (_newSubjectFormKey.currentState!.validate()) {
      final newSubject = {
        'subname': _newSubnameController.text.toUpperCase(),
        'curr': int.tryParse(_newCurrentController.text) ?? 0,
        'total': int.tryParse(_newTotalController.text) ?? 0,
      };

      setState(() {
        _subjectsData.add(newSubject);
        _newSubnameController.clear();
        _newCurrentController.clear();
        _newTotalController.clear();
      });

      _saveSubjectToDatabase(newSubject);
    }
  }

  Future<void> _saveSubjectToDatabase(Map<String, dynamic> subjectData) async {
    try {
      await FirebaseFirestore.instance
          .collection('subdata')
          .doc(widget.uid)
          .update({
        'subjects': FieldValue.arrayUnion([subjectData])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject added successfully')),
      );
    } catch (e) {
      print('Error adding subject: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding subject')),
      );
    }
  }

  void _deleteSubject(Map<String, dynamic> subjectData) {
    setState(() {
      _subjectsData.remove(subjectData);
    });

    _deleteSubjectFromDatabase(subjectData);
  }

  Future<void> _deleteSubjectFromDatabase(
      Map<String, dynamic> subjectData) async {
    try {
      await FirebaseFirestore.instance
          .collection('subdata')
          .doc(widget.uid)
          .update({
        'subjects': FieldValue.arrayRemove([subjectData])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject deleted successfully')),
      );
    } catch (e) {
      print('Error deleting subject: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting subject')),
      );
    }
  }

  @override
  void dispose() {
    _newSubnameController.dispose();
    _newCurrentController.dispose();
    _newTotalController.dispose();
    super.dispose();
  }

  static const TextStyle headstyle = TextStyle(
    fontFamily: 'ProductSans',
    color: Colors.white,
    fontSize: 17,
  );
  static const TextStyle bodystyle = TextStyle(
    fontFamily: 'SourceSans',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Form(
              key: _existingSubjectsFormKey,
              child: ListView(
                children: [
                  DataTable(
                    columnSpacing: 10,
                    columns: const [
                      DataColumn(
                        label: SizedBox(
                          width: 120,
                          child: Text(
                            'Subject',
                            style: headstyle,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      DataColumn(
                          label: Text(
                        'Current',
                        style: headstyle,
                      )),
                      DataColumn(
                          label: Text(
                        'Total',
                        style: headstyle,
                      )),
                      DataColumn(
                          label: Text(
                        'Delete',
                        style: headstyle,
                      )),
                    ],
                    rows: _subjectsData.map<DataRow>((subjectData) {
                      final TextEditingController subnameController =
                          TextEditingController(
                        text: subjectData['subname'].toString(),
                      );
                      final TextEditingController totalController =
                          TextEditingController(
                        text: subjectData['total'].toString(),
                      );
                      final TextEditingController currentController =
                          TextEditingController(
                        text: subjectData['curr'].toString(),
                      );
                      return DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 120,
                              child: Text(
                                subnameController.text,
                                style: bodystyle,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                            ),
                            // TextFormField(
                            //   controller: subnameController,
                            //   readOnly: true,
                            //   maxLines: 1,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter a subject name';
                            //     }
                            //     return null;
                            //   },
                            //   style: bodystyle,
                            //   onSaved: (value) {
                            //     subjectData['subname'] = value!;
                            //   },
                            // ),
                          ),
                          DataCell(
                            TextFormField(
                              controller: currentController,
                              keyboardType: TextInputType.number,
                              style: bodystyle,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                subjectData['curr'] = int.parse(value!);
                              },
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              controller: totalController,
                              keyboardType: TextInputType.number,
                              style: bodystyle,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                subjectData['total'] = int.parse(value!);
                              },
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteSubject(subjectData);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'Add New Subject',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
          ),
          Expanded(
            flex: 2,
            child: Form(
              key: _newSubjectFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _newSubnameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                      labelStyle: bodystyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _addNewSubject,
                    child: const Text(
                      'Add Subject',
                      style: TextStyle(
                        fontFamily: 'Architect',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveExistingSubjectsData,
        label: const Text(
          'Update Data',
          style: TextStyle(
            fontFamily: 'Architect',
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
