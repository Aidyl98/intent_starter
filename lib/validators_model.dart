class ValidatorModel<T> {
  bool Function(T key) validator;
  String errorMsg;

  ValidatorModel(this.validator, this.errorMsg);

  bool validate(key) => validator(key);
}
