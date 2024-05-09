

import 'package:flutter/material.dart';

import '../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

Dismissible ListViewDimissible(int index, BuildContext context, List<Product> filteredProducts, dismissItem, navigateDetailScreen) {
  return Dismissible(
    key: ValueKey(
        filteredProducts[index].id.toString()),
    background: Container(
      color: Colors.redAccent,
      child: Icon(Icons.delete,
          color: Colors.white, size: 40),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
    ),
    direction: DismissDirection.endToStart,
    confirmDismiss: (direction) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Please Confirm"),
          content: Text(
              "Are you sure you want to delete?"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text("Cancel")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text("Delete")),
          ],
        ),
      );
    },
    onDismissed: (DismissDirection direction) {
      dismissItem(direction, index);
    },
    child: Card(
        margin: EdgeInsets.all(5.0),
        color: Colors.white,
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: filteredProducts[index].image,
            placeholder: (context,url) => CircularProgressIndicator(),
            errorWidget: (context, url, error)=> Row(
              children: [
                Icon(Icons.error),
                Text(error.toString())
              ],
            ),
          ),
          title: CardTitle(filteredProducts, index),
          subtitle: CardSubtitle(filteredProducts, index),
          onTap: () {
            navigateDetailScreen(context, index);
          },
        )),
  );
}

Padding CardTitle(List<Product> filteredProducts, int index) {
  return Padding(
          padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filteredProducts[index].name,
                  maxLines: null,
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
        );
}

Padding CardSubtitle(List<Product> filteredProducts, int index) {
  return Padding(
          padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                Text(
                  filteredProducts[index]
                      .shortdes
                      .toString(),
                  maxLines: null,
                ),
              ],
            ),
        );
}
