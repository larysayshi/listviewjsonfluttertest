import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listview_json_parse_demo/models/product.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const String routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var productName = "";
  Product? product;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var productString = ModalRoute.of(context)?.settings.arguments as String;
    print('page 2');
    print(productString);

    var productJson = jsonDecode(productString);
    print(productJson);

    setState(() {
      product = Product.fromJson(productJson);
      productName = product!.name;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FittedBox(child: Text(productName)),
        ),
        body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 25,
                        ),
                        Flexible(
                          child: CachedNetworkImage(
                            imageUrl: product!.image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Row(
                              children: [
                                Icon(Icons.error),
                                Text(error.toString())
                              ],
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                                "Category : " + (product!.category.toString()),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0))),
                        const SizedBox(
                          height: 25,
                        ),
                        Flexible(
                            child: ScrollableTextIndicator(
                          text: Text(
                            "" + (product!.description.toString()),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ))),
        ));
  }
}
