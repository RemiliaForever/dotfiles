// Chromium builds its MPRIS bus name from a format string baked into the Electron
// binary -- "org.mpris.MediaPlayer2.chromium.instance%i" -- so every Electron app
// announces itself as "chromium" and playerctl, waybar and the like cannot tell one
// from another. Everything else about the exported player is already correct
// (Identity comes from the Electron app name), so this rewrites just the name on its
// way into libdbus, which Electron links dynamically.
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>

static const char chromium_prefix[] = "org.mpris.MediaPlayer2.chromium";

int dbus_bus_request_name(void *connection, const char *name, unsigned int flags, void *error) {
  static int (*next_request_name)(void *, const char *, unsigned int, void *);
  if (!next_request_name) {
    next_request_name = dlsym(RTLD_NEXT, "dbus_bus_request_name");
  }

  // The ".instance<pid>" suffix is kept: playerctl strips it off when reporting a
  // player's name, and leaving it in place keeps a second copy of the app working.
  char renamed[256];
  if (strncmp(name, chromium_prefix, sizeof chromium_prefix - 1) == 0) {
    snprintf(renamed, sizeof renamed, "org.mpris.MediaPlayer2.qqmusic%s",
             name + sizeof chromium_prefix - 1);
    name = renamed;
  }

  return next_request_name(connection, name, flags, error);
}
