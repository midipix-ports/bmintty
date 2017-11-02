#!/bin/sh

#Fails on line 5 / CFG_DOWNLOADED = "@/@"

sed \
		-e 's/W("")/U16_LITERAL_NULL_STRING/g'                       \
		-e 's/W(" ")/U16_LITERAL_EMPTY_STRING/g'                     \
		-e 's/W(".po")/U16_LITERAL_PO/g'                             \
		-e 's/W("=")/U16_LITERAL_EQUALS/g'                           \
		-e 's/W("@")/U16_LITERAL_AT/g'                               \
		-e 's/W("Lucida Console")/U16_LITERAL_LUCIDA_CONSOLE/g'      \
		-e 's/W("DispFileName")/U16_LITERAL_DISPFILENAME/g'          \
		-e 's/W("*")/U16_LITERAL_CFG_DEFAULT/g'                      \
		-e 's/W("lang\/\*.po")/U16_LITERAL_LANG_PO/g'                \
		-e 's/W("sounds\/\*.wav")/U16_LITERAL_SOUNDS/g'              \
		-e 's/W("themes\/\*")/U16_LITERAL_THEMES/g'                  \
		-e 's/W("@\/@")/U16_LITERAL_CFG_DOWNLOADED/g'                \
		-e 's/W("Thin")/U16_LITERAL_THIN/g'                          \
		-e 's/W("Extralight")/U16_LITERAL_EXTRALIGHT/g'              \
		-e 's/W("Light")/U16_LITERAL_LIGHT/g'                        \
		-e 's/W("Regular")/U16_LITERAL_REGULAR/g'                    \
		-e 's/W("Medium")/U16_LITERAL_MEDIUM/g'                      \
		-e 's/W("Semibold")/U16_LITERAL_SEMIBOLD/g'                  \
		-e 's/W("Bold")/U16_LITERAL_BOLD/g'                          \
		-e 's/W("Extrabold")/U16_LITERAL_EXTRABOLD/g'                \
		-e 's/W("Heavy")/U16_LITERAL_HEAVY/g'                        \
		-e 's/W("Ultralight")/U16_LITERAL_ULTRALIGHT/g'              \
		-e 's/W("Normal")/U16_LITERAL_NORMAL/g'                      \
		-e 's/W("Demibold")/U16_LITERAL_DEMIBOLD/g'                  \
		-e 's/W("Ultrabold")/U16_LITERAL_ULTRABOLD/g'                \
		-e 's/W("Black")/U16_LITERAL_BLACK/g'                        \
		-e 's/W("Book")/U16_LITERAL_BOOK/g'                          \
		-e 's/W("Demi")/U16_LITERAL_DEMI/g'                          \
		-e 's/W("Extrablack")/U16_LITERAL_EXTRABLACK/g'              \
		-e 's/W("Fat")/U16_LITERAL_FAT/g'                            \
		-e 's/W("Poster")/U16_LITERAL_POSTER/g'                      \
		-e 's/W("Ultrablack")/U16_LITERAL_ULTRABLACK/g'              \
		-e 's/W("Oblique")/U16_LITERAL_OBLIQUE/g'                    \
		-e 's/W("0123456789")/U16_LITERAL_0123456789/g'              \
		-e 's/W("http:\/\/ciembor.github.io\/4bit\/")/U16_LITERAL_COLOR_SCHEME_DESIGNER/g' \
		-e 's/W("– None –")/U16_LITERAL_NONE/g'                      \
		-e 's/_W("@ Windows language @")/U16_LITERAL_WINLOC/g'       \
		-e 's/_W("\* Locale environm. \*")/U16_LITERAL_LOCENV/g'     \
		-e 's/_W("= cfg. Text Locale =")/U16_LITERAL_LOCALE/g'       \
		-e 's/_W("downloaded \/ give me a name!")/U16_LITERAL_DOWNLOADED/g' \
	$1
