import sublime, sublime_plugin

class ChrSrc(sublime_plugin.TextCommand):
    def run(self, edit):
        for region in self.view.sel():
            if not region.empty():
                s = self.view.substr(region);
                search = "https://cs.chromium.org/search/?q=%s&sq=package:chromium&type=cs" % s

    def is_enabled(self):
        for region in self.view.sel():
            if not region.empty():
                return True
        return False
