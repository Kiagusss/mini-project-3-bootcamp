part of 'document_cubit.dart';

class DocumentState extends Equatable {
  final String? linkDokumen;
  final bool isLoading;
  final double uploadProgress;
  final String errorMessage;
  final String? fileName;

  const DocumentState({
    this.linkDokumen,
    this.isLoading = false,
    this.uploadProgress = 0,
    this.errorMessage = "",
    this.fileName,
  });

  @override
  List<Object?> get props =>
      [linkDokumen, isLoading, uploadProgress, errorMessage, fileName];
}
