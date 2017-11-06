#!/bin/sh

sed \
		-e 's/_W("Session switcher")/U16_LITERAL_SESSION_SWITCHER/g'        \
		-e 's/_W("Session launcher")/U16_LITERAL_SESSION_LAUNCHER/g'        \
		-e 's/_W("Ctrl+")/U16_LITERAL_CTRL_PLUS/g'                          \
		-e 's/_W("Alt+")/U16_LITERAL_ALT_PLUS/g'                            \
		-e 's/_W("Shift+")/U16_LITERAL_SHIFT_PLUS/g'                        \
		-e 's/_W("◇ None (printing disabled) ◇")/U16_LITERAL_NO_PRINTER/g'  \
		-e 's/_W("◇ None (system sound) ◇")/U16_LITERAL_NO_SOUND/g'         \
		-e 's/_W("◇ None ◇")/U16_LITERAL_NONE2/g'                           \
		-e 's/_W("– None –")/U16_LITERAL_NONE/g'                            \
		-e 's/_W("◆ Default printer ◆")/U16_LITERAL_DEFAULT_PRINTER/g'      \
		-e 's/_W("@ Windows language @")/U16_LITERAL_WINLOC/g'              \
		-e 's/_W("\* Locale environm. \*")/U16_LITERAL_LOCENV/g'            \
		-e 's/_W("= cfg. Text Locale =")/U16_LITERAL_LOCALE/g'              \
		-e 's/_W("downloaded \/ give me a name!")/U16_LITERAL_DOWNLOADED/g' \
		-e 's/_W("X")/U16_LITERAL_X/g'                                      \
		-e 's/_W("▶")/U16_LITERAL_RIGHT_ARROW/g'                            \
		-e 's/_W("◀")/U16_LITERAL_LEFT_ARROW/g'                             \
		-e 's/_W("B\&asic colours:")/U16_LITERAL_BASIC_COLOURS/g'           \
		-e 's/_W("Ne&w")/U16_LITERAL_NEW/g'                                 \
		-e 's/_W("&Copy")/U16_LITERAL_COPY/g'                               \
		-e 's/_W("&Restore")/U16_LITERAL_RESTORE/g'                         \
		-e 's/_W("&Move")/U16_LITERAL_MOVE/g'                               \
		-e 's/_W("&Size")/U16_LITERAL_SIZE/g'                               \
		-e 's/_W("&Paste ")/U16_LITERAL_PASTE/g'                            \
		-e 's/_W("Copy → Paste")/U16_LITERAL_COPY_PASTE/g'                  \
		-e 's/_W("S&earch")/U16_LITERAL_SEARCH/g'                           \
		-e 's/_W("&Log to File")/U16_LITERAL_LOG_TO_FILE/g'                 \
		-e 's/_W("Character &Info")/U16_LITERAL_CHARACTER_INFO/g'           \
		-e 's/_W("&Reset")/U16_LITERAL_RESET/g'                             \
		-e 's/_W("&Default Size")/U16_LITERAL_DEFAULT_SIZE/g'               \
		-e 's/_W("&Full Screen")/U16_LITERAL_FULL_SCREEN/g'                 \
		-e 's/_W("Flip &Screen")/U16_LITERAL_FLIP_SCREEN/g'                 \
		-e 's/_W("Copy &Title")/U16_LITERAL_COPY_TITLE/g'                   \
		-e 's/_W("&Options...")/U16_LITERAL_OPTIONS/g'                      \
		-e 's/_W("Ope&n")/U16_LITERAL_OPEN/g'                               \
		-e 's/_W("Select &All")/U16_LITERAL_SELECT_ALL/g'                   \
		-e 's/_W("Clear Scrollback")/U16_LITERAL_CLEAR_SCROLLBACK/g'        \
		-e 's/_W("Processes are running in session:")/U16_LITERAL_MSG_PRE/g'      \
		-e 's/_W("Close anyway?")/U16_LITERAL_MSG_POST/g'                   \
		-e 's/W("Ctrl+")/U16_LITERAL_CTRL_PLUS/g'                           \
		-e 's/W("Ctrl+Ins")/U16_LITERAL_CTRL_INS/g'                         \
		-e 's/W("Ctrl+Shift+Ins")/U16_LITERAL_CTRL_SHIFT_INS/g'             \
		-e 's/W("Ctrl+Shift+D")/U16_LITERAL_CTRL_SHIFT_D/g'                 \
		-e 's/W("Ctrl+Shift+F")/U16_LITERAL_CTRL_SHIFT_F/g'                 \
		-e 's/W("Ctrl+Shift+H")/U16_LITERAL_CTRL_SHIFT_H/g'                 \
		-e 's/W("Ctrl+Shift+W")/U16_LITERAL_CTRL_SHIFT_W/g'                 \
		-e 's/W("Ctrl+Shift+N")/U16_LITERAL_CTRL_SHIFT_N/g'                 \
		-e 's/W("Ctrl+Shift+C")/U16_LITERAL_CTRL_SHIFT_C/g'                 \
		-e 's/W("Ctrl+Shift+V")/U16_LITERAL_CTRL_SHIFT_V/g'                 \
		-e 's/W("Ctrl+Shift+R")/U16_LITERAL_CTRL_SHIFT_R/g'                 \
		-e 's/W("Ctrl+Shift+S")/U16_LITERAL_CTRL_SHIFT_S/g'                 \
		-e 's/W("Alt+")/U16_LITERAL_ALT_PLUS/g'                             \
		-e 's/W("Shift+")/U16_LITERAL_SHIFT_PLUS/g'                         \
		-e 's/W("Shift+Ins")/U16_LITERAL_SHIFT_INS/g'                       \
		-e 's/W("Alt+F4")/U16_LITERAL_ALT_F4/g'                             \
		-e 's/W("Alt+F3")/U16_LITERAL_ALT_F3/g'                             \
		-e 's/W("Alt+F2")/U16_LITERAL_ALT_F2/g'                             \
		-e 's/W("Alt+F8")/U16_LITERAL_ALT_F8/g'                             \
		-e 's/W("Alt+F10")/U16_LITERAL_ALT_F10/g'                           \
		-e 's/W("Alt+F11")/U16_LITERAL_ALT_F11/g'                           \
		-e 's/W("Alt+F12")/U16_LITERAL_ALT_F12/g'                           \
		-e 's/W("\\t")/U16_LITERAL_T/g'                                     \
		-e 's/\[\] = W("\\n")/[] = U16_LITERAL_NEWLINE_VAR/g'               \
		-e 's/W("\\n")/U16_LITERAL_NEWLINE_CONST/g'                         \
		-e 's/W("BUTTON")/U16_LITERAL_BUTTON/g'                             \
		-e 's/W("")/U16_LITERAL_NULL_STRING/g'                              \
		-e 's/W(" ")/U16_LITERAL_EMPTY_STRING/g'                            \
		-e 's/W("-")/U16_LITERAL_DASH/g'                                    \
		-e 's/W("\\\\\\\\?\\\\")/U16_LITERAL_DOS_BASE/g'                    \
		-e 's/W("\\\\\\\\?\\\\UNC\\\\")/U16_LITERAL_UNC_BASE/g'             \
		-e 's/W("〳〴〵⌠⌡⏐")/U16_LITERAL_INTEGRAL_FAKED/g'                  \
		-e 's/W(".po")/U16_LITERAL_PO/g'                                    \
		-e 's/W("=")/U16_LITERAL_EQUALS/g'                                  \
		-e 's/W("@")/U16_LITERAL_AT/g'                                      \
		-e 's/W("Lucida Console")/U16_LITERAL_LUCIDA_CONSOLE/g'             \
		-e 's/W("DispFileName")/U16_LITERAL_DISPFILENAME/g'                 \
		-e 's/W("\*")/U16_LITERAL_CFG_DEFAULT/g'                            \
		-e 's/W("lang\/\*.po")/U16_LITERAL_LANG_PO/g'                       \
		-e 's/W("sounds\/\*.wav")/U16_LITERAL_SOUNDS/g'                     \
		-e 's/W("themes\/\*")/U16_LITERAL_THEMES/g'                         \
		-e 's/W("@\/@")/U16_LITERAL_CFG_DOWNLOADED/g'                       \
		-e 's/W("Thin")/U16_LITERAL_THIN/g'                                 \
		-e 's/W("Extralight")/U16_LITERAL_EXTRALIGHT/g'                     \
		-e 's/W("Light")/U16_LITERAL_LIGHT/g'                               \
		-e 's/W("Regular")/U16_LITERAL_REGULAR/g'                           \
		-e 's/W("Medium")/U16_LITERAL_MEDIUM/g'                             \
		-e 's/W("Semibold")/U16_LITERAL_SEMIBOLD/g'                         \
		-e 's/W("Bold")/U16_LITERAL_BOLD/g'                                 \
		-e 's/W("Extrabold")/U16_LITERAL_EXTRABOLD/g'                       \
		-e 's/W("Heavy")/U16_LITERAL_HEAVY/g'                               \
		-e 's/W("Ultralight")/U16_LITERAL_ULTRALIGHT/g'                     \
		-e 's/W("Normal")/U16_LITERAL_NORMAL/g'                             \
		-e 's/W("Demibold")/U16_LITERAL_DEMIBOLD/g'                         \
		-e 's/W("Ultrabold")/U16_LITERAL_ULTRABOLD/g'                       \
		-e 's/W("Black")/U16_LITERAL_BLACK/g'                               \
		-e 's/W("Book")/U16_LITERAL_BOOK/g'                                 \
		-e 's/W("Demi")/U16_LITERAL_DEMI/g'                                 \
		-e 's/W("Extrablack")/U16_LITERAL_EXTRABLACK/g'                     \
		-e 's/W("Fat")/U16_LITERAL_FAT/g'                                   \
		-e 's/W("Poster")/U16_LITERAL_POSTER/g'                             \
		-e 's/W("Ultrablack")/U16_LITERAL_ULTRABLACK/g'                     \
		-e 's/W("Oblique")/U16_LITERAL_OBLIQUE/g'                           \
		-e 's/W("0123456789")/U16_LITERAL_0123456789/g'                     \
		-e 's/W("– None –")/U16_LITERAL_NONE/g'                             \
		-e 's/W("lang")/U16_LITERAL_LANG/g'                                 \
		-e 's/W("themes")/U16_LITERAL_THEME/g'                              \
		-e 's/W(".Default")/U16_LITERAL_DEFAULTBEEP/g'                      \
		-e 's/W("SystemHand")/U16_LITERAL_CRITICALSTOP/g'                   \
		-e 's/W("SystemQuestion")/U16_LITERAL_QUESTION/g'                   \
		-e 's/W("SystemExclamation")/U16_LITERAL_EXCLAMATNION/g'            \
		-e 's/W("SystemAsterisk")/U16_LITERAL_ASTERISK/g'                   \
		-e 's/W("data:text\/plain,")/U16_LITERAL_DATA_TEXT_PLAIN/g'         \
		-e 's/W("http:")/U16_LITERAL_HTTP/g'                                \
		-e 's/W("https:")/U16_LITERAL_HTTPS/g'                              \
		-e 's/W("ftp:")/U16_LITERAL_FTP/g'                                  \
		-e 's/W("ftps:")/U16_LITERAL_FTPS/g'                                \
		-e 's/W("themes")/U16_LITERAL_THEME/g'                              \
		-e 's/W("Fraktur")/U16_LITERAL_FRAKTUR/g'                           \
		-e 's/W("Blackletter")/U16_LITERAL_BLACKLETTER/g'                   \
		-e 's/W("info")/U16_LITERAL_INFO/g'                                 \
		-e 's/W("cache")/U16_LITERAL_CACHE/g'                               \
		-e 's/W("data")/U16_LITERAL_DATA/g'                                 \
		-e 's/W("home")/U16_LITERAL_HOME/g'                                 \
		-e 's/W("mnt")/U16_LITERAL_MNT/g'                                   \
		-e 's/W("www\.")/U16_LITERAL_WWW/g'                                 \
		-e 's/W("root")/U16_LITERAL_ROOT/g'                                 \
		-e 's@W("\/mnt/")@U16_LITERAL_MNT_FS@g'                             \
		-e 's@W("\/rootfs")@U16_LITERAL_ROOTFS@g'                           \
		-e 's@W("\/lxss")@U16_LITERAL_LXSS@g'                               \
		-e 's@W("\/cygdrive")@U16_LITERAL_DEV_FS@g'                         \
		-e 's/W("charnames\.txt")/U16_LITERAL_CHARNAMES_TXT/g'              \
		-e 's/W("Static")/U16_LITERAL_STATIC/g'                             \
		-e 's/W(APPNAME)/U16_LITERAL_APP_NAME/g'                            \
		-e 's/W(DIALOG_CLASS)/U16_LITERAL_DIALOG_CLASS/g'                   \
		-e 's/W("http:\/\/ciembor.github.io\/4bit\/")/U16_LITERAL_COLOR_SCHEME_DESIGNER/g' \
		-e 's/W(".wav")/U16_LITERAL_WAV/g'                                  \
		-e 's/W("sounds")/U16_LITERAL_SOUNDS2/g'                            \
		-e 's/W("DistributionName")/U16_LITERAL_DISTRIBUTION_NAME/g'        \
		-e 's/W("BasePath")/U16_LITERAL_BASEPATH/g'                         \
		-e 's/W("PackageFamilyName")/U16_LITERAL_PACKAGE_FAMILY_NAME/g'     \
		-e 's/W("PackageFullName")/U16_LITERAL_PACKAGE_FULL_NAME/g'         \
		-e 's/W("Schemas")/U16_LITERAL_SCHEMAS/g'                           \
		-e 's/W("DefaultDistribution")/U16_LITERAL_DEFAULT_DISTRIBUTION/g'  \
		-e 's/W("\\\\lxss\\\\bash.ico")/U16_LITERAL_LXSS_BASH_ICO/g'        \
		-e 's/W("\\\\rootfs")/U16_LITERAL_LXSS_ROOTFS/g'                    \
		-e 's/W("SOFTWARE\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Lxss")/U16_LITERAL_LXSS_REGISTRY/g' \
		-e 's/W("Software\\\\Classes\\\\Local Settings\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\AppModel\\\\SystemAppData")/U16_LITERAL_APPMODEL_REGISTRY/g' \
		-e 's/W("\\\\WindowsApps\\\\")/U16_LITERAL_WINDOWS_APPS/g'          \
		-e 's/W("\\\\images\\\\icon.ico")/U16_LITERAL_IMAGES_ICON/g'        \
		-e 's/W("\\\\lxss")/U16_LITERAL_LXSS_ROOT/g'                          \
		                                                                    \
		                                                                    \
		-e 's/W("⎷┌─⌠⌡│⎡⎣⎤⎦⎧⎩⎫⎭⎨⎬╶╶╲╱╴╴╳␦␦␦␦≤≠≥∫∴∝∞÷Δ∇ΦΓ∼≃Θ×Λ⇔⇒≡ΠΨ␦Σ␦␦√ΩΞΥ⊂⊃∩∪∧∨¬αβχδεφγηιθκλ␦ν∂πψρστ␦ƒωξυζ←↑→↓")/U16_LITERAL_MANY_SYMBOLS/g'      \
		-e 's/W("¡¢£␦¥␦§¤©ª«␦␦␦␦°±²³␦µ¶·␦¹º»¼½␦¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏ␦ÑÒÓÔÕÖŒØÙÚÛÜŸ␦ßàáâãäåæçèéêëìíîï␦ñòóôõöœøùúûüÿ␦")/U16_LITERAL_CRYPTIC_QUESTION/g'  \
		                                                                    \
		                                                                    \
		                                                                    \
		-e 's/W("£¾ĳ½|^_`¨ƒ¼´")/U16_LITERAL_NRC_DUTCH/g'                    \
		-e 's/W("#@ÄÖÅÜ_éäöåü")/U16_LITERAL_NRC_FINNISH/g'                  \
		-e 's/W("£à°ç§^_`éùè¨")/U16_LITERAL_NRC_FRENCH/g'                   \
		-e 's/W("#àâçêî_ôéùèû")/U16_LITERAL_NRC_FRENCH_CANADIAN/g'          \
		-e 's/W("#§ÄÖÜ^_`äöüß")/U16_LITERAL_NRC_GERMAN/g'                   \
		-e 's/W("£§°çé^_ùàòèì")/U16_LITERAL_NRC_ITALIAN/g'                  \
		-e 's/W("#ÄÆØÅÜ_äæøåü")/U16_LITERAL_NRC_DANISH_NORWEGIAN/g'         \
		-e 's/W("#@ÃÇÕ^_`ãçõ~")/U16_LITERAL_NRC_PORTUGUESE/g'               \
		-e 's/W("£§¡Ñ¿^_`°ñç~")/U16_LITERAL_NRC_SPANISH/g'                  \
		-e 's/W("#ÉÄÖÅÜ_éäöåü")/U16_LITERAL_NRC_SWEDISH/g'                  \
		-e 's/W("ùàéçêîèôäöüû")/U16_LITERAL_NRC_SWISS/g'                    \
	$1
