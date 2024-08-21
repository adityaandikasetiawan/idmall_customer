import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class TreeSelectPage extends StatefulWidget {
  @override
  _TreeSelectPageState createState() => _TreeSelectPageState();
}

class _TreeSelectPageState extends State<TreeSelectPage> {
  late TreeViewController _treeViewController;
  List<Node> _nodes = [];
  Set<String> _selectedNodes = {};

  @override
  void initState() {
    super.initState();
    _nodes = [
      const Node(
        label: 'yuniarto',
        key: '1',
        children: [
          Node(label: 'mutiara.sofiane', key: '2'),
          Node(
            label: 'bayu.priyambodo',
            key: '3',
            children: [
              Node(label: 'yuliariyanto', key: '4'),
              Node(label: 'taqiya.mutiaphazsa', key: '5'),
              Node(label: 'tomitriono', key: '6'),
              Node(label: 'mirna.wanti', key: '7'),
              Node(label: 'panca.putra', key: '8'),
            ],
          ),
        ],
      ),
    ];

    _treeViewController = TreeViewController(
      children: _nodes,
    );
  }

  void _showTreeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: double.maxFinite,
                height: 400,
                child: TreeView(
                  controller: _treeViewController,
                  allowParentSelect: true,
                  supportParentDoubleTap: true,
                  onNodeTap: (key) {
                    setState(() {
                      _toggleNodeSelection(key);
                    });
                  },
                  nodeBuilder: (context, node) {
                    return ListTile(
                      title: Text(node.label),
                      leading: Checkbox(
                        value: _selectedNodes.contains(node.key),
                        onChanged: (checked) {
                          setState(() {
                            _toggleNodeSelection(node.key);
                          });
                        },
                      ),
                    );
                  },
                  theme: const TreeViewTheme(
                    expanderTheme: ExpanderThemeData(
                      type: ExpanderType.caret,
                      modifier: ExpanderModifier.none,
                      position: ExpanderPosition.start,
                      color: Colors.blue,
                      size: 20,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    parentLabelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    iconTheme: IconThemeData(
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleNodeSelection(String key) {
    if (_selectedNodes.contains(key)) {
      _deselectNode(key);
    } else {
      _selectNode(key);
    }
  }

  void _selectNode(String key) {
    _selectedNodes.add(key);
    Node? node = _treeViewController.getNode(key);
    if (node != null && node.children.isNotEmpty) {
      for (var child in node.children) {
        _selectNode(child.key);
      }
    }
  }

  void _deselectNode(String key) {
    _selectedNodes.remove(key);
    Node? node = _treeViewController.getNode(key);
    if (node != null && node.children.isNotEmpty) {
      for (var child in node.children) {
        _deselectNode(child.key);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Select Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select an item'),
            GestureDetector(
              onTap: _showTreeDialog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedNodes.isEmpty
                          ? 'Select'
                          : _selectedNodes.join(', '),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TreeSelectPage(),
  ));
}
