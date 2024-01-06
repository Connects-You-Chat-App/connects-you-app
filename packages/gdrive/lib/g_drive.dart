import 'package:gdrive/response.dart';
import 'package:http_wrapper/http.dart';

class GDrive {
  static const Http _uploadHttp = Http(
      baseURL: 'https://www.googleapis.com/upload/drive/v3',
      shouldThrowError: false);
  static const Http _readHttp = Http(
      baseURL: 'https://www.googleapis.com/drive/v3', shouldThrowError: false);

  static const String _mimeType = 'application/json';

  static const String _driveAppDescText = 'Your Connects_You appdata';
  static const String _driveBoundaryText = 'Connects_You';

  static String _createMultiPartBody(
      String fileName, String body, bool isUpdate) {
    final Map<String, dynamic> metaData = {
      'name': fileName,
      'description': GDrive._driveAppDescText,
      'mimeType': 'application/json',
      'parents': "['appDataFolder']",
    };
    final multipartBody =
        '\r\n--${GDrive._driveBoundaryText}\r\nContent-Type: ${GDrive._mimeType}; charset=UTF-8\r\n\r\n{"name": "${metaData['name']}", "description": "${metaData["description"]}", ${isUpdate ? '' : '"parents": ${metaData["parents"]},'} "mimeType": "${metaData["mimeType"]}"}\r\n--${GDrive._driveBoundaryText}\r\nContent-Type: ${GDrive._mimeType}\r\n\r\n$body\r\n--${GDrive._driveBoundaryText}--';
    return multipartBody;
  }

  static Map<String, String> _configurePostOrPatchHeaders(
      String bodyLength, String accessToken) {
    final Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $accessToken';
    headers['Content-Type'] =
        'multipart/related; boundary=${GDrive._driveBoundaryText}';
    headers['Content-Length'] = bodyLength;
    return headers;
  }

  static Map<String, String> _configureGetHeaders(String accessToken) {
    final Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $accessToken';
    return headers;
  }

  static Future<Map<String, dynamic>?> _getFile(
      String fileName, String accessToken) async {
    final qParams = Uri.encodeComponent("name = '$fileName'");
    final options = _configureGetHeaders(accessToken);
    final value = await _readHttp.get(
      endpoint: '/files?q=$qParams&spaces=appDataFolder',
      headers: options,
    );
    if (value.decodedBody != null &&
        value.decodedBody.containsKey('files') &&
        value.decodedBody['files'].length > 0) {
      return value.decodedBody['files'][0] as Map<String, dynamic>;
    }
    return null;
  }

  static Future<String> readFileContent(String fileId, String accessToken) {
    return _readHttp.get(endpoint: '/files/$fileId?alt=media', headers: {
      'Authorization': 'Bearer $accessToken',
    }).then((value) => value.decodedBody as String);
  }

  static Future<FileResponse> writeFileContent(
      String fileName, String content, String accessToken,
      [String existingFileId = '']) async {
    final isUpdate = existingFileId.isNotEmpty;
    final body = _createMultiPartBody(fileName, content, isUpdate);
    final options =
        _configurePostOrPatchHeaders(body.length.toString(), accessToken);
    final method = isUpdate ? _uploadHttp.patch : _uploadHttp.post;
    final response = await method(
        endpoint:
            '/files${existingFileId.isNotEmpty ? '/$existingFileId' : ''}?uploadType=multipart',
        body: body,
        headers: options);
    return FileResponse(response.decodedBody['id'], response);
  }

  static Future<FileResponse> getFileAndWriteFileContent(
      String fileName, String content, String accessToken) async {
    final file = await _getFile(fileName, accessToken);
    if (file != null) {
      return writeFileContent(fileName, content, accessToken, file['id']);
    }
    return writeFileContent(fileName, content, accessToken);
  }

  static Future<FileResponse<String>> getFileAndReadFileContent(
      String fileName, String accessToken) async {
    final file = await _getFile(fileName, accessToken);
    if (file == null) {
      throw Exception('file null');
    }
    return FileResponse(
        file['id'], await readFileContent(file['id'], accessToken));
  }
}