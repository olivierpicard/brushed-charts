import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/grapherExtension/centered_text.dart';
import 'package:labelling/fragment/struct.dart';

class NoDataFragment implements FragmentContract {
  @override
  var subgraph = FragmentStruct(
      visualisation: CenteredText('There is no data to display'));
}
