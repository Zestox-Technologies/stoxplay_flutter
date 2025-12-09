import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/features/home_page/data/models/learning_model.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class BookCard extends StatelessWidget {
  final LearningModel book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [BoxShadow(color: AppColors.black40, blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(16.r)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blue2E92, AppColors.primaryPurple],
                  ),
                ),
                child:
                    book.thumbnailUrl != null && book.thumbnailUrl.toString().isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: book.thumbnailUrl.toString(),
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: AppColors.whiteF1F1,
                                  child: Icon(Icons.book, size: 32.w, color: AppColors.white),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: AppColors.whiteF1F1,
                                  child: Icon(Icons.book, size: 32.w, color: AppColors.white),
                                ),
                          ),
                        )
                        : Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.book, size: 40.w, color: AppColors.white),
                        ),
              ),
            ),
            // Book Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title ?? 'Untitled Book',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black3333,
                        fontFamily: 'Sofia Sans',
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.picture_as_pdf, size: 10.w, color: AppColors.orangeF6A6),
                        SizedBox(width: 4.w),
                        Text(
                          'PDF Book',
                          style: TextStyle(fontSize: 10.sp, color: AppColors.black9999, fontFamily: 'Sofia Sans'),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.green0CAELight,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green0CAE,
                          fontFamily: 'Sofia Sans',
                        ),
                      ),
                    ),
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
