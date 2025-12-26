import 'dart:core';

class ApiConstants {
  static String baseUrl = "https://k10swf0g-6000.inc1.devtunnels.ms/api/v1";

  static String signup = "/auth/create-user";
  static String login = "/auth/login";

  static String fetchUserData = "/user/me";
  static String productSupport = "/user/support";

  static String updateProfile = "/user/update_profile";
  static String updatePassword = "/auth/update-password";

  static String fetchHomeMember = "/home-share/my-home-member";

  static String updateHomeData = "/user/update_home_data";
  static String homeTaskData = "/task/home-task-data";
  static String homeHealthData = "/task/home-health";

  static String fetchScheduleData = "/task/get-users-added-task";
  static String assignNewMember = "/task/assign_member_to_a_task";

  static String createTask = "/task/add_task";
  static String fetchTask = "/task/get_users_task";
  static String fetchTaskDetails = "/task/task_details/";
  static String markTaskComplete = "/task/mark_as_done_or_ignore";
  static String changeScheduleDate = "/task/change-task-time/";

  static String addProvider = "/provider/";
  static String fetchProviders = "/provider/";
  static String updateProvider = "/provider/";
  static String followProvider = "/provider/toogle-follow";

  static String addDocument = "/document";
  static String fetchDocument = "/document/all?type=";
  static String fetchDocumentDetails = "/document/";
  // static String updateDocument = "/document/details/name";

  static String addRoom = "/view-by-room/add";
  static String fetchAllRoom = "/view-by-room/all";
  static String fetchRoomType = "/view-by-room/all-type";
  static String fetchRoomDetails = "/view-by-room";
  static String fetchRoomItem = "/view-by-room/available-item/";
  static String addUserRoomItem = "/view-by-room/add-item";
  static String updateUserRoomItem = "/view-by-room/update-user-item-details/";
  static String deleteUserRoomItem =
      "/view-by-room/delete-user-room-item-details/";

  static String viewByType = "/view-by-type/";
  static String applianceTypes = "/view-by-type/appliance/";
  static String addNewAppliance = "/view-by-type/add-new-user-appliance";
  static String updateAppliance =
      "/view-by-type/update-user-appliance-details/";

  static String fetchUserRoomItems =
      "/view-by-room/user-room-single-item-data/";

  static String getAiResponse = "/ai/get-message";
  static String postAiResponse = "/ai/get-response";

  static String addMaterial = "/view-by-type/add-new-user-material";

  static String joinHome = "/home-share/join-home";
  static String inviteHomeMember = "/home-share/send-invite";
  static String removeMember = "/home-share/remove-me-from-home-member";
  static String fetchAssignedHomeMember =
      "/task/only-home-members-assigned-task";
  static String taskNotification = "/task/task_notification";
  static String markNotificationAsRead = "/task/mark_as_done_or_ignore";
}
