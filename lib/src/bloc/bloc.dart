import 'package:rxdart/rxdart.dart';
import '../network/network_request.dart';

enum LoadingState { NONE, LOADING, LOADED_SUCESS }

class VerificationBloc {
  NetworkRequest _networkRequest;
  String backgroundNetworkColor;
  VerificationBloc(NetworkRequest networkRequest) {
    this._networkRequest = networkRequest;
  }

  final isLoading = BehaviorSubject<LoadingState>.seeded(LoadingState.NONE);
  Stream<LoadingState> get loadingStatus => isLoading.stream;

  Future<void> verifyUser() async {
    isLoading.add(LoadingState.LOADING);
    try {
       backgroundNetworkColor = await _networkRequest.verifyToken();
      isLoading.add(LoadingState.LOADED_SUCESS);
    } catch (e) {
      isLoading.addError(e);
    }
  }
}
