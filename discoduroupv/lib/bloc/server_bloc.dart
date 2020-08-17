

import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:discoduroupv/models/producto_model.dart';
import 'package:discoduroupv/providers/productos_provider.dart';



class ServerBloc {

  final _serverController = StreamController<List<ProductoModel>>.broadcast();
  final provider = ProductosProvider();

  get stream  => _serverController.stream;

  dispose(){
    _serverController?.close();
  }

  getProducts() async {
    _serverController.sink.add(await provider.cargarProductos());
  }

  addProduct(ProductoModel prod) async
  {
    await provider.crearProducto(prod);
    getProducts();
  }
  removeProduct(String id) async
  {
    await provider.borrarProducto(id);
    getProducts();
  }
  updateProduct(ProductoModel prod) async
  {
    await provider.editarProducto(prod);
    getProducts();
  }
  Future<String> uploadImg(File img) async
  {
    
    final url = await provider.subirImagen(img);
    getProducts();
    return url;
  }






}