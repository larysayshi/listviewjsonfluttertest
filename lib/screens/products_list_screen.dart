import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listview_json_parse_demo/models/product.dart';
import 'dart:convert';

import 'package:listview_json_parse_demo/screens/product_detail_screen.dart';

import '../components/ListViewBuilder.dart';
import '../http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  static const String routeName = '/product-list';

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  late Future<Item> fetchResult;
  bool fetchSuccess = true;
  final searchController = TextEditingController();

  // Future<void> readJsonFile() async {
  //   final String response = await rootBundle.loadString('assets/product.json');
  //   final productData = await json.decode(response);
  //
  //   var list = productData["items"] as List<dynamic>;
  //
  //   searchController.clear();
  //
  //   setState(() {
  //     allProducts = [];
  //     //clears filteredProducts
  //     filteredProducts = [];
  //     allProducts = list.map((e) => Product.fromJson(e)).toList();
  //     filteredProducts = allProducts;
  //   });
  // }

  void _runFilter(String searchKeyword) {
    List<Product> results = [];

    if (searchKeyword.isEmpty) {
      results = allProducts;
    } else {
      results = allProducts
          .where((element) =>
              element.name.toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();
    }

    // refresh the UI
    setState(() {
      filteredProducts = results;
    });
  }

  Future<Item> _initData() async {
    try {
      final carData = await fetchData();
      filteredProducts = carData.items ?? [];
      return fetchData();
    } catch (e) {
      setState(() {
        fetchSuccess = false;
      });
      rethrow;
    }
  }

  Future<void> _refreshData() async {
    try {
      final carData = await fetchData();
      setState(() {
        filteredProducts = carData.items ?? [];
        fetchSuccess = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        fetchSuccess = false;
        filteredProducts = [];
      });
    }
    searchController.clear();
  }

  @override
  void initState() {
    super.initState();
    fetchResult = _initData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: FittedBox(child: Text("First Gen MINI R50/R52/R53 Guide")),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: _refreshData, child: Text("Load Data")),
                searchBar(),
                Container(
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "↑↑Pull to Refresh↑↑",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                Expanded(
                  child: FutureBuilder(
                    future: fetchResult,
                    builder: (BuildContext context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          {
                            return loadingIndicator();
                          }
                        case ConnectionState.done:
                          {
                            if (fetchSuccess == true) {
                              return fetchSuccessView();
                            } else if (fetchSuccess == false) {
                              return fetchFailView(context);
                            } else {
                              return loadingIndicator();
                            }
                          }
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        )

      ),
    );
  }

  RefreshIndicator fetchSuccessView() {
    return RefreshIndicator(
                            onRefresh: () async {
                              _refreshData();
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredProducts.length,
                                itemBuilder: (BuildContext context, index) {
                                  if (filteredProducts.length > 0) {
                                    return ListViewDimissible(
                                        index,
                                        context,
                                        filteredProducts,
                                        dismissItem,
                                        navigateDetailScreen);
                                  } else {
                                    return Container(
                                        child: Text("No items found"));
                                  }
                                }),
                          );
  }

  RefreshIndicator fetchFailView(BuildContext context) {
    return RefreshIndicator(
                            onRefresh: () async {
                              _refreshData();
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child:
                                  Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text("Unexpected Error", textAlign: TextAlign.center,)),
                            ),
                          );
  }

  navigateDetailScreen(BuildContext context, int index) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
        arguments: jsonEncode(filteredProducts[index]));
  }

  dismissItem(DismissDirection direction, int index) {
    if (direction == DismissDirection.endToStart) {
      filteredProducts.removeAt(index);
    }

    //fixes a dismissed Dismissible widget is still part of the tree error
    setState(() {
      filteredProducts;
    });
  }

  Column searchBar() {
    return Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
    );
  }
}

class loadingIndicator extends StatelessWidget {
  const loadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
