#!/bin/sh

sed \
		-e 's/W("")/U16_LITERAL_NULL_STRING/g'                       \
		-e 's/W("Lucida Console")/U16_LITERAL_LUCIDA_CONSOLE/g'      \
	$1
