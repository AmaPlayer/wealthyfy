abstract class Routes {
  Routes(_);
  static const WELCOME = _Path.WELCOME;
  static const LOGIN = _Path.LOGIN;
  static const SIGNUP = _Path.SIGNUP;
  static const DASHBOARD = _Path.DASHBOARD;
  static const PROFILESTATE = _Path.PROFILESTATE;
  static const SELLBUYSTATE = _Path.SELLBUYSTATE;
  static const ADDFUNDSTATE = _Path.ADDFUNDSTATE;
  static const WITHDRAWDEPOSITSTATE = _Path.WITHDRAWDEPOSITSTATE;
  static const KYCSTATE = _Path.KYCSTATE;
  static const EDITPROFILEDETAILSTATE = _Path.EDITPROFILEDETAILSTATE;
  static const GRAPHSTATE = _Path.GRAPHSTATE;
  static const OPTIONCHAINSTATE = _Path.OPTIONCHAINSTATE;


}
abstract class _Path {
  _Path(_);
  static const WELCOME = "/Welcome";
  static const LOGIN = "/Login";
  static const SIGNUP = "/Signup";
  static const DASHBOARD = "/Dashboard";
  static const PROFILESTATE = "/ProfileState";
  static const SELLBUYSTATE = "/SellBuyState";
  static const ADDFUNDSTATE = "/AddFundState";
  static const WITHDRAWDEPOSITSTATE = "/WithdrawDepositHistory";
  static const KYCSTATE = "/kycSate";
  static const EDITPROFILEDETAILSTATE = "/EditProfileDetailSate";
  static const GRAPHSTATE = "/GraphSate";
  static const OPTIONCHAINSTATE = "/OptionChainSate";


}
