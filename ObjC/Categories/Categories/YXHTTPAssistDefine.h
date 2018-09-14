
#ifndef YXHTTPAssistDefine_h
#define YXHTTPAssistDefine_h

#define DEVELOP_ENVIRONMENT 1

#if DEVELOP_ENVIRONMENT
#define URL_SERVER    @"http://cs.app-creator-backend.arhieason.com"
#define URL_SERVER_H5 @""
#else
#define URL_SERVER    @""
#define URL_SERVER_H5 @""
#endif

#define STATUS_SUCCESS @"success"
#define STATUS_ERROR   @"error"

#define PAGE_SIZE 20

#define URL_USER_LOGIN  @"/api/user/login"
#define URL_USER_LOGOUT @"/api/user/logout"

#endif
