class SingUpCollectedData {
  String? userId;
  String? homeType;
  String? homeAddress;
  List<String>? homePowerType;
  List<String>? homeWaterSupplyType;
  List<String>? homeHeatingType;
  String? homeHeatingPower;
  String? houseRole;
  List<String>? homeCoolingType;
  List<String>? responsibleFor;
  List<String>? wantToTrack;
  LastServiceData? lastServiceData;

  SingUpCollectedData({
    this.userId,
    this.homeType,
    this.homeAddress,
    this.homePowerType,
    this.homeWaterSupplyType,
    this.homeHeatingType,
    this.homeHeatingPower,
    this.homeCoolingType,
    this.responsibleFor,
    this.wantToTrack,
    this.lastServiceData,
    this.houseRole,
  });

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "home_type": homeType,
        "home_address": homeAddress,
        "home_power_type": homePowerType,
        "home_water_supply_type": homeWaterSupplyType,
        "home_heating_type": homeHeatingType,
        "home_heating_power": homeHeatingPower,
        "home_role": houseRole,
        "home_cooling_type": homeCoolingType,
        "responsible_for": responsibleFor,
        "want_to_track": wantToTrack,
        "last_service_data": lastServiceData?.toJson(),
      };
}

class LastServiceData {
  String? type;
  String? lastService;
  String? note;

  LastServiceData({this.type, this.lastService, this.note});

  Map<String, dynamic> toJson() => {
        "type": type,
        "lastservice": lastService,
        "note": note,
      };
}
