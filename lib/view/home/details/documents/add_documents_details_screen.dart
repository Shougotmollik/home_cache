import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/add_document_controller.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import '../../../../config/route/route_names.dart';

class AddDocumentsDetailsScreen extends StatefulWidget {
  const AddDocumentsDetailsScreen({super.key});

  @override
  State<AddDocumentsDetailsScreen> createState() =>
      _AddDocumentsDetailsScreenState();
}

class _AddDocumentsDetailsScreenState extends State<AddDocumentsDetailsScreen> {
  late final String docType;
  String? filePath;

  final Map<String, TextEditingController> controllers = {};
  final AddDocumentController _addDocumentController =
      Get.put(AddDocumentController());

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> args = Get.arguments ?? {};
    docType = (args['type'] ?? 'other').toString().toLowerCase();
    filePath = args['imagePath'];
    print("add doctype shown here ====> $docType");
  }

  Widget field(String label) {
    final controller = TextEditingController();
    controllers[label] = controller;

    bool isDateField = label.toLowerCase().contains('date');

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: isDateField
                ? () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      controller.text =
                          "${picked.year}-${picked.month}-${picked.day}";
                      setState(() {});
                    }
                  }
                : null,
            child: AbsorbPointer(
              absorbing: isDateField,
              child: TextFieldWidget(
                hintText: isDateField ? "Select $label" : "Enter $label",
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFields(String type) {
    switch (type) {
      case 'warranty':
        return [
          field('Name'),
          field('Brand/Manufacturer'),
          field('Warranty Start Date'),
          field('Warranty End Date'),
          field('Serial Number'),
          field('Service Contact Info'),
        ];
      case 'insurance':
        return [
          field('Policy Number'),
          field('Provider Name'),
          field('Coverage Start Date'),
          field('Coverage End Date'),
          field('Premium Amount'),
          field('Claim Contact Info'),
        ];
      case 'receipt':
        return [
          field('Vendor/Store Name'),
          field('Date of Purchase'),
          field('Total Amount Paid'),
          field('Payment Method'),
          field('Order Number'),
        ];
      case 'quote':
        return [
          field('Service/Item Quoted'),
          field('Quote Amount'),
          field('Quote Date'),
          field('Vendor/Company Name'),
          field('Valid Until Date'),
          field('Contact Info'),
          field('Quote Reference Number'),
        ];
      case 'manual':
        return [
          field('Title'),
          field('Brand/Company'),
          field('Item ID'),
          field('Model Number'),
          field('Manual Type'),
          field('Publication Date'),
        ];
      default:
        return [
          field('Title'),
          field('Brand / Company'),
          field('URL'),
          field('Notes'),
        ];
    }
  }

  void _saveDocument() {
    final fieldData = {
      for (var entry in controllers.entries) entry.key: entry.value.text.trim(),
    };

    final data = <String, dynamic>{};

    switch (docType) {
      case 'warranty':
        data.addAll({
          "type": "warranty",
          "name": fieldData['Name'] ?? '',
          "brand": fieldData['Brand/Manufacturer'] ?? '',
          "warranty_start_date": fieldData['Warranty Start Date'] ?? '',
          "warranty_end_date": fieldData['Warranty End Date'] ?? '',
          "serial_number": fieldData['Serial Number'] ?? '',
          "service_contact_info": fieldData['Service Contact Info'] ?? '',
        });
        break;

      case 'insurance':
        data.addAll({
          "type": "insurance",
          "policy_number": fieldData['Policy Number'] ?? '',
          "provider_name": fieldData['Provider Name'] ?? '',
          "coverage_start_date": fieldData['Coverage Start Date'] ?? '',
          "coverage_end_date": fieldData['Coverage End Date'] ?? '',
          "premium_amount": fieldData['Premium Amount'] ?? '',
          "claim_contact_info": fieldData['Claim Contact Info'] ?? '',
        });
        break;

      case 'receipt':
        data.addAll({
          "type": "receipt",
          "vendor_store_name": fieldData['Vendor/Store Name'] ?? '',
          "date_of_purchase": fieldData['Date of Purchase'] ?? '',
          "total_amount_paid": fieldData['Total Amount Paid'] ?? '',
          "payment_method": fieldData['Payment Method'] ?? '',
          "order_number": fieldData['Order Number'] ?? '',
        });
        break;

      case 'quote':
        data.addAll({
          "type": "quote",
          "service_item_quoted": fieldData['Service/Item Quoted'] ?? '',
          "quote_amount": fieldData['Quote Amount'] ?? '',
          "quote_date": fieldData['Quote Date'] ?? '',
          "vendor_company_name": fieldData['Vendor/Company Name'] ?? '',
          "valid_until_date": fieldData['Valid Until Date'] ?? '',
          "contact_info": fieldData['Contact Info'] ?? '',
          "quote_reference_number": fieldData['Quote Reference Number'] ?? '',
        });
        break;

      case 'manual':
        data.addAll({
          "type": "manual",
          "title": fieldData['Title'] ?? '',
          "brand": fieldData['Brand/Company'] ?? '',
          "item_id": fieldData['Item ID'] ?? '',
          "model_number": fieldData['Model Number'] ?? '',
          "manual_type": fieldData['Manual Type'] ?? '',
          "publication_date": fieldData['Publication Date'] ?? '',
        });
        break;

      default:
        data.addAll({
          "type": "other",
          "title": fieldData['Title'] ?? '',
          "brand": fieldData['Brand / Company'] ?? '',
          "url": fieldData['URL'] ?? '',
          "note": fieldData['Notes'] ?? '',
        });
        break;
    }

    final Map<String, String> finalData =
        data.map((key, value) => MapEntry(key, value.toString()));

    debugPrint('FINAL JSON TO SEND ====> $finalData');

    if (filePath != null) {
      _addDocumentController.selectedFile.value = File(filePath!);
    }

    _addDocumentController.addDocument(finalData);

    Get.offAndToNamed(RouteNames.documents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(
        title: 'Document Details',
        titleColor: AppColors.secondary,
      ),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (filePath != null)
                Container(
                  height: 160.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.w),
                  ),
                  child: filePath!.endsWith('.pdf')
                      ? PDFView(
                          filePath: filePath,
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageFling: true,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(filePath!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ..._buildFields(docType),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
          child: CustomElevatedButton(
            onTap: _saveDocument,
            btnText: 'Save',
            height: 48.h,
          ),
        ),
      ),
    );
  }
}
