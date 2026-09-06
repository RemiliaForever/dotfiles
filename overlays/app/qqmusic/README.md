# QQMusic

Tencent's Linux client, repackaged to run on `electron_43` instead of the
Electron 8 it ships with. A current Chromium renders the variable CJK fonts NixOS
ships, so the client is no longer full of tofu boxes.

Everything here is a downstream patch against a binary release. Nothing in this
directory contains upstream code: the patches are line diffs against a tree that
only exists inside the build sandbox.

## Build pipeline

`default.nix` builds the app in one derivation, in this order:

1. `asar extract` the official `app.asar`, then copy `app.asar.unpacked` over it.
2. Unpack `@electron/remote` into `node_modules` (Electron dropped the built-in
   `remote` module in 14; see patch 0001).
3. `extract-sources.js`, run by the official binary as plain node.
4. `prettier` over `app/*.js`. `main.js` ships as one 1.1MB line, which no patch
   could describe. It also makes the installed sources readable.
5. `webpack-eval.js unwrap` -- explode the renderer modules into real files.
6. Apply `patches` in order.
7. `webpack-eval.js rewrap` -- fold the modules back into their `eval()` literals.

The outer derivation symlinks the app, copies the icons, and wraps `electron_43`.
Because step 3 runs the official x86_64 binary, the build cannot cross.

## Helper scripts

### `extract-sources.js`

Some resources in the official `app.asar` are not stored as plain text, and the
build has the shipped binary produce the plain form itself rather than trusting a
copy from anywhere else. The app never starts: no window, no request, no login.

Each result is sampled for printable characters and the build fails below 90% --
a file that came back wrong would sail through every patch and only surface as a
blank window.

Runs under the bundled Node 12: CommonJS only, no optional chaining.

### `webpack-eval.js`

The bundle was built with `devtool: eval`, so every module's source is a string
argument to `eval()` -- one enormous line. `prettier` cannot reach inside it, so
a patch could only ever replace the whole line, which would put a megabyte of
upstream code in this repository for the sake of a ten-line change.

`unwrap` writes each literal out as `modules/<bundle>/<module-id>.js`; `rewrap`
folds them back. The filename comes from the module id webpack registered the
wrapper under, so patch paths are stable across builds.

Folding back cannot re-derive the bundler's own escaping -- it spells some tabs
`\t` and one `>` as `\x3e` -- so it does not try:

- a module the patches left alone keeps its **original literal, byte for byte**;
- a module that changed is escaped afresh, then decoded again to check the round
  trip. A mismatch fails the build.

This is why `rewrapped 594 modules, N changed` is worth reading in the build log:
`N` should equal the number of renderer modules the series actually touches.

Also Node 12 inside.

### `mpris-name.c`

Chromium builds its MPRIS bus name from a format string baked into the Electron
binary -- `org.mpris.MediaPlayer2.chromium.instance%i` -- so every Electron app
announces itself as `chromium`, and playerctl, waybar and the like cannot tell
one from another. Nothing else about the exported player is wrong: `Identity`
already follows the Electron app name.

So this is a two-function `LD_PRELOAD` shim over `dbus_bus_request_name`, which
Electron links dynamically. Any name starting with the chromium prefix is
rewritten to `org.mpris.MediaPlayer2.qqmusic`, keeping the `.instance<pid>`
suffix -- playerctl strips that when reporting a player's name, and leaving it
alone keeps a second copy of the app working.

Wired in as `--set LD_PRELOAD` on the wrapper, compiled with `runCommandCC`.

Caveat: the variable is set rather than dropped once libdbus is bound, so every
process the client spawns inherits it. Harmless for anything that does not claim
an MPRIS name, but a Chromium-based browser opened for an external link would
also be renamed to `qqmusic`.

## The patch series

Named in the imperative, like `git format-patch`. **Order matters**: each is
generated against the tree the previous ones produced, so they must be applied
in sequence and regenerated in sequence.

The series is layered: runtime, then privacy, then policy, then upstream bug
fixes, then one change that is a judgement call, then behaviour changes and
features built on those foundations. Related changes are kept together, and
more invasive changes come later so a failure there leaves everything before it
applied.

### `0001-use-current-electron` -- 20 files

The floor. Three Electron API changes between 8 and 43 each break the app
outright:

- **`remote`**, removed in Electron 14. Seven bundles each carry their own
  `require("electron")` external module; all become
  `{ ...require("electron"), remote: require("@electron/remote") }`. `main.js`
  initialises `@electron/remote/main` and enables it per window.
- **`contextIsolation`**, default flipped to true in Electron 12. Restored to
  false on `BrowserWindow` `webPreferences` and on `<webview>`, or every bridge
  between preload and page is severed. The `<webview>` half also needs
  `nodeintegration`, and it has to be repeated **eleven times**: the webview
  component is module `69458`, and webpack copied it into every lazy page chunk
  that uses it rather than hoisting it. Patch one copy and only that one page
  works; see the note on duplicated modules under *Verifying a change*. All
  eleven were then checked on a running client over CDP -- the ten host routes
  (`musicroom`, `recommend`, `video`, `singer_detail`, `song_detail`,
  `album_detail`, `category_detail`, `toplist_detail`, `mv_set` and the `*`
  fallback that `category_tags` lands on) plus the `common_dialog` window -- each
  mounting a `<webview>` carrying both attributes, rendering real content, and
  reporting `process` and `require` as defined inside the guest.
- **Cookie `sameSite`**. Electron 8's `cookies.set` was effectively
  `no_restriction`; 43 defaults to `lax`, which drops the login cookies on
  cross-site API requests. Four `cookies.set` calls now say so explicitly.

### `0002-stop-logging-credentials` -- 4 files, 13 hunks

The client prints the user's account tokens to stdout, from the request builders
in `app/main.js` and `common/32590.js`, from four token-refresh failure paths in
`main.js` and `common/68010.js`, from `login/70313.js`, and from two raw
exception dumps. Payloads dropped, messages kept.

Verified with planted markers rather than real credentials: 139 log lines down to
13, no marker surviving.

### `0003-hide-ads-in-webviews` -- `app/main.js`, `app/preload.js`

`onBeforeRequest` cancels the ad delivery host; `webFrame.insertCSS` hides the
promo carousel and **its skeleton**, which would otherwise sit on the page for
ever once that host is blocked. Also hides the 手机专享 tab, a page of phone
screenshots that only appears here because the tab is gated on a client version
string that reads `electron`, so every check is false and the fallback tab wins.

### `0004-skip-update-check` -- `common/74700.js`

Early return with `NotUpdateStrategy`. Otherwise the client offers a dialog and
downloads a `.deb`, none of which can work here.

### `0005-fix-lyric-offset` -- `index/8437.js`, `lyric/8437.js`

A lyric with no `[offset:]` tag makes `parseInt(undefined)` return `NaN`, so
`playTime2ms(tag) - NaN` turns **every timestamp** into `NaN` and the lyric never
highlights. `|| 0`.

Module `8437` is duplicated too -- once for the main window, once for the
detached lyric window -- so both copies get it, or the desktop lyric keeps the
bug the main window no longer has.

### `0006-fix-media-session-handlers` -- `349/35229.js`

- The `previoustrack` handler called `playNext()`. It was copy-pasted from the
  `nexttrack` handler directly above -- the two bodies are byte-identical, which
  is why this patch's anchor has to include the `'previoustrack'` string to be
  locatable at all.
- `clearPlayList()` reset the list, `currentSong` and `index` but left
  `navigator.mediaSession.metadata`, so the desktop widget kept showing whatever
  played last after the queue was emptied. Its one caller is the queue's delete
  button, so nulling the metadata there does not affect track switching.

### `0007-play-songs-whose-artist-has-no-page` -- `349/32698.js`

`isSongAvailable`'s third gate tested `song.singer[0].mid` -- the **artist's**
mid, that is, whether the artist has a page of their own. That says nothing about
the song, yet such songs were refused with 「暂不支持播放」 regardless. Now it
tests `song.track?.mid || song.mid`, which is what `generateVKey` actually needs.

### `0008-persist-the-play-list` -- 5 files

The play list, its order and the play mode never survived a restart, for two
independent reasons.

`LocalDatabaseManager` opens its nedb store at
`path.join(__dirname, 'music_playlist.db')`. That filename never names a file:
webpack resolves `nedb` to `browser-version/browser-specific/lib/storage.js`, so
the collection lives in localforage, under that string as its key, in the
IndexedDB database called `NeDB`. What breaks is that `__dirname` is the bundle's
own directory -- a store path whose hash changes on every rebuild. So each new
build opened a key nothing had ever written and came up empty, leaving the
previous build's list orphaned under its own path. Confirmed on a running client:
`nedbdata` held twenty-four `/nix/store/<hash>-qqmusic-app-1.1.8/music_playlist.db`
keys, one per build ever run, plus two from the upstream `.asar` layout. The store
moves to `app.getPath('userData')`, which is stable across rebuilds. The renderer
reaches `app` through `@electron/remote`, already wired into module `58933` by
patch 0001; the `external_electron_` import is declared further down the file than
the block that now needs it, so it moves up to where webpack would have hoisted
it.

That alone is not enough. Node 24 -- Electron 43 ships 24.18 -- removed the
legacy type predicates, and the bundled nedb still calls `util.isDate` and
`util.isRegExp`, so every insert threw before reaching storage. Module `31669`
is `require("util")`, so it hands those two back, spread over the real module.
`isArray` is the only one of the nine still present and nothing else in the
bundle calls any of them; the spread drops no members and leaves
`inspect.custom`, `promisify.custom` and `inherits` intact. As with patch 0001's
`58933`, `31669` is defined in four of the top-level bundles and all four are
patched, since every window loads `index.js`.

One limit this does not lift: `savePlayList()` has a single caller, `playAll()`,
so the persisted `index` is wherever the list was started from, not the track
playing when the client closed. Restoring lands on the former -- until `0019`,
which keeps the song and the second separately.

### `0009-reuse-the-audio-element` -- `349/35229.js`

`initAudio()` has two callers: the player UI on mount, and `play()` whenever
`isReady()` is false. `isReady()` is `state !== NOT_READY`, and `state` only
leaves `NOT_READY` on the element's first `canplay`, which cannot happen before
something sets a `src`. So every `play()` between mount and first playback built
another `<audio autoplay>` and appended it to the document, orphaning the earlier
ones -- three elements in `body`, two empty, on a running client.

Records the first attempt's promise in `audioReady` and hands it back on
re-entry. Returning the promise rather than returning early matters: a `play()`
racing the mount would otherwise continue past an `initAudio()` that has not yet
finished `await this.cdnUtil.init()`. The method body moves to `buildAudio()`
unchanged, which is why that half of the diff is a single signature line.

Memoising the promise means memoising a rejection too, and `buildAudio()` has
exactly one way to reject: `await this.cdnUtil.init()`, whose `ufetch` rejects
outright when the CGI does not answer. One network blip at startup therefore used
to wedge playback for the whole session -- every later `play()` threw at
`await this.initAudio()`, with `cdns` still the constructor's `[]` -- where
before this patch the next `play()` would have retried (leaking another element,
but recovering). So `init()` now treats no answer like the error answer it
already falls back for, which is also the honest fix: a transient CGI failure
should never have been fatal. That is what keeps the memo safe to hold.

### `0010-fix-cdn-failover` -- `349/35229.js`

```js
checkIsAvailable(mid) {
  return (this.songBadCdnStore.get(mid)?.errCount || 0) >= this.cdns.length * 2;
}
```

reports the **opposite of its name**: it is true once the song has burnt its
retry budget. It was tested unnegated, so on the first error (`errCount === 0`)
the handler gave up immediately -- and `errCount` only grows inside
`addDisabledCdn`, which only runs in the branch that could never be entered.
`songBadCdnStore` therefore stayed empty for ever, `getAvailableCdn` always
returned `cdns[0]`, and **the whole failover mechanism was dead code**. One
transient network fault lost the song.

The handler also ended with an **unconditional** `playNext(false, 0)` outside
both branches, so the give-up path skipped twice and reset the skip counter.
Removing it is safe: `sortedCdnList` returns `this.cdns`, which the constructor
initialises to `[]` (truthy), so the outer guard reduces to `this.audio.src` --
meaning that call only ever fired on a spurious error with no source, where
skipping is wrong, or right after the branches had already acted.

Negated, the retry is bounded: two hosts, a budget of four errors,
`getAvailableCdn` rotating between them and clearing the bad set when it fills.

The same error handler now preserves `currentTime` across a CDN retry. It seeks
on `loadedmetadata`, the earliest point an audio element accepts a seek, so a
network blip no longer sends a listener back to the beginning of the song.

### `0011-bound-track-advance` -- `349/35229.js`, 7 sites

Two bugs of one type: advance logic with no terminating condition.

**Sequential mode repeated the last song for ever.** The index step is
`index < len - 1 ? index + 1 : index`, deliberately holding at the end -- but
`ended` calls `playNext(true)`, the index does not move, `isSongAvailable`
passes, and `play({index})` replays the same song. A stop now sits in the `auto`
block beside the existing `SINGLE_CYCLE` special case.

It calls `this.pause()` rather than returning bare. Whether Blink fires `pause`
before `ended` is an implementation detail; the explicit call is correct either
way. It cannot be left to `setState(ENDED)`, because the play button is driven by
`playState === PLAYING` and `playState` only subscribes to the PLAYING and PAUSED
events.

The stop excludes radio mode, and that exclusion is load-bearing. 猜你喜欢 is
radio 99, served five songs at a time: the 推荐 page's play button sends
`radioCmd {cmd: 1}`, which reaches `RadioPlayer._playRadioData` and starts
playback as `PLAYER_MODE.RADIO` -- and `playAll` leaves the play mode alone when
it is already SEQUENTIAL, so a radio plays *as* a sequential list. Refilling the
batch hangs off `onPlayIdxWillStep`, which `playNext` fires only after this block:
`RadioPlayer._handlePlayerIdxStep` watches for `prevIdx === length - 1 && step ===
1`, holds the step with `setAllowPlayIdxStep(false)`, fetches the next five and
restarts at index 0. Stopping before the event stranded every radio after one
batch. `LIST_CYCLE` was never affected -- it wraps to 0 and fires the event
anyway -- which is why this only ever showed up in sequential play.

**`badSongNumber` was dropped.** It is `playNext`/`playPrev`'s only recursion
bound (`if (badSongNumber >= this.playList.length) return`), and upstream loses
it in two places: `play()`'s refusal branch calls `playNext()`/`playPrev()` with
no argument, and the error handler calls `playNext(false, 0)`. It is now threaded
through `play()`'s config and both `play(…, {…})` calls; the error path gets a
`failedSongNumber` field instead, reset in the `playing` listener, since a song
that actually plays breaks the chain.

### `0012-play-songs-with-contradictory-rights` -- `349/32698.js`

`action.play` is the OR of four bits out of the server's 24-bit `switch`, and
`disabled` derives from it -- greying the row, cutting the context menu down to
删除, and blocking row selection.

A small number of songs carry rights data that contradicts itself: those four
bits clear while the download and cache bits for the same qualities are set. The
row was greyed on the strength of the four alone. The test is widened to every
bit in the same group, so a song with none of them still greys and the row, its
menu and the selection keep telling the truth.

**This is the only patch resting on a reading of the data rather than a plain
defect**, which is why it stands alone: if the pattern does not hold for another
account or another catalogue, one line reverts it.

### `0013-explain-refusals-instead-of-skipping` -- `349/32698.js`, `349/35229.js`

`isSongAvailable` knew how to explain a refusal -- `copyRight === '1'` opens
`showDisableFrame`, otherwise `showMsg` renders whatever the server's `alertid`
and `msgid` say. But when the local check passed and the server declined,
`play()` fell into the auto-advance branch: a 「已自动为您切换下一首」 toast and a
jump to a different song, even for an explicit click.

That explanation is now `explainUnavailable` (exported as `"eu"`), called from
`play()`'s refusal branch when `showDisableDialog` is set. `play()` defaults its
config to `{ showDisableDialog: true, up: true }` and only `playNext` and
`playPrev` override it with `false`, so a manual click explains and stays put
while auto-advance stays quiet and skips.

With 0012 in place `disabled === 1` is reachable again, so `explainUnavailable`
has two real callers and the extraction is deduplication rather than a move.

### `0014-pick-audio-quality` -- 4 files

The one new feature, though it starts from a defect: `generateVKey` hardcoded a
single lowest-quality filename, so a Linux client received 128kbps mp3 however
good the account or the song.

- `62384.js` exports `AUDIO_FORMATS`, best first, each entry a filename prefix,
  an extension, where to find the song's size for that format, and a tag: `MQ`,
  `PQ`, `SQ`, `HQ`, 标准. Adds a `quality` setting, defaulting to `SQ`, and
  `setInitialSettingValue`. Also exports `formatSizeOf`,
  because the two tiers this client predates have no size field of their own --
  their `size` is a numeric index into `file.size_new` instead of a field name.
  Formats this Chromium cannot decode are deliberately absent, which is why
  `size_ape`, `size_dts` and 杜比全景声 do not appear: the last is E-AC-3, and
  `canPlayType` for it is `""` here. 臻品音质 is absent for a different reason --
  its files are simply not reachable from this client.
- `35229.js`: `generateVKey` walks the chain down from the configured format,
  skipping a level when the song's size for it is `0` (an **absent** size means
  nothing, since this client predates some formats, so it still asks) and when
  the server declines. Records `playingFormat`. New `reloadCurrentSong()`
  re-resolves the song that is playing rather than only the next one, restoring
  its position -- the element cannot seek until it has metadata for the new
  stream, hence the one-shot `loadedmetadata` listener.
- `47998.js`: a quality pill beside the play-mode control, reusing the play-mode
  popover's markup so the two match. Each format shows its size, spelled the way
  the client spells sizes in its song list, and formats the song lacks are
  dimmed. `SQ` and `HQ` take the client's own colours (`#f60`, and the skin's
  `#1ecc94`); 标准 has no tag in the client at all, so it follows the theme's
  text colour and keeps tracking the light and dark skins. `MQ` takes `#e5b046`
  from the client's own unused `.icon_hi_res` sprite; `PQ` has no colour in the
  client, so `#4aa3ff` is a choice.
- `57224.js`: the song row shows one badge, the best format the song has. The
  skin has sprites for `SQ`, `HQ` and 5.1 only, so a tier above them gets a text
  pill in the picker's colour, 13px tall with a 4px right margin to sit in the
  same row. Below them the stock chain decides, and it is left byte for byte
  alone: the new check simply returns before it. A tier the song's data does not
  mention is not claimed on the row, though `generateVKey` still asks for it.

`PQ` sits above `SQ` rather than below it. Neither of the two new tiers contains
the other and neither is contained by `SQ`, so some fall-through is unavoidable
whatever the order; this way an `MQ` pick can fall to `PQ`, where the other
arrangement would drop a `PQ` pick past `SQ` to a lossy mp3.

The default stays `SQ`. `MQ` is roughly three times the bytes of `SQ` for the
same track and `PQ` is six-channel audio that Chromium downmixes to stereo,
which is generally worse than the stereo master unless there is real surround
output -- neither is a sensible thing to start pulling unasked.

### `0015-open-other-peoples-playlists` -- `common/54128.js`

Appended after the fact, when opening any playlist that was not in the sidebar
turned out to show an empty page.

`jump(PAGE_TYPE.PLAYLIST)` matches the id against the two sidebar lists first,
and a playlist found in either is pushed as `/playlist_detail/<tid>`. Anything
else -- so anyone else's playlist, reached from search or a recommendation --
fell through to a branch that built a `y.qq.com/#/playlist_detail?id=<id>` url
and pushed it as a query parameter on the bare path. But the page takes its id
from the path, so `match.params.tid` was undefined, `parseInt` made it `NaN`,
and the CGI answered code 10004 with an empty songlist. Nothing threw: the page
just rendered no detail header and "this playlist has no songs".

The fix pushes `/playlist_detail/<id>`, which is what the same client already
does when that identical url shape arrives from a webview -- `TogglePage` in
`common/4095.js` pulls the id out of it before pushing. The two sidebar
branches are untouched, which is why self-created and collected playlists were
never affected and still behave exactly as before.

### `0016-keep-loading-until-the-playlist-arrives` -- `index/767.js`

Opening a playlist flashed "this playlist has no songs", and then -- once that
was fixed by rendering nothing instead -- went blank for as long as the request
took.

`usePlayListInfo` starts with `isLoading` false and `songlist` `[]`, and both of
its effects run *after* the first render, so the first frame took the not-loading
path with an empty list. `detailContent` is null until a response has actually
been handled, which is the condition this uses instead.

What it renders while waiting matters as much as the condition. Three animations
are in play on this page:

- `QQMusicLoading` (`349/4694.js`, export `.Z`) -- the spinning icon plus
  "正在加载中". The lazy route shows it via `LoadingComponent` (`.N`) while the
  chunk resolves, at `height: 100%`.
- `PlayListDetailLoading` (`index/767.js`, the local `loading`) -- a full
  skeleton of the header, tabs and twenty song rows. The `isLoading` branch draws
  it, and stock never got there, so it had never once been seen.
- nothing at all, which is what the first attempt here did.

The chunk resolves almost immediately (`767` is already in the index bundle), so
the icon appears for a frame or two; the CGI request is the part that takes
hundreds of milliseconds. Drawing the skeleton in that window reads as two
different animations in a row, and drawing nothing reads as the animation
finishing early and the page hanging blank. So it renders `QQMusicLoading`
itself, same export and same height as the route's, and the one animation simply
continues until the songs replace it.

`4694` lives in chunk `349`, which `index.html` loads before `index.js`, so the
cross-chunk require is safe -- `47998` does the same thing.

`detailContent` joins the `useMemo` dependencies so the swap also happens for a
playlist that really is empty.

Worth knowing if this area is touched again: `_isLoading` in that hook is a plain
`let` in the hook body, so it is re-created on every render and cannot guard
across renders. It happens to work -- both effects of a single render share the
one closure, so the second is suppressed -- which is also why `isLoading` never
becomes true on a cold open and the skeleton never appears. Left alone.

### `0017-drop-the-dead-screensaver-watcher` -- `app/main.js`

On `ready`, Linux builds ran `child_process.exec` on a shell pipeline that fed
`dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'"` into a
`while read` loop, and destroyed and re-created the tray icon whenever it saw an
unlock. Two things are wrong with it here.

Nothing owns `org.gnome.ScreenSaver` on this session bus -- niri provides
`org.freedesktop.ScreenSaver` -- and the name is not activatable either, so the
signal never arrived and the tray was never rebuilt. Meanwhile nothing ever
killed the pipeline: three processes per run (the `sh`, `dbus-monitor`, and the
`sh` on the right of the pipe), and since `dbus-monitor` only writes on a lock
or unlock it never got the write error that would have told it the parent was
gone. They accumulated one set per launch, reparented to `systemd --user`.

They also inherited the main process's file descriptors. One of those was the
`--remote-debugging-port` listening socket, so after the app exited the port
stayed in `LISTEN` on a dead instance -- accepting connections that nothing would
ever answer -- and could not be reused until the leftovers were killed by hand.
That is worth knowing before blaming a debugging session on something else.

Removing it outright rather than reaping it on `will-quit`: the feature does
nothing on this machine, so there is no behaviour to preserve. If this is ever
run on GNOME, the tray may need rebuilding after an unlock again, and the right
fix then is a watcher on the name that session actually has.

### `0018-prime-the-media-session` -- `349/35229.js`

Restoring the play list (`0008`) puts the last song back in `currentSong`, but
nothing tells the desktop about it: `setMediaSession()` is only called from the
audio element's `playing` handler. So on a fresh start `playerctl` and the waybar
module saw no player at all until the user pressed play, and
`navigator.mediaSession`'s action handlers -- which `Player`'s constructor does
register at startup -- had nothing to be attached to.

Setting the metadata earlier is not enough. On Linux, Chromium's MPRIS service is
driven by `SystemMediaControlsNotifier`, which follows the *active* media session,
and a session only becomes active by requesting audio focus -- which happens when
something actually plays. Assigning `navigator.mediaSession.metadata` does not
request focus, so before any playback there is no session for the notifier to
follow and the bus name is not even taken.

The session therefore has to be opened with a real track, and it has to be long
enough: Chromium classifies media shorter than five seconds as transient content
(a UI sound), which takes ducking focus and never reaches the system controls.
`silentTrackUrl()` builds 30 seconds of 8 kHz 8-bit mono silence -- 240 kB, a
blob URL, no asset in the bundle, which matters because `rewrap` cannot add
webpack modules. `primeMediaSession()` plays it on a throwaway hidden element,
pauses it the moment `play()` resolves, and then publishes the restored song.

A separate element, not the player's own, deliberately: the player's element
carries the `playing`/`pause` listeners that drive `state`, the IPC to the lyric
window and `playStatusChange`, so priming through it would have flashed the whole
UI into "playing" and back. The media session is per-document, not per-element,
so a silent element that is merely paused keeps the session alive while the real
element joins it later.

Four details hang off that:

- 8-bit PCM samples are unsigned, so silence is `0x80`. A fresh `ArrayBuffer` is
  `0x00`, which is full deflection -- inaudible while it holds, but it clicks on
  the edges.
- `navigator.mediaSession.playbackState` is deliberately left alone. A state the
  page declares wins over the players' own for as long as it stands, so setting
  it to `'paused'` here would have reported Paused over the song that later
  really plays. The primer is genuinely paused, so Chromium derives the same
  answer by itself.
- `setPositionState()` overrides the position Chromium would derive from the
  playing element, so without it the widget would report the silent track's
  `0:00/0:30` as the song's length. It is cleared again in `dropPrimer()`.
- `dropPrimer()` runs from the real element's `playing` handler, once the real
  player has joined the session -- not earlier, or the session would briefly have
  no players and the MPRIS entry would blink out. `clearPlayList()` drops it too,
  so emptying the queue takes the widget's entry with it instead of leaving a
  titleless one behind.

`resume()` gained a branch for the same reason. Its first line handles
`state === PAUSED`; with nothing ever loaded the state is `NOT_READY`, and a
`resume()` with no argument fell through the whole method and did nothing -- so
the widget's play button, and the primed session, would have been decoration.
It now starts the restored play list at `index`.

Unverified statically: whether Electron 43 lets the primer autoplay without a
gesture (the player's own element already relies on the same policy, via its
`autoplay` attribute), and whether a paused player is enough to hold the session
open. Both need `playerctl -p qqmusic metadata` on a freshly started client that
has not played anything.

### `0019-restore-playback-state` -- `349/35229.js`, `349/40292.js`, `index/47998.js`

`0008` brought the play list, its order and the play mode back, and stopped
there: a restart put the queue back but landed on whichever song the list was
started from, at zero seconds. Four separate things were in the way.

**Nothing recorded the song, and nothing recorded the second.**
`savePlayList()` runs from `playAll()`, once per queue, so the `index` it stores
is where that queue was begun. The position was never stored at all. It does not
belong in that record either: nedb's browser build rewrites the whole collection
on every update -- a hundred songs of JSON -- and the position moves several
times a second. So it lives in `localStorage` instead, as `play_position`, one
object of `{id, index, position}` written from the `playing` and `pause`
handlers and about once a second from `timeupdate`. That store is synchronous,
which is what makes it survive a quit that leaves the renderer no time to write
anything, and it belongs to the profile rather than to the build, so it survives
a rebuild for the same reason the nedb store `0008` relocated does. The `id` is
the point of it: the saved position is used only while it still describes the
list that came back with it, and any other list starts where its own `index`
says.

What it records is `audio.ended ? 0 : currentTime`, because a stopped sequential
list ends in a `pause()` (`0011`) that would otherwise store the last song's full
duration, and pressing play on a song restored at its own end does nothing anyone
can see.

**The restore was a race.** The play bar takes the song it shows, its duration
and the queue from whatever `initAudio()` resolves to, and `LocalDatabaseManager`
handed its result back through a callback nothing could wait for -- it dropped
the callback entirely when the collection had nothing to say, which makes
"nothing stored" indistinguishable from "not read yet". So the restore ran
against the CGI request in `cdnUtil.init()`, and only usually won. It now always
calls back, `getLocalPlayerData()` is a promise the constructor keeps, and
`buildAudio()` awaits it before returning. What it returns grew a `position` and
a `mode` for the same reason.

**Restoring the mode threw the restore away.** `setMode()` reshuffles for
`RANDOM` and resets `index` to 0, which is right when the user picks the mode and
wrong when the mode is merely being read back: the stored play list is already
the shuffled one. The restore assigns `mode` directly. The play bar's mode
control reads `LogicalPlayer.mode` in a `useState`, at mount, which is before any
of this has happened -- so it spent every cold start showing the default -- and
now takes it from `initData` like everything else.

**`currentSong` came from the wrong list.** `songList[index]`, where `index`
indexes `playList`. The two differ in random mode.

With that in place the seek itself is small: `play()` starts the restored song at
the restored position, once, through a one-shot `loadedmetadata` listener, and
only for the song identity the restore recorded -- anything else the user starts
instead begins at the beginning, and clears it. `primeMediaSession` reports the
same position to the desktop widget, bounded by the song's own duration, since
`setPositionState` throws past the end and the two numbers come from different
places.

It deliberately does not start playing. The client is launched at login here, and
a restored position is not a reason to make noise.

The same restore also keeps radio playback alive. 猜你喜欢 is radio 99, served
a batch at a time and played *as* a sequential list (see `0011`). Its
`playerMode` and radio id are persisted alongside the queue, and
`adoptRestoredRadio()` rebuilds the `RadioPlayer` just before the list steps.
That prevents the sequential end-of-list stop from pausing a restored radio,
and gives `_handlePlayerIdxStep` the `radioData` it needs to fetch the next
batch. The normal queue leaves `radioId` undefined, so it is not mistaken for a
radio. The new `__webpack_require__(40292)` closes a cycle with `35229`; neither
module touches the other while it is evaluated, and both already live in chunk
`349`.

### `0020-quit-when-the-window-closes` -- `app/main.js`

Two window factories sit next to each other in `main.js`: one destroys its
window on `close`, the other calls `preventDefault()` and hides it. The second is
what the main window, the desktop lyric and the visual player are built with,
which left the app with no way out.

- The titlebar's ✕ sends `window_message`/`close` for `MAIN_WINDOW`, so it hid
  the window and left the process running with nothing on screen.
- The application menu's 退出 calls `app.quit()`, and quitting means closing every
  window: each one refused, and the quit was cancelled. It had never worked.
- The tray's 退出QQ音乐 and the settings popup's 退出QQ音乐 got out only because
  they called `app.exit(0)` instead.

Now the main window *is* the app: closing it quits. The others keep hiding,
except while the app is on its way out -- `before-quit` sets `app.isQuitting`,
and a prevented close during a quit would cancel it. The quit has to be explicit
rather than left to `window-all-closed`, which does fire on Linux: the desktop
lyric window is created five seconds after start and merely hidden, so closing
the main window never empties the set.

The two `app.exit(0)` paths become `app.quit()`. `0019` keeps the play position
in `localStorage`, whose last second or so is still in Chromium's commit queue
when the process is shot in the head.

The tray stays, and clicking it still hides and shows the window -- which is now
what hiding is for.

## Rebasing onto a new upstream release

1. Bump the version and hash in nixpkgs' `qqmusic` (this overlay takes it as
   `official`), then build. Failures come out as `patch` rejects naming the file
   and hunk.
2. To work on a tree by hand, reproduce steps 1-5 of the pipeline, then apply
   patches `0001..N-1` to get the tree patch `N` was generated against.
3. Regenerate a patch by diffing minimal trees, so the header paths stay `a/`
   and `b/` and no timestamps leak in:

   ```sh
   diff -ruN mkA mkB | sed -E \
     's|^(diff -ruN )mkA/(.*) mkB/(.*)$|\1a/\2 b/\3|;
      s|^--- mkA/([^\t]+)\t.*$|--- a/\1|;
      s|^\+\+\+ mkB/([^\t]+)\t.*$|+++ b/\1|'
   ```

4. Anything downstream of the patch you changed has to be regenerated too, in
   order, if its line numbers moved.

Two shapes to keep in mind when editing:

- Renderer module paths are `modules/<bundle>/<module-id>.js`. The ids are
  webpack's and are stable within a release but not across releases.
- The code is Babel output, so an anchor often has to include the whole
  `a === null || a === void 0 ? void 0 : a.b` chain, and a temporary like
  `_song$singer$` is declared at the top of its function -- renaming what it
  reads means changing that declaration too.

## Verifying a change

- Every patch should apply with **no fuzz and no offset**. Both appear in the
  build log; either one means the patch no longer describes the tree it was
  generated against and should be regenerated.
- `rewrapped 594 modules, N changed` -- `N` must match the number of renderer
  modules the series touches: 25 as it stands. A larger `N` means something
  reformatted a module it did not mean to.
- Unwrap the built bundle again and diff it against the patched source tree; it
  must be byte-identical.
- `node --check` on every top-level bundle a patch touched.
- **Check for duplicated modules.** webpack copies a shared module into every
  chunk that imports it, so `modules/<chunk>/<id>.js` may exist under several
  chunks and a patch that names one path leaves the rest stock. For every module
  id a patch touches, list `modules/*/<id>.js` and require the copies to be
  identical afterwards. This has bitten twice: `69458` (11 copies) and `8437`
  (2 copies).
- When reorganising the series without meaning to change behaviour, diff the
  final tree against the previous final tree and require every differing line to
  be a comment.

The client can be inspected live with `--remote-debugging-port`. Use a throwaway
`--user-data-dir`, and note that its log prints account tokens, so filter
anything you read out of it. The windows are created with `devTools: false`,
which also keeps their targets out of `/json/list`, so that port answers
`/json/version` and nothing else until that option is patched out.
