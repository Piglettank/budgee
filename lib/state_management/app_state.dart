enum AppState {
  normal,
  chooseAction,
  enterInfo;

  bool get isNormal => this == normal;
  bool get isChooseAction => this == chooseAction;
  bool get isEnterIncome => this == enterInfo;
}
