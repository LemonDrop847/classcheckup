import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  final String uid;

  const EditPage({Key? key, required this.uid}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _existingSubjectsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _newSubjectFormKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _subjectsData = [];
  TextEditingController _newSubnameController = TextEditingController();
  TextEditingController _newTotalController = TextEditingController();
  TextEditingController _newCurrentController = TextEditingController();

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
        'subname': _newSubnameController.text,
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

  @override
  void dispose() {
    _newSubnameController.dispose();
    _newCurrentController.dispose();
    _newTotalController.dispose();
    super.dispose();
  }

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
                    columns: const [
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Current')),
                      DataColumn(label: Text('Total')),
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
                            TextFormField(
                              controller: subnameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a subject name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                subjectData['subname'] = value!;
                              },
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              controller: currentController,
                              keyboardType: TextInputType.number,
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            flex: 2,
            child: Form(
              key: _newSubjectFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _newSubnameController,
                    decoration:
                        const InputDecoration(labelText: 'Subject Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject name';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _addNewSubject,
                    child: const Text('Add Subject'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveExistingSubjectsData,
        label: const Text('Update Data'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
