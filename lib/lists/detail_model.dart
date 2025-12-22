
class DetailModel {
  String  First ;
  String Second;

  DetailModel({
    required this.First,required this.Second
});
}

List<DetailModel> detail = [
  DetailModel(First: 'Name :', Second: 'Robert'),
  DetailModel(First: 'Email :', Second: 'robert12@gmail.com'),
  DetailModel(First: 'Position :', Second: 'Creative head'),
  DetailModel(First: 'Date :', Second: '11 - 11 - 2024'),
  DetailModel(First: 'Start timing :', Second: '4 : 50AM'),
  DetailModel(First: 'Last Timing :', Second: '8 : 30AM'),

];


class ManageDetails {
  String  First ;
  String Second;

  ManageDetails({
    required this.First,required this.Second
  });
}

List<ManageDetails> manageetails = [
  ManageDetails(First: 'Name :', Second: 'Robert J'),
  ManageDetails(First: 'Date :', Second: '27 - 11 - 2024'),
  ManageDetails(First: 'Time :', Second: '4 : 50AM'),
  ManageDetails(First: 'Leave Days :', Second: '8 Days'),

];