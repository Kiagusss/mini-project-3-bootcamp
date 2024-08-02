import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit() : super(const DocumentState());

  /// Upload Document Method
  Future<void> uploadDocument({required String path, required String fileName}) async {
    final documentRef = FirebaseStorage.instance.ref().child('documents').child(fileName);

    try {
      emit(const DocumentState(isLoading: true));

      final uploadTask = documentRef.putFile(File(path));

      uploadTask.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            final progress = 100 * (event.bytesTransferred / event.totalBytes);
            emit(
              DocumentState(
                isLoading: true,
                uploadProgress: progress / 100,
              ),
            );
            break;
          case TaskState.success:
            event.ref.getDownloadURL().then(
              (value) {
                emit(
                  DocumentState(
                    isLoading: false,
                    linkDokumen: value,
                    fileName: fileName,
                  ),
                );
              },
            );
            break;
          default:
            break;
        }
      });

      await uploadTask;
    } catch (e) {
      emit(DocumentState(errorMessage: e.toString()));
    }
  }

  /// Replace Document Method
  Future<void> replaceDocument({required String path, required String fileName}) async {
    await deleteDocument();
    await uploadDocument(path: path, fileName: fileName);
  }

  /// Delete Document Method
  Future<void> deleteDocument() async {
    if (state.linkDokumen == null) return;

    try {
      final documentRef = FirebaseStorage.instance.refFromURL(state.linkDokumen!);
      await documentRef.delete();
      emit(const DocumentState());
    } catch (e) {
      emit(DocumentState(errorMessage: e.toString()));
    }
  }
}
