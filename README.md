# Buddha

A dark Omarchy theme in saffron, ink, and still water. The palette is warm brown and gold. Seven wallpapers sit behind it, from a rainy forest meditation to a night lake under the moon.

![Buddha theme picker preview](preview.png)

`preview.png` is the image the theme switcher loads. It is 1800×1012, the same frame as the bundled Omarchy theme previews, composed from `backgrounds/1-meditation.png` and `colors.toml`. It is not a photograph of a running desktop.

![All seven Buddha wallpapers](wallpapers.png)

## Install

The repository name `omarchy-buddha-theme` installs as **buddha**.

```bash
omarchy theme install https://github.com/richfeather-cpu/omarchy-buddha-theme.git
```

Omarchy clones that URL into `~/.config/omarchy/themes/buddha` and applies the theme. The same install is under **Install > Style > Theme** in the Omarchy menu (`Super + Alt + Space`).

Switch back to it later with **Style > Theme**, `Super + Ctrl + Shift + Space`, or:

```bash
omarchy theme set buddha
```

Cycle wallpapers with `Super + Ctrl + Space`.

Omarchy builds the terminal, editor, browser, bar, menu, notifications, and lock screen from `colors.toml`. This theme ships that palette and the files below. It does not ship per-app config files, and an installed copy drops anything that would run code (there is none here).

| File | Role |
| --- | --- |
| `colors.toml` | Palette. `mode = "dark"`. |
| `backgrounds/` | Seven wallpapers, in filename order. |
| `screensaver.txt` | Braille Buddha used by the optional screensaver hook. |
| `icons.theme` | `Yaru-wartybrown`, so the file manager follows the earth tones. Delete this file to keep your current icons. |
| `preview.png` | Theme-switcher thumbnail, 1800×1012. Omarchy looks for this name at the repository root. |
| `wallpapers.png` | Contact sheet of the seven wallpapers, for this page. The switcher ignores it. |
| `screensavers/` | Four ASCII pieces, plain and colored. |
| `extras/` | Optional screensaver hook and rotating launcher. |

### Wallpapers

| File | Scene | Size |
| --- | --- | --- |
| `1-meditation.png` | Saffron-robed figure in a rainy dark forest, gold halo, a lantern among the trees | 3840×2160 |
| `2-temple.png` | Bronze figure in a candlelit temple hall | 3840×2160 |
| `3-saffron.png` | Figure seen from behind, facing a lotus pond in warm light | 3840×2160 |
| `4-lotus.png` | Lotus bloom and leaves on dark water | 1672×941 |
| `5-shrine.png` | Stone shrine gate, autumn maples, still water | 1672×941 |
| `6-sumie.png` | Ink-wash figure under a branch, red seal | 1672×941 |
| `7-cosmos.png` | Figure on a lotus above a night lake, moon and mountains | 1672×941 |

### Palette

| Role | Hex |
| --- | --- |
| background | `#2a1f17` |
| foreground | `#f5e6c8` |
| accent | `#f5a623` |
| selection | `#5a3d22` |
| muted | `#b89968` |

The neutral ramp runs from `darker_background` `#1a110d` up to `bright_foreground` `#fff4d8`.

## Screensaver

Omarchy draws its screensaver from one global file, `~/.config/omarchy/branding/screensaver.txt`, and animates that file with ttfx. Applying a theme does not change it. `screensaver.txt` in this repository is ready for that file: a Braille Buddha with a golden halo, the same drawing as `screensavers/01_golden_halo.txt`.

To use it once, without the hook:

```bash
cp ~/.config/omarchy/themes/buddha/screensaver.txt ~/.config/omarchy/branding/screensaver.txt
```

That replaces whatever art is there today. The optional extra below remembers the previous art and puts it back when you leave the theme.

### Optional rotating screensaver

Omarchy will not run a theme's scripts at install time, and a cloned theme cannot install a hook for you. `extras/install.sh` does that job when you run it. From the installed theme:

```bash
~/.config/omarchy/themes/buddha/extras/install.sh
```

What it changes:

- Copies a hook to `~/.config/omarchy/hooks/theme-set.d/buddha-screensaver`. On `omarchy theme set buddha` the hook saves your current branding screensaver and installs the Buddha art. Switching to any other theme restores the saved file. If you edit the branding file while Buddha is the active theme, the hook leaves your edit in place when you switch away.
- Symlinks `~/.local/bin/omarchy-buddha-screensaver` to the launcher in this theme. The launcher reads `screensavers/*.ansi.txt` inside the theme directory.

If Buddha is already the current theme, the script applies the art immediately and tells you it remembered the previous file. Otherwise it waits for the next switch to Buddha.

```bash
extras/install.sh --no-apply   # hook and launcher only
extras/install.sh --apply      # also install the art now
extras/install.sh --force      # replace a hook or launcher that is not this one
```

`omarchy-buddha-screensaver` plays the four colored pieces in a loop: golden halo, bodhi moon, enso over still water, and amber temple. Shuffle is the default. ttfx, which ships with Omarchy, does the animation. The idle screensaver keeps using the single branding file. Run the launcher in a terminal when you want the four pieces to take turns.

```bash
omarchy-buddha-screensaver
BUDDHA_SCREENSAVER_MODE=ordered omarchy-buddha-screensaver
BUDDHA_SCREENSAVER_FPS=30 omarchy-buddha-screensaver
```

Press Ctrl-C to stop it. Any key still dismisses Omarchy's own screensaver.

Remove the extra before you remove the theme, so the hook can restore your previous art:

```bash
~/.config/omarchy/themes/buddha/extras/uninstall.sh
omarchy theme remove buddha
```

`uninstall.sh` restores the branding screensaver when this extra still owns it, then deletes the hook, the path note next to it, and the launcher symlink. `--force` removes those paths even if something else is using the same names.

If the theme directory is already gone, the leftovers are:

```bash
rm -f ~/.config/omarchy/hooks/theme-set.d/buddha-screensaver
rm -f ~/.config/omarchy/hooks/theme-set.d/buddha-screensaver.path
rm -f ~/.local/bin/omarchy-buddha-screensaver
```

A backup of your previous art, when the hook still holds one, is `~/.local/state/omarchy/buddha-screensaver/previous.txt`.

The plain `.txt` files in `screensavers/` can replace the root `screensaver.txt` if you want the idle screensaver to show a different piece. Copy one over `screensaver.txt`, then run `omarchy theme set buddha` again so the hook picks it up.

## Remove the theme

**Remove > Style > Theme**, or:

```bash
omarchy theme remove buddha
```

Run `extras/uninstall.sh` first when you installed the optional screensaver.

## Listing

Two different images, in two different places.

The theme switcher, and galleries that read the repository, use `preview.png` at the root of this repo. `omarchy-theme-switcher` checks these root filenames, in order: `preview.png`, `preview.jpg`, `preview.jpeg`, `preview.webp`, `preview.gif`, `preview.bmp`, then a short list of video extensions. The first match wins. This repo ships `preview.png`.

[omarchy.org/themes](https://omarchy.org/themes/) does not read that file. Listings are a pull request to [omacom-io/omarchy-site](https://github.com/omacom-io/omarchy-site). The screenshot in that pull request has to be a real desktop, so it is not in this repository:

1. Apply the theme (`omarchy theme set buddha`) and take one 16:9 shot of a live session.
2. Include a terminal and an editor. Use one of these wallpapers. `1-meditation.png` is the 4K image.
3. Leave out the pointer, notifications, and anything personal. Do not upscale a small capture.
4. Convert it and add it to the site repository:

```bash
magick buddha-desktop.png -strip -resize '1200>' -quality 80 assets/themes/buddha.webp
```

Aim for about 1200×675 and under about 100KB. In `themes/index.html`, add the figure in alphabetical order. On the current page that is between Blue Ridge Dark and Castle on a Lake. Both links point at `https://github.com/richfeather-cpu/omarchy-buddha-theme`.

[omarchythemes.dev](https://omarchythemes.dev/docs/publishing) reads `colors.toml` and `preview.png` from this repository and imports the screenshot from the official listing. It does not ask for another filename here.

## Credits

Wallpapers generated with ChatGPT for this theme. The Braille and ANSI art was made for this theme.

Rich Feather, [richfeather-cpu](https://github.com/richfeather-cpu), 2026.

## License

[MIT](LICENSE). Copyright (c) 2026 Rich Feather.

The MIT license covers this whole repository: `colors.toml`, the scripts, the ASCII art, `preview.png`, `wallpapers.png`, and the wallpapers in `backgrounds/`.
