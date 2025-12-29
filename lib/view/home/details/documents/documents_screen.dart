import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/controller/documents_controller.dart';
import 'package:home_cache/view/home/details/widgets/document_tile.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import '../../../../config/route/route_names.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/app_typo_graphy.dart';

class DocumentsScreen extends StatelessWidget {
  DocumentsScreen({super.key});
  final DocumentsController controller = Get.put(DocumentsController());

  final List<String> categories = [
    "warranty",
    "insurance",
    "receipt",
    "quote",
    "manual",
    "other"
  ];
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(
        title: 'Documents',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                Get.toNamed(RouteNames.addDocuments);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('+ Add',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Categories
            Obx(() => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isSelected = selectedCategoryIndex.value == index;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: ElevatedButton(
                            onPressed: () {
                              selectedCategoryIndex.value = index;
                              controller.fetchDocuments(categories[index]);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? AppColors.primary
                                  : AppColors.lightgrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              elevation: 0.0,
                            ),
                            child: Text(categories[index],
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.sp)),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final actualIndex = index + 3;
                        final isSelected =
                            selectedCategoryIndex.value == actualIndex;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: ElevatedButton(
                            onPressed: () {
                              selectedCategoryIndex.value = actualIndex;
                              controller
                                  .fetchDocuments(categories[actualIndex]);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? AppColors.primary
                                  : AppColors.lightgrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                            ),
                            child: Text(categories[actualIndex],
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.sp)),
                          ),
                        );
                      }),
                    ),
                  ],
                )),

            SizedBox(height: 20.h),

            // Documents Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomProgressIndicator());
                }

                final filteredDocs = controller
                    .getByCategory(categories[selectedCategoryIndex.value]);
                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Text('No documents in this category.',
                        style: AppTypoGraphy.medium
                            .copyWith(color: AppColors.black)),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 8.h),
                  itemCount: filteredDocs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: .95),
                  // Replace the itemBuilder section in your DocumentsScreen with this:

                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];

                    // Determine title, subtitle, and date based on document type
                    String title = '';
                    String subtitle = '';
                    String date = '';

                    switch (doc.type) {
                      case 'warranty':
                        title = doc.details.name ?? 'Warranty Document';
                        subtitle = doc.details.brand ?? 'Brand not specified';
                        date = " Expires: ${doc.details.warrantyEndDate}" ??
                            'No date';
                        break;

                      case 'insurance':
                        title = doc.details.providerName ?? 'Insurance Policy';
                        subtitle =
                            doc.details.policyNumber ?? 'No policy number';
                        date = doc.details.coverageEndDate ??
                            // doc.details.coverageStartDate ??
                            'No date';
                        break;

                      case 'receipt':
                        title = doc.details.vendorStoreName ?? 'Receipt';
                        subtitle = doc.details.totalAmountPaid != null
                            ? '\$${doc.details.totalAmountPaid}'
                            : 'Amount not specified';
                        date = doc.details.dateOfPurchase ?? 'No date';
                        break;

                      case 'quote':
                        title = doc.details.serviceItemQuoted ?? 'Quote';
                        subtitle = doc.details.vendorCompanyName ??
                            (doc.details.quoteAmount != null
                                ? '\$${doc.details.quoteAmount}'
                                : 'No vendor');
                        date = doc.details.validUntilDate ??
                            doc.details.quoteDate ??
                            'No date';
                        break;

                      case 'manual':
                        title = doc.details.title ?? 'Manual';
                        subtitle = doc.details.brandCompany ??
                            doc.details.modelNumber ??
                            'No brand';
                        date = doc.details.publicationDate ?? 'No date';
                        break;

                      case 'other':
                        title = doc.details.otherTitle ?? 'Document';
                        subtitle = doc.details.otherBrandCompany ??
                            doc.details.notes ??
                            'No description';
                        date = doc.details.otherBrandCompany ?? 'No date';
                        break;

                      default:
                        title = doc.type.capitalizeFirst ?? 'Document';
                        subtitle = 'Unknown type';
                        date = 'No date';
                    }

                    return DocumentTile(
                      title: title,
                      subtitle: subtitle,
                      date: date,
                      iconPath: 'assets/images/document.png',
                      onTap: () {
                        Get.toNamed(RouteNames.documentsDetails,
                            arguments: doc);
                      },
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
