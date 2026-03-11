import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/constants/app_constants.dart';

enum ProductState { idle, loading, success, error, empty }

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  final products = <ProductModel>[].obs;
  final state = ProductState.idle.obs;
  final isPaginationLoading = false.obs;
  final errorMessage = ''.obs;
  final scrollController = ScrollController();

  int _skip = 0;
  int _total = 0;
  bool _isFetching = false;

  bool get hasMore => products.length < _total;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200 && hasMore && !_isFetching) {
      loadMore();
    }
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (isRefresh) {
      _skip = 0;
      products.clear();
    }

    state.value = ProductState.loading;
    errorMessage.value = '';

    try {
      final result = await _repository.getProducts(skip: 0);
      final list = result['products'] as List<ProductModel>;
      _total = result['total'] as int;
      _skip = AppConstants.pageLimit;

      products.assignAll(list);
      state.value = list.isEmpty ? ProductState.empty : ProductState.success;
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = ProductState.error;
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadMore() async {
    if (_isFetching || !hasMore) return;
    _isFetching = true;
    isPaginationLoading.value = true;

    try {
      final result = await _repository.getProducts(skip: _skip);
      final list = result['products'] as List<ProductModel>;
      _skip += AppConstants.pageLimit;
      products.addAll(list);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more products. Tap to retry.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: loadMore,
          child: const Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      _isFetching = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> retry() => fetchProducts(isRefresh: true);

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
