
enum Result {
  SUCCESS(100, "Success."),
  FAILED(101, "Failed."),
  USER_EXIST(140, "User exist"),
  USER_NOT_EXIST(141, "User is not exist"),
  COMPANY_NOT_EXIST(142, "Company is not exist"),
  COMPANY_EXIST(143, "Company is exist"),
  BRANCH_NOT_EXIST(144, "Branch is not exist"),
  BRANCH_EXIST(145, "Branch is exist"),
  POSTER_EXIST(146, "Poster is exist"),
  POSTER_NOT_EXIST(147, "Poster is not exist"),
  POSTER_COMMENT_NOT_EXIST(148, "Poster comment is not exist"),
  POSTER_COMMENT_EXIST(149, "Poster comment is exist"),
  POSTER_FEEDBACK_EXIST(150, "Poster feedback is exist"),
  POSTER_FEEDBACK_NOT_EXIST(151, "Poster feedback is not exist"),
  PROMOTION_EXIST(152, "Promotion is exist"),
  PROMOTION_NOT_EXIST(153, "Promotion is not exist"),
  USER_PASSWORD_NOT_MATCHED(154, "Password is not matched!"),
  NOT_FOUND(155, "Not found!"),
  FOUND(156, "Found!"),
  TOKEN_INVALID(200, "Invalid token information."),
  TOKEN_EXPIRED_TIME(201, "This token is expired."),
  TOKEN_UNSUPPORTED_JWT(202, "Unsupported token information."),
  LOGIN_INVALID_TOKEN(250, "Token information cannot be verified."),
  LOGIN_DUPLICATE(251, "Duplicate login."),
  LOGIN(252, "Please log in first."),
  LOGIN_INACTIVE(253, "Please log in first."),
  LOGIN_BANNED(254, "User is banned. Access denied."),
  PASSWORD_IS_NOT_MATCHED(255, "Password is not matched"),
  AUTHENTICATION_ERROR(300, "Your authentication information cannot be verified."),
  INTERNAL_ERROR(301, "Something went wrong on our end. We're working to fix it."),
  SERVER_ERROR(302, "A system error has occurred. Please contact your administrator."),
  TOKEN_EMPTY(360, "Empty token");

  final int code;
  final String message;

  const Result(this.code, this.message);

  static Result? fromCode(int code) {
    for (var result in Result.values) {
      if (result.code == code) {
        return result;
      }
    }
    return null;
  }

  String get codeAsString => code.toString();
}