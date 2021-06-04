import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _pricefocusNode = FocusNode();
  final _desfocusNode = FocusNode();
  @override
  void dispose() {
    _pricefocusNode.dispose();
    _desfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit product'),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_pricefocusNode);
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'price'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _pricefocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_desfocusNode);
                    }),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _desfocusNode,
                )
              ],
            ),
          ),
        ));
  }
}
