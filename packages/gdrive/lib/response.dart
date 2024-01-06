class FileResponse<T>{
  final String fileId;
  final T response;

  const FileResponse(this.fileId, this.response);
}