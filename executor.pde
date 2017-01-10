interface command {
  void execute();
}

interface executor {
  void issue(command command_);
}
