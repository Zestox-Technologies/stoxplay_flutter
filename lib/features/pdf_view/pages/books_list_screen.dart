import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/learning_model.dart';
import 'package:stoxplay/features/pdf_view/pages/pdf_viewer_screen.dart';
import 'package:stoxplay/features/pdf_view/widgets/book_card.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class BooksListScreen extends StatefulWidget {
  const BooksListScreen({super.key});

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    cubit.getLearningList(Strings.pdf);
  }

  // Helper method to get responsive grid parameters
  Map<String, dynamic> _getResponsiveGridParams(double screenWidth) {
    int crossAxisCount;
    double childAspectRatio;
    double crossAxisSpacing;
    double mainAxisSpacing;
    EdgeInsets padding;

    if (screenWidth < 600) {
      // Mobile phones (portrait)
      crossAxisCount = 2;
      childAspectRatio = 0.65;
      crossAxisSpacing = 12.w;
      mainAxisSpacing = 12.h;
      padding = EdgeInsets.all(12.w);
    } else if (screenWidth < 900) {
      // Tablets (portrait) and large phones
      crossAxisCount = 3;
      childAspectRatio = 0.7;
      crossAxisSpacing = 16.w;
      mainAxisSpacing = 16.h;
      padding = EdgeInsets.all(16.w);
    } else if (screenWidth < 1200) {
      // Tablets (landscape) and small desktops
      crossAxisCount = 4;
      childAspectRatio = 0.75;
      crossAxisSpacing = 20.w;
      mainAxisSpacing = 20.h;
      padding = EdgeInsets.all(20.w);
    } else {
      // Large desktops
      crossAxisCount = 5;
      childAspectRatio = 0.8;
      crossAxisSpacing = 24.w;
      mainAxisSpacing = 24.h;
      padding = EdgeInsets.all(24.w);
    }

    return {
      'crossAxisCount': crossAxisCount,
      'childAspectRatio': childAspectRatio,
      'crossAxisSpacing': crossAxisSpacing,
      'mainAxisSpacing': mainAxisSpacing,
      'padding': padding,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteF7F9,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false, // Disable back button
        title: Text(
          'Free Books Library',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Sofia Sans',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [SizedBox(width: kToolbarHeight)],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.apiStatus == ApiStatus.loading) {
            return _buildLoadingGrid();
          } else if (state.apiStatus == ApiStatus.failed) {
            return _buildErrorState();
          } else if (state.learningList == null || state.learningList!.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildBookGrid(state.learningList!);
          }
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final params = _getResponsiveGridParams(screenWidth);

        return GridView.builder(
          padding: params['padding'],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: params['crossAxisCount'],
            childAspectRatio: params['childAspectRatio'],
            crossAxisSpacing: params['crossAxisSpacing'],
            mainAxisSpacing: params['mainAxisSpacing'],
          ),
          itemCount: params['crossAxisCount'] * 3, // Show 3 rows of loading items
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: AppColors.whiteDFE0,
              highlightColor: AppColors.white,
              child: Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12.r)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.w, color: AppColors.black9999),
          SizedBox(height: 16.h),
          Text(
            'Failed to load books',
            style: TextStyle(fontSize: 16.sp, color: AppColors.black6666, fontFamily: 'Sofia Sans'),
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () => cubit.getLearningList(Strings.pdf),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text('Retry', style: TextStyle(color: AppColors.white, fontFamily: 'Sofia Sans')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 64.w, color: AppColors.black9999),
          SizedBox(height: 16.h),
          Text(
            'No books available',
            style: TextStyle(fontSize: 16.sp, color: AppColors.black6666, fontFamily: 'Sofia Sans'),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new books',
            style: TextStyle(fontSize: 14.sp, color: AppColors.blackC2C2, fontFamily: 'Sofia Sans'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookGrid(List<LearningModel> books) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final params = _getResponsiveGridParams(screenWidth);

        return GridView.builder(
          padding: params['padding'],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: params['crossAxisCount'],
            childAspectRatio: params['childAspectRatio'],
            crossAxisSpacing: params['crossAxisSpacing'],
            mainAxisSpacing: params['mainAxisSpacing'],
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return BookCard(book: books[index], onTap: () => _openPdfViewer(books[index], index));
          },
        );
      },
    );
  }

  void _openPdfViewer(LearningModel book, int index) {
    if (book.pdfUrl != null && book.pdfUrl.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PdfViewerScreen(title: book.title ?? 'Book', index: index, pdfUrl: book.pdfUrl.toString()),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF not available for this book'), backgroundColor: AppColors.orangeF6A6));
    }
  }
}
