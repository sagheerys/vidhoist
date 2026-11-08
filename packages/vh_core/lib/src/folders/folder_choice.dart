import '../urls/server_path.dart';

/// A folder chosen in a picker. An empty [path] is the top of the
/// downloads, unless [channelName] says "named after the channel", which
/// is known only once the channel's link is resolved.
class FolderChoice {
  const FolderChoice(this.path, {this.channelName = false});

  static const top = FolderChoice('');
  static const channel = FolderChoice('', channelName: true);

  final String path;
  final bool channelName;

  bool get isTop => path.isEmpty && !channelName;
}

/// **Every folder a picker can offer**: the folders the library's clips sit
/// in, with each one's parents. In tree order, a parent before what is
/// inside it.
List<String> pickableFolders(Iterable<String> fromLibrary) {
  final all = <String>{};
  void add(String path) {
    final parts = ServerPath.cleanFolder(path).split('/');
    for (var i = 1; i <= parts.length; i++) {
      final prefix = parts.take(i).join('/');
      if (prefix.isNotEmpty) all.add(prefix);
    }
  }

  fromLibrary.forEach(add);
  int byTree(String a, String b) {
    final x = a.toLowerCase().split('/');
    final y = b.toLowerCase().split('/');
    for (var i = 0; i < x.length && i < y.length; i++) {
      final c = x[i].compareTo(y[i]);
      if (c != 0) return c;
    }
    return x.length.compareTo(y.length);
  }

  return all.toList()..sort(byTree);
}

/// **A folder named after a channel**: the name is one folder, so a slash
/// in it ("AC/DC") is not read as nesting.
String channelFolderName(String name) =>
    ServerPath.cleanFolder(name.replaceAll(RegExp(r'[/\\]'), '-'));
