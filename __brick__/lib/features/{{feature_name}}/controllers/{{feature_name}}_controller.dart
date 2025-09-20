import 'package:flutter/material.dart';
import '../repositories/{{feature_name}}_repo.dart';

class {{feature_name.pascalCase()}}Controller  extends ChangeNotifier{
  // TODO: Implement controller logic for {{feature_name}}

  final {{feature_name.pascalCase()}}Repository _{{feature_name.camelCase()}}Repo =
      {{feature_name.pascalCase()}}Repository();
}