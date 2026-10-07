import 'package:equatable/equatable.dart';
import 'package:stringer/domain/models/customer_contact.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object?> get props => [];
}

class HomeScreenExcelFileSelected extends HomeScreenEvent {
  final List<String> filePaths;
  final List<String> fileNames;

  const HomeScreenExcelFileSelected({
    required this.filePaths,
    required this.fileNames,
  });

  @override
  List<Object?> get props => [filePaths, fileNames];
}

class HomeScreenFileCleared extends HomeScreenEvent {
  const HomeScreenFileCleared();
}

class HomeScreenContactSaved extends HomeScreenEvent {
  final CustomerContact contact;

  const HomeScreenContactSaved(this.contact);

  @override
  List<Object?> get props => [contact];
}

class HomeScreenRecipientSelectionToggled extends HomeScreenEvent {
  final String pib;

  const HomeScreenRecipientSelectionToggled(this.pib);

  @override
  List<Object?> get props => [pib];
}

class HomeScreenSendRemindersRequested extends HomeScreenEvent {
  const HomeScreenSendRemindersRequested();
}
