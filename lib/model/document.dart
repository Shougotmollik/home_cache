class Document {
  final String id;
  final String type;
  final List<FileModel> files;
  final String addedBy;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String? deletedAt;
  final DocumentDetails details;

  Document({
    required this.id,
    required this.type,
    required this.files,
    required this.addedBy,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.details,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        type: json["type"],
        files: (json["files"] as List<dynamic>)
            .map((e) => FileModel.fromJson(e))
            .toList(),
        addedBy: json["added_by"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"],
        details: DocumentDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "files": files.map((e) => e.toJson()).toList(),
        "added_by": addedBy,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "deleted_at": deletedAt,
        "details": details.toJson(),
      };
}

class FileModel {
  final String fileId;
  final String fileUrl;

  FileModel({
    required this.fileId,
    required this.fileUrl,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        fileId: json["file_id"],
        fileUrl: json["file_url"],
      );

  Map<String, dynamic> toJson() => {
        "file_id": fileId,
        "file_url": fileUrl,
      };
}

class DocumentDetails {
  final String id;
  final String type;
  // final List<FileItem> files;
  final String addedBy;
  final String? createdAt;
  final String? updatedAt;

  // WARRANTY
  final String? name;
  final String? brand;
  final String? warrantyStartDate;
  final String? warrantyEndDate;
  final String? serialNumber;
  final String? serviceContactInfo;

  // INSURANCE
  final String? policyNumber;
  final String? providerName;
  final String? coverageStartDate;
  final String? coverageEndDate;
  final num? premiumAmount;
  final String? claimContactInfo;

  // RECEIPT
  final String? vendorStoreName;
  final String? dateOfPurchase;
  final num? totalAmountPaid;
  final String? paymentMethod;
  final String? orderNumber;

  // QUOTE
  final String? serviceItemQuoted;
  final num? quoteAmount;
  final String? quoteDate;
  final String? vendorCompanyName;
  final String? validUntilDate;
  final String? contactInfo;
  final String? quoteReferenceNumber;

  // MANUAL
  final String? title;
  final String? brandCompany;
  final String? itemId;
  final String? modelNumber;
  final String? manualType;
  final String? publicationDate;

  // OTHER
  final String? otherTitle;
  final String? otherBrandCompany;
  final String? url;
  final String? notes;

  DocumentDetails({
    required this.id,
    required this.type,
    // required this.files,
    required this.addedBy,
    this.createdAt,
    this.updatedAt,

    // WARRANTY
    this.name,
    this.brand,
    this.warrantyStartDate,
    this.warrantyEndDate,
    this.serialNumber,
    this.serviceContactInfo,

    // INSURANCE
    this.policyNumber,
    this.providerName,
    this.coverageStartDate,
    this.coverageEndDate,
    this.premiumAmount,
    this.claimContactInfo,

    // RECEIPT
    this.vendorStoreName,
    this.dateOfPurchase,
    this.totalAmountPaid,
    this.paymentMethod,
    this.orderNumber,

    // QUOTE
    this.serviceItemQuoted,
    this.quoteAmount,
    this.quoteDate,
    this.vendorCompanyName,
    this.validUntilDate,
    this.contactInfo,
    this.quoteReferenceNumber,

    // MANUAL
    this.title,
    this.brandCompany,
    this.itemId,
    this.modelNumber,
    this.manualType,
    this.publicationDate,

    // OTHER
    this.otherTitle,
    this.otherBrandCompany,
    this.url,
    this.notes,
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) {
    return DocumentDetails(
      id: json["id"] ?? "",
      type: json["type"] ?? "",
      addedBy: json["added_by"] ?? "",
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],

      // files: json["files"] != null
      //     ? (json["files"] as List).map((e) => FileItem.fromJson(e)).toList()
      //     : [],

      // WARRANTY
      name: json["name"],
      brand: json["brand"],
      warrantyStartDate: json["warranty_start_date"],
      warrantyEndDate: json["warranty_end_date"],
      serialNumber: json["serial_number"],
      serviceContactInfo: json["service_contact_info"],

      // INSURANCE
      policyNumber: json["policy_number"],
      providerName: json["provider_name"],
      coverageStartDate: json["coverage_start_date"],
      coverageEndDate: json["coverage_end_date"],
      premiumAmount: json["premium_amount"] != null
          ? num.tryParse(json["premium_amount"].toString())
          : null,
      claimContactInfo: json["claim_contact_info"],

      // RECEIPT
      vendorStoreName: json["vendor_store_name"],
      dateOfPurchase: json["date_of_purchase"],
      totalAmountPaid: json["total_amount_paid"] != null
          ? num.tryParse(json["total_amount_paid"].toString())
          : null,
      paymentMethod: json["payment_method"],
      orderNumber: json["order_number"],

      // QUOTE
      serviceItemQuoted: json["service_item_quoted"],
      quoteAmount: json["quote_amount"] != null
          ? num.tryParse(json["quote_amount"].toString())
          : null,
      quoteDate: json["quote_date"],
      vendorCompanyName: json["vendor_company_name"],
      validUntilDate: json["valid_until_date"],
      contactInfo: json["contact_info"],
      quoteReferenceNumber: json["quote_reference_number"],

      // MANUAL
      title: json["title"],
      brandCompany: json["brand_company"],
      itemId: json["item_id"],
      modelNumber: json["model_number"],
      manualType: json["manual_type"],
      publicationDate: json["publication_date"],

      // OTHER
      otherTitle: json["other_title"],
      otherBrandCompany: json["other_brand_company"],
      url: json["url"],
      notes: json["notes"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        // "files": files.map((e) => e.toJson()).toList(),
        "added_by": addedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "name": name,
        "brand": brand,
        "warranty_start_date": warrantyStartDate,
        "warranty_end_date": warrantyEndDate,
        "serial_number": serialNumber,
        "service_contact_info": serviceContactInfo,
        "policy_number": policyNumber,
        "provider_name": providerName,
        "coverage_start_date": coverageStartDate,
        "coverage_end_date": coverageEndDate,
        "premium_amount": premiumAmount,
        "claim_contact_info": claimContactInfo,
        "vendor_store_name": vendorStoreName,
        "date_of_purchase": dateOfPurchase,
        "total_amount_paid": totalAmountPaid,
        "payment_method": paymentMethod,
        "order_number": orderNumber,
        "service_item_quoted": serviceItemQuoted,
        "quote_amount": quoteAmount,
        "quote_date": quoteDate,
        "vendor_company_name": vendorCompanyName,
        "valid_until_date": validUntilDate,
        "contact_info": contactInfo,
        "quote_reference_number": quoteReferenceNumber,
        "title": title,
        "brand_company": brandCompany,
        "item_id": itemId,
        "model_number": modelNumber,
        "manual_type": manualType,
        "publication_date": publicationDate,
        "other_title": otherTitle,
        "other_brand_company": otherBrandCompany,
        "url": url,
        "notes": notes,
      };
}
