import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop_flutter/providers/product.dart';
import 'package:myshop_flutter/providers/products.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  bool isValidImageUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();

    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);

    if (_formData['id'] == null) {
      try {
        await products.addProduct(product);
        Navigator.of(context).pop();
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Ocorreu um erro!'),
            content: Text('Ocorreu um erro ao tentar salvar o produto!'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      products.updateProduct(product);

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveForm())
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['title'],
                        decoration: InputDecoration(labelText: 'Título'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) => _formData['title'] = value,
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          bool isInvalid = value.trim().length < 3;

                          if (isEmpty || isInvalid) {
                            return 'Informe um Título válido com no mínimo 3 caracteres!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price'].toString(),
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) =>
                            _formData['price'] = double.parse(value),
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          var newPrice = double.tryParse(value);
                          bool isInvalid = newPrice == null || newPrice <= 0;

                          if (isEmpty || isInvalid) {
                            return 'Informe um Preço válido!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description'],
                        decoration: InputDecoration(labelText: 'Descrição'),
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) => _formData['description'] = value,
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          bool isInvalid = value.trim().length < 10;

                          if (isEmpty || isInvalid) {
                            return 'Informe um Descrição válida com no mínimo 10 caracteres!';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'URL da Imagem'),
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocusNode,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onSaved: (value) => _formData['imageUrl'] = value,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                bool isEmpty = value.trim().isEmpty;
                                bool isInvalid = !isValidImageUrl(value);

                                if (isEmpty || isInvalid) {
                                  return 'Informe uma URL válida!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Informe a URL')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
