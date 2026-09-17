import 'package:equatable/equatable.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/domain/models/customer_contact.dart';
import 'package:stringer/domain/models/debtor.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object?> get props => [];
}

/// No file has been imported yet.
class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial();
}

class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading();
}

/// The file was read successfully but contains no records.
class HomeScreenEmpty extends HomeScreenState {
  final String fileName;

  const HomeScreenEmpty({required this.fileName});

  @override
  List<Object?> get props => [fileName];
}

class HomeScreenError extends HomeScreenState {
  final FailureType failureType;

  const HomeScreenError({required this.failureType});

  @override
  List<Object?> get props => [failureType];
}

class HomeScreenLoaded extends HomeScreenState {
  final String fileName;
  final List<Debtor> debtors;
  final Map<String, CustomerContact> contactsByPib;
  final Set<String> selectedPibs;
  final bool isSending;

  /// pib -> null on success, or the failure (with details) on error.
  final Map<String, Failure?> sendResults;

  const HomeScreenLoaded({
    required this.fileName,
    required this.debtors,
    required this.contactsByPib,
    this.selectedPibs = const {},
    this.isSending = false,
    this.sendResults = const {},
  });

  HomeScreenLoaded copyWith({
    List<Debtor>? debtors,
    Map<String, CustomerContact>? contactsByPib,
    Set<String>? selectedPibs,
    bool? isSending,
    Map<String, Failure?>? sendResults,
  }) {
    return HomeScreenLoaded(
      fileName: fileName,
      debtors: debtors ?? this.debtors,
      contactsByPib: contactsByPib ?? this.contactsByPib,
      selectedPibs: selectedPibs ?? this.selectedPibs,
      isSending: isSending ?? this.isSending,
      sendResults: sendResults ?? this.sendResults,
    );
  }

  @override
  List<Object?> get props => [
    fileName,
    debtors,
    contactsByPib,
    selectedPibs,
    isSending,
    sendResults,
  ];
}
