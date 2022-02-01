import sublime
import sublime_plugin
import re

class GdbBreakpointCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    match = re.compile("^.*\/([^\/]*)$").match(self.view.file_name())
    if match:
      name = match.group(1);
      line = self.view.rowcol(self.view.sel()[0].begin())[0] + 1
      sublime.set_clipboard("br " + name + ":" + str(line));
