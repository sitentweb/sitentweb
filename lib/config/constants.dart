import 'package:flutter/material.dart';

var kDarkColor = Color(0xff004d40);
var kLightColor = Color(0xff00796b);

// ASSETS SETTING
var application_logo = 'assets/logo/logo.png';
var application_name = 'Remark';

// DYNAMIC LINKS

var dynamic_base = 'remarkhrapp.page.link';
var dynamic_job = dynamic_base + '/job';

// API Urls

const String base_url = 'https://apimanager.remarkhr.com';

//SMS GATEWAY GLOBAL 91
// const String smsBaseUrl = 'http://www.global91sms.in/app/smsapi/index.php';
// const String smsApi = '560D6D3BEA4938';
// const String smsEntity = '1201162326487946387';
// const String smsOTPTempID = '1207162953792805217';
// const String smsSender = 'VISKOR';
// const String smsType = 'text';
// const String smsUnicode = 'no';
// const String routeid = '459';
// // const String smsSenderID = 'VISKOR';

const String smsBaseUrl = 'http://sms.admarksolution.com/sendSMS';
const String smsApi = 'f6819c09-04e8-4af8-81a3-bc82e4884e84';
const String smsUsername = 'viskohrpvtltd@gmail.com';
// const String smsOTPTempID = '1207162953792805217';
const String smsSender = 'VISKOR';
const String smsType = 'TRANS';
// const String smsUnicode = 'no';
// const String routeid = '459';
// const String smsSenderID = 'VISKOR';

// Authentication URLs
const String loginApiUrl = base_url + '/loginApi';
const String getUserByMobileNumberApiUrl = base_url + '/userDetails';
const String removeUserTokenApiUrl = base_url + '/removeUserToken';
const String getDashboardDataApiUrl = base_url + '/getDashBoardDataApi';
const String fetchPostedJobsApiUrl = base_url + '/getPostedJobsApi';
const String fetchAllJobsApiUrl = base_url + '/jobListApi';

//@TODO Change Api url from below
const String fetchAppliedJobsApiUrl = base_url + '/getAppliedJobs';
const String fetchCandidatesApiUrl = base_url + '/getCandidate';
const String fetchCandidateApiUrl = base_url + '/fetchEmployee';
const String getJobApiUrl = base_url + '/getJob';
const String getAllRooms = base_url + '/getRoom';
const String changeRoomStatusApiUrl = base_url + '/changeRoomStatus';
const String getMessages = base_url + '/getMessage';
const String getAllScheduleInterview = base_url + '/getScheduledInterview';
const String sendChatMessageApiUrl = base_url + '/messagetoserver';
const String changeChatMessageStatusApiUrl = base_url + '/messageStatus';
const String getSingleChatRoomApiUrl = base_url + '/getSingleRoom';
const String fetchQuizRoomApiUrl = base_url + '/fetchQuizRoom';
const String updateQuizDataApiUrl = base_url + '/updatequiz';
const String updateEmpQuizDataApiUrl = base_url + '/updateEmpQuiz';
const String startQuizDataApiUrl = base_url + '/updatestartquiz';
const String getQuizDataApiUrl = base_url + '/getQuiz';
const String sendPush = base_url + '/pushFirebase';
const String applyToJobsApiUrl = base_url + '/userapply';
const String saveJobsApiUrl = base_url + '/savejobs';
const String getSimilarJobsApiUrl = base_url + '/getjobSimilarlist';
const String fetchUserDataApiUrl = base_url + '/getUserData';
const String fetchSaveJobsListApiUrl = base_url + '/savejobslist';
const String receiveNotificationApiUrl = base_url + '/receivenotification';
const String fetchCityStateApiUrl = base_url + '/getStatesCities';
const String fetchSearchJobsApiUrl = base_url + '/search';
const String saveCandidateApiUrl = base_url + '/saveProfile';
const String getCandidateByIdApiUrl = base_url + '/getCandidateById';
const String updateNotificationApiUrl = base_url + '/updateNotification';
const String updateAppliedJobStatusApiUrl = base_url + '/appliedjobstatus';
const String getCompanyByIDApiUrl = base_url + '/getCompanyById';
const String hiredCandidatesApiUrl = base_url + '/hiredCandidates';
const String getEducationApiUrl = base_url + '/getEducation';
const String searchCandidateApiUrl = base_url + '/searchCandidates';
const String candidatesForListApiUrl = base_url + '/allCandidates';
const String createQuestionnaireApiUrl = base_url + '/create_quiz';
const String employerQuizRoomApiUrl = base_url + '/fetchEmployerQuiz';
const String quizEmployeesRoomApiUrl = base_url + '/getQuizEmployees';
const String sendQuizApiUrl = base_url + '/sendQuiz';
const String fetchIndustryApiUrl = base_url + '/getIndustry';
const String fetchUserCompaniesApiUrl = base_url + '/fetchcompany';
const String createCompanyApiUrl = base_url + '/createCompany';
const String createJobApiUrl = base_url + '/newJob';
const String updateMobileNumberApiUrl = base_url + '/updateMobileNumber';
const String createInterviewApiUrl = base_url + '/scheduledInterviewApi';
const String interviewResponseApiUrl = base_url + '/setInterviewAgree';
const String createChatRoomApiUrl = base_url + '/createRoom';
const String updateUserDetailsApiUrl = base_url + '/updateUser';
const String employerCompanyApiUrl = base_url + '/companies';
const String resumePath = base_url + '/assets/resumes/';
const String rescheduleInterviewApiUrl = base_url + '/rescheduleInterview';
const String deleteInterviewApiUrl = base_url + '/deleteInterview';
const String fetchSavedCandidatesApiUrl = base_url + '/getSavedProfile';
const String sendInquiryApiUrl = base_url + "/sendInquiry";
