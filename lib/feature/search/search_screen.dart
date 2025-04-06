import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/back_appbar.dart';
import 'package:greener/core/widgets/custom_text.dart';
import 'package:greener/core/widgets/custom_text_field.dart';
import 'package:greener/core/widgets/plant_card.dart';
import 'package:greener/feature/search/widgets/disease_card.dart';
import 'package:greener/feature/search/widgets/faq_card.dart';
import 'package:greener/feature/search/widgets/search_redio_buttons.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/kapi.dart';
import '../home/home_screen.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchScreenContent(),
    );
  }
}

class _SearchScreenContent extends StatefulWidget {
  const _SearchScreenContent();

  @override
  State<_SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<_SearchScreenContent> {
  final ScrollController _scrollController = ScrollController();
  late SearchCubit _cubit;
  int _currentPage = 1;
  String _currentQuery = '';
  String _currentSearchType = KApi.speciesList;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      if (!_cubit.isLoading &&
          !_cubit.hasReachedMax &&
          _currentQuery.isNotEmpty) {
        _currentPage++;
        _cubit.searchProduct(
          _currentQuery,
          _currentSearchType,
          page: _currentPage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitenColor,
      appBar: const BackAppBar(
        title: "Search",
        backgroundColor: baseColor,
        textColor: Color(0xFFF5F5F5),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 8.w, left: 8.w),
        child: Column(
          children: [
            SearchRadioButtons(
              onChange: () {
                _currentPage = 1;
                _currentSearchType = SearchRadioButtonsState.selectedValue;
                if (_currentQuery.isNotEmpty) {
                  _cubit.searchProduct(
                    _currentQuery,
                    _currentSearchType,
                    page: _currentPage,
                  );
                }
              },
            ),
            CustomTextField(
              prefixIcon: CupertinoIcons.search,
              text: "Search",
              clearIcon: true,
              controller: TextEditingController(),
              onClear: () {
                _currentQuery = '';
                _currentPage = 1;
                _cubit.clearSearch();
              },
              onSubmit: (value) {
                if (value.isNotEmpty) {
                  _currentQuery = value;
                  _currentPage = 1;
                  _currentSearchType = SearchRadioButtonsState.selectedValue;
                  _cubit.searchProduct(
                    value,
                    _currentSearchType,
                    page: _currentPage,
                  );
                }
              },
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoadingState && _currentPage == 1) {
                    return const Center(
                      child: CircularProgressIndicator(color: baseColor),
                    );
                  }
                  if (state is SearchErrorState) {
                    return Center(
                      child: CustomText(
                        text: state.error,
                        textSize: 18,
                        textColor: Colors.red,
                      ),
                    );
                  }
                  if (state is SearchSuccessState) {
                    final List<dynamic> items = state.products;

                    if (items.isEmpty && _currentPage == 1) {
                      return Center(
                        child: TextButton(
                          onPressed: () => _pickImage(context),
                          child: const CustomText(
                            text:
                                "Detect your plant's disease using its image.",
                            textSize: 22,
                            textAlign: TextAlign.center,
                            textWeight: FontWeight.bold,
                            textColor: baseColor,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                items.length + (_cubit.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == items.length && _cubit.isLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: baseColor),
                                  ),
                                );
                              }
                              if (_currentSearchType == KApi.speciesList) {
                                return PlantCard(plantData: items[index]);
                              } else if (_currentSearchType == KApi.disease) {
                                return DiseaseCard(diseaseData: items[index]);
                              } else {
                                return FaqCard(faqData: items[index]);
                              }
                            },
                          ),
                        ),
                        if (_cubit.hasReachedMax)
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: const Text("No more items to load"),
                          ),
                      ],
                    );
                  }
                  return Center(
                    child: TextButton(
                      onPressed: () => _pickImage(context),
                      child: const CustomText(
                        text: "Detect your plant's disease using its image.",
                        textSize: 22,
                        textAlign: TextAlign.center,
                        textWeight: FontWeight.bold,
                        textColor: baseColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Photo'),
              onTap: () async {
                pickedFile = await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null && mounted) {
                  Navigator.pop(context);
                  await _processImage(pickedFile);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null && mounted) {
                  Navigator.pop(context);
                  await _processImage(pickedFile);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _processImage(XFile? pickedFile) async {
    if (pickedFile == null || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String result =
          await DiseaseAiService().analyzeImage(await pickedFile.readAsBytes());
      if (mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        _showResultDialog(pickedFile, result);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        _showResultDialog(pickedFile, "Error analyzing image: $e");
      }
    }
  }

  void _showResultDialog(XFile? imageFile, String result) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
          title: const CustomText(
            text: 'Analysis Result',
            textSize: 22,
            textWeight: FontWeight.bold,
            textAlign: TextAlign.justify,
            textColor: baseColor,
          ),
          content: SizedBox(
            width: 600.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageFile != null) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 200.h,
                      child: Image.file(
                        File(imageFile.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  MarkdownBody(
                    data: result,
                    selectable: true,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Assume SearchCubit has these properties
extension SearchCubitExtensions on SearchCubit {
  bool get isLoading => state is SearchLoadingState;

  bool get hasReachedMax =>
      state is SearchSuccessState &&
      (state as SearchSuccessState).hasReachedMax;
}
