#!/bin/sh

sed \
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
		-e 's/W("charnames\.txt")/U16_LITERAL_CHARNAMES_TXT/g'              \
		-e 's/W("http:\/\/ciembor.github.io\/4bit\/")/U16_LITERAL_COLOR_SCHEME_DESIGNER/g' \
	$1
