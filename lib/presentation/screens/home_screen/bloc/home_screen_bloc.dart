import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stringer/core/error/app_exception.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/domain/contacts/get_contacts_usecase.dart';
import 'package:stringer/domain/contacts/save_contact_usecase.dart';
import 'package:stringer/domain/email/send_payment_reminder_usecase.dart';
import 'package:stringer/domain/home_screen/import_debtors_usecase.dart';
import 'package:stringer/domain/models/customer_contact.dart';

import 'home_screen_event.dart';
import 'home_screen_state.dart';

@injectable
class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ImportDebtorsUseCase _importDebtorsUseCase;
  final GetContactsUseCase _getContactsUseCase;
  final SaveContactUseCase _saveContactUseCase;
  final SendPaymentReminderUseCase _sendPaymentReminderUseCase;

  HomeScreenBloc(
    this._importDebtorsUseCase,
    this._getContactsUseCase,
    this._saveContactUseCase,
    this._sendPaymentReminderUseCase,
  ) : super(const HomeScreenInitial()) {
    on<HomeScreenExcelFileSelected>(_onExcelFileSelected);
    on<HomeScreenFileCleared>(_onFileCleared);
    on<HomeScreenContactSaved>(_onContactSaved);
    on<HomeScreenRecipientSelectionToggled>(_onRecipientSelectionToggled);
    on<HomeScreenSendRemindersRequested>(_onSendRemindersRequested);
  }

  Future<void> _onExcelFileSelected(
    HomeScreenExcelFileSelected event,
    Emitter<HomeScreenState> emit,
  ) async {
    emit(const HomeScreenLoading());

    try {
      final debtors = await _importDebtorsUseCase(event.filePath);

      if (debtors.isEmpty) {
        emit(HomeScreenEmpty(fileName: event.fileName));
        return;
      }

      final contacts = await _getContactsUseCase();
      final contactsByPib = {for (final c in contacts) c.pib: c};

      // Customers who owe something float to the top instead of being
      // mixed in with the rest of the list.
      final sortedDebtors = [...debtors]
        ..sort((a, b) {
          if (a.hasOutstandingDebt != b.hasOutstandingDebt) {
            return a.hasOutstandingDebt ? -1 : 1;
          }
          return b.totalOverdue.compareTo(a.totalOverdue);
        });

      // Pre-select customers who owe something and already have an email
      // on file; the user can still uncheck individual rows.
      final defaultSelection = sortedDebtors
          .where(
            (d) => d.hasOutstandingDebt && contactsByPib.containsKey(d.pib),
          )
          .map((d) => d.pib)
          .toSet();

      emit(
        HomeScreenLoaded(
          fileName: event.fileName,
          debtors: sortedDebtors,
          contactsByPib: contactsByPib,
          selectedPibs: defaultSelection,
        ),
      );
    } on AppException catch (exception) {
      emit(HomeScreenError(failureType: exception.failure.type));
    } catch (_) {
      emit(const HomeScreenError(failureType: FailureType.fileReadError));
    }
  }

  void _onFileCleared(
    HomeScreenFileCleared event,
    Emitter<HomeScreenState> emit,
  ) {
    emit(const HomeScreenInitial());
  }

  Future<void> _onContactSaved(
    HomeScreenContactSaved event,
    Emitter<HomeScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeScreenLoaded) return;

    await _saveContactUseCase(event.contact);

    final updatedContacts = Map<String, CustomerContact>.from(
      currentState.contactsByPib,
    )..[event.contact.pib] = event.contact;

    final debtor = currentState.debtors.firstWhere(
      (d) => d.pib == event.contact.pib,
    );
    final updatedSelection = Set<String>.from(currentState.selectedPibs);
    if (debtor.hasOutstandingDebt) {
      updatedSelection.add(event.contact.pib);
    }

    emit(
      currentState.copyWith(
        contactsByPib: updatedContacts,
        selectedPibs: updatedSelection,
      ),
    );
  }

  void _onRecipientSelectionToggled(
    HomeScreenRecipientSelectionToggled event,
    Emitter<HomeScreenState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeScreenLoaded) return;

    final updatedSelection = Set<String>.from(currentState.selectedPibs);
    if (!updatedSelection.remove(event.pib)) {
      updatedSelection.add(event.pib);
    }

    emit(currentState.copyWith(selectedPibs: updatedSelection));
  }

  Future<void> _onSendRemindersRequested(
    HomeScreenSendRemindersRequested event,
    Emitter<HomeScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeScreenLoaded ||
        currentState.selectedPibs.isEmpty) {
      return;
    }

    emit(currentState.copyWith(isSending: true));

    final results = <String, Failure?>{};
    for (final pib in currentState.selectedPibs) {
      final debtor = currentState.debtors.firstWhere((d) => d.pib == pib);
      final contact = currentState.contactsByPib[pib];
      if (contact == null) continue;

      try {
        await _sendPaymentReminderUseCase(debtor: debtor, contact: contact);
        results[pib] = null;
      } on AppException catch (exception) {
        results[pib] = exception.failure;
      } catch (e) {
        results[pib] = Failure(FailureType.sendFailed, details: e.toString());
      }
    }

    emit(
      currentState.copyWith(
        isSending: false,
        sendResults: results,
        selectedPibs: const {},
      ),
    );
  }
}
