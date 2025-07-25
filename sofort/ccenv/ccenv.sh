
# ccenv.sh: sofort's tool-finding bits,
# invoked from within the project-agnostic configure script.

# this file is covered by COPYING.SOFORT.

# invocation and names of binary tools:
# agnostic names (ar, nm, objdump, ...);
# target-prefixed agnostic names (x86_64-nt64-midipix-ar, ...);
# branded names (llvm-ar, llvm-nm, llvm-objdump, ...);
# target-prefixed branded names (x86_64-linux-gnu-gcc-ar, ...);
# target-specifying branded tools (llvm-ar --target=x86_64-linux, ...).

# cross-compilation: default search order:
# target-prefixed agnostic tools;
# target-prefixed branded tools, starting with the prefix
# most commonly associated with the selected compiler (that is,
# ``gcc'' when using gcc, and ``llvm'' when using clang);
# target-speficying branded tools, starting once again with the
# prefix most commonly associated with the selected compiler.

# internal variables of interest:
# ccenv_cfgtype: the type of host being tested (host/native)
# ccenv_cfgfile: the configuration file for the host being tested
# ccenv_cflags:  the comprehensive cflags for the host being tested
# ccenv_cchost:  the host being tested, as reported by -dumpmachine

# variables available to cfgdefs.sh and cfgfini.sh:
# ccenv_host_cflags:    expanded cflags, valid for the host compiler
# ccenv_host_ldflags:   expanded ldflags, valid for the host compiler
# ccenv_host_sysroot:   host sysroot, as reported by the host compiler
# ccenv_native_cflags:  expanded cflags, valid for the native compiler
# ccenv_native_ldflags: expanded ldflags, valid for the native compiler
# ccenv_native_sysroot: native sysroot, as reported by the native compiler

ccenv_usage()
{
	cat "$mb_project_dir"/sofort/ccenv/ccenv.usage
	exit 0
}


ccenv_newline()
{
	printf '\n' >> "$ccenv_cfgfile"
}


ccenv_comment()
{
	ccenv_internal_str='#'

	for ccenv_internal_arg ; do
		ccenv_internal_str="$ccenv_internal_str $ccenv_internal_arg"
	done

	printf '%s\n' "$ccenv_internal_str" >> "$ccenv_cfgfile"
}


ccenv_tool_prolog()
{
	ccenv_line_dots='.....................................'
	ccenv_tool_desc=" == checking for ${1}"
	ccenv_tool_dlen="${#ccenv_line_dots}"

	printf '\n%s\n' '________________________' >&3
	printf "ccenv: checking for ${1}\n\n" >&3
	printf "%${ccenv_tool_dlen}.${ccenv_tool_dlen}s" \
		"${ccenv_tool_desc}  ${mb_line_dots}"
}


ccenv_tool_epilog()
{
	ccenv_line_dots='................................'
	ccenv_tool_dlen="$((${#ccenv_line_dots} - ${#1}))"

	case ${ccenv_tool_dlen} in
		0 | -* )
			ccenv_tool_dlen='3' ;;
	esac

	printf "%${ccenv_tool_dlen}.${ccenv_tool_dlen}s  %s.\n" \
		"${ccenv_line_dots}" "${1}"

	if [ "${1}" = 'false' ]; then
		printf '\n\nccenv: not (yet) found.\n' >&3
	else
		printf "\n\nccenv : found $(command -v ${1}).\n" >&3
	fi

	printf '%s\n' '------------------------' >&3
}


ccenv_tool_variant_epilog()
{
	ccenv_expr=${1}='${'${1}':-false}'
	eval "$ccenv_expr"

	ccenv_expr='${'${1}'}'
	eval ccenv_tool_epilog "$ccenv_expr"
}


ccenv_attr_prolog()
{
	ccenv_line_dots=' .....................................'
	ccenv_attr_desc=" == detect ${ccenv_cfgtype} ${1}"
	ccenv_attr_dlen="${#ccenv_line_dots}"

	printf "%${ccenv_attr_dlen}.${ccenv_attr_dlen}s" \
		"${ccenv_attr_desc} ${ccenv_line_dots}"

	printf '\n%s\n' '________________________' >&3
	printf "ccenv: detecting ${1}\n\n" >&3
}


ccenv_attr_epilog()
{
	ccenv_line_dots='................................'
	ccenv_tool_dlen="$((${#ccenv_line_dots} - 1 - ${#1}))"

	case ${ccenv_tool_dlen} in
		0 | -* )
			ccenv_tool_dlen='3' ;;
	esac

	printf "%${ccenv_tool_dlen}.${ccenv_tool_dlen}s  %s.\n" \
		"${ccenv_line_dots}" "${1}"

	printf '\n\nccenv: detected result: %s\n' "${1}" >&3
	printf '%s\n' '------------------------' >&3
}


ccenv_find_tool()
{
	if [ -z "$ccenv_prefixes" ]; then
		for ccenv_candidate in $(printf '%s' "$ccenv_candidates"); do
			ccenv_cmd_args="${@:-}"

			if [ -z "$ccenv_cmd_args" ]; then
				if command -v "$ccenv_candidate" > /dev/null; then
					ccenv_tool="$ccenv_candidate"
					return 0
				fi
			else
				if command -v "$ccenv_candidate" > /dev/null; then
					if "$ccenv_candidate" $@ > /dev/null 2>&3; then
						ccenv_tool="$ccenv_candidate"
						return 0
					fi
				fi
			fi
		done

		ccenv_tool=false

		return 0
	fi

	for ccenv_prefix in $(printf '%s' "$ccenv_prefixes"); do
		for ccenv_candidate in $(printf '%s' "$ccenv_candidates"); do
			ccenv_tool="$ccenv_prefix$ccenv_candidate"

			if command -v "$ccenv_tool" > /dev/null; then
				return 0
			fi
		done
	done

	for ccenv_candidate in $(printf '%s' "$ccenv_candidates"); do
		if command -v "$ccenv_candidate" > /dev/null; then
			ccenv_tool="$ccenv_candidate"
			return 0
		fi
	done

	ccenv_tool=false

	return 0
}


ccenv_set_primary_tools()
{
	ccenv_core_tools="ar nm objdump ranlib size strip strings objcopy"
	ccenv_hack_tools="addr2line cov elfedit readelf readobj otool"
	ccenv_peep_tools="perk mdso dlltool windmc windres pkgconf"

	for __tool in $(printf '%s' "$ccenv_core_tools $ccenv_hack_tools $ccenv_peep_tools"); do
		ccenv_tool_prolog "$__tool"

		if [ -n "$mb_agnostic" ]; then
			ccenv_candidates=" $__tool"

		elif [ -n "$mb_zealous" ]; then
			ccenv_candidates="$mb_zealous-$__tool"

		elif [ "$mb_toolchain" = 'gcc' ]; then
			ccenv_candidates="gcc-$__tool"
			ccenv_candidates="$ccenv_candidates $__tool"
			ccenv_candidates="$ccenv_candidates llvm-$__tool"

		elif [ "$mb_toolchain" = 'llvm' ]; then
			ccenv_candidates="llvm-$__tool"
			ccenv_candidates="$ccenv_candidates $__tool"
			ccenv_candidates="$ccenv_candidates gcc-$__tool"

		elif [ -n "$mb_toolchain" ]; then
			ccenv_candidates="$mb_toolchain-$__tool"
			ccenv_candidates="$ccenv_candidates $__tool"
			ccenv_candidates="$ccenv_candidates gcc-$__tool"
			ccenv_candidates="$ccenv_candidates llvm-$__tool"

		elif [ "$__tool" = 'pkgconf' ]; then
			ccenv_candidates="$__tool pkg-config"

		else
			ccenv_candidates="$__tool"
			ccenv_candidates="$ccenv_candidates gcc-$__tool"
			ccenv_candidates="$ccenv_candidates llvm-$__tool"
		fi

		if [ "$ccenv_cfgtype" = 'host' ]; then
			ccenv_var_prefix='mb_'
		else
			ccenv_var_prefix='mb_native_'
		fi

		ccenv_tool=
		ccenv_var_name=$ccenv_var_prefix$__tool
		ccenv_var_expr='${'$ccenv_var_name':-}'
		eval ccenv_var_val=$ccenv_var_expr

		if [ -n "$ccenv_var_val" ]; then
			eval ccenv_$__tool="$ccenv_var_val"
			ccenv_tool="$ccenv_var_val"
		else
			ccenv_find_tool
			eval ccenv_$__tool="$ccenv_tool"
		fi

		ccenv_tool_epilog "$ccenv_tool"
	done

	# windrc
	ccenv_windrc="$ccenv_windres"

	# archive format preamble
	if [ -n "$ccenv_dumpmachine_switch" ]; then
		ccenv_libgcc_path=$($ccenv_cc -print-file-name=libgcc.a \
			2>/dev/null)

		if [ -n "$ccenv_libgcc_path" ]; then
			ccenv_libgcc_a_header=$(od -b -N8             \
				$($ccenv_cc -print-file-name=libgcc.a) \
				| head -n1)
		else
			ccenv_libgcc_a_header=
		fi
	else
		ccenv_libgcc_a_header=
	fi

	# ar (default)
	ccenv_cc_arfmt='common'

	# ar (big)
	ccenv_bigaf_header=$(printf '%s\n' '<bigaf>' | od -b | head -n1)

	if [ "$ccenv_libgcc_a_header" = "$ccenv_bigaf_header" ]; then
		ccenv_cc_arfmt='bigaf'

		for __tool in $(printf '%s' "$ccenv_core_tools"); do
			ccenv_var_name=ccenv_$__tool
			ccenv_var_expr='${'$ccenv_var_name':-}'
			eval ccenv_var_val="$ccenv_var_expr"

			if [ "$ccenv_var_val" != false ]; then
				ccenv_var_val="$ccenv_var_val -X64"
				ccenv_var_expr='${ccenv_var_val:-}'
				eval ccenv_$__tool="$ccenv_var_expr"
			fi
		done
	fi

	# ar (small)
	ccenv_aiaff_header=$(printf '%s\n' '<aiaff>' | od -b | head -n1)

	if [ "$ccenv_libgcc_a_header" = "$ccenv_aiaff_header" ]; then
		ccenv_cc_arfmt='aiaff'

		for __tool in $(printf '%s' "$ccenv_core_tools"); do
			ccenv_var_name=ccenv_$__tool
			ccenv_var_expr='${'$ccenv_var_name':-}'
			eval ccenv_var_val="$ccenv_var_expr"

			if [ "$ccenv_var_val" != false ]; then
				ccenv_var_val="$ccenv_var_val -X32"
				ccenv_var_expr='${ccenv_var_val:-}'
				eval ccenv_$__tool="$ccenv_var_expr"
			fi
		done
	fi
}

ccenv_set_tool_variants()
{
	# as (asm)
	ccenv_tool_prolog 'as (asm)'
	ccenv_candidates=as
	ccenv_find_tool

	if [ "$ccenv_tool" = false ]; then
		ccenv_as_asm=
	else
		$ccenv_tool --help 2>&1 | grep -i '.bc assembler' \
		|| ccenv_as_asm="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_as_asm'

	# as (ll)
	ccenv_tool_prolog 'as (ll)'
	ccenv_candidates=llvm-as
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_as_ll="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_as_ll'

	# as (mc)
	ccenv_tool_prolog 'as (mc)'
	ccenv_candidates=llvm-mc
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_as_mc="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_as_mc'

	# ld (bfd)
	ccenv_tool_prolog 'ld (bfd)'
	ccenv_candidates=ld.bfd
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_ld_bfd="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_ld_bfd'

	# ld (gold)
	ccenv_tool_prolog 'ld (gold)'
	ccenv_candidates=ld.gold
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_ld_gold="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_ld_gold'

	# ld (lld)
	ccenv_tool_prolog 'ld (lld)'
	ccenv_candidates=lld
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_ld_lld="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_ld_lld'

	# objdump (bfd)
	ccenv_tool_prolog 'objdump (bfd)'
	ccenv_candidates=objdump
	ccenv_find_tool

	if $ccenv_tool --version | grep -i Binutils > /dev/null; then
		ccenv_objdump_bfd="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_objdump_bfd'

	# objdump (llvm)
	ccenv_tool_prolog 'objdump (llvm)'
	ccenv_candidates=llvm-objdump
	ccenv_find_tool

	if $ccenv_tool --version | grep -i LLVM > /dev/null; then
		ccenv_objdump_llvm="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_objdump_llvm'

	# readelf (bfd)
	ccenv_tool_prolog 'readelf (bfd)'
	ccenv_candidates=readelf
	ccenv_find_tool

	if $ccenv_tool --version | grep -i Binutils > /dev/null; then
		ccenv_readelf_bfd="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_readelf_bfd'

	# readelf (llvm)
	ccenv_tool_prolog 'readelf (llvm)'
	ccenv_candidates=llvm-readelf
	ccenv_find_tool

	if $ccenv_tool --version | grep -i LLVM > /dev/null; then
		ccenv_readelf_llvm="$ccenv_tool"
	fi

	ccenv_tool_variant_epilog 'ccenv_readelf_llvm'

	# as
	if [ -n "$ccenv_cc" ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'CC) -c -x assembler'
	elif [ -n "$mb_agnostic" ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_ASM)'
	elif [ "$mb_zealous" = 'gcc' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_ASM)'
	elif [ -n "$mb_zealous" = 'llvm' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_MC)'
	elif [ "$mb_toolchain" = 'gcc' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_ASM)'
	elif [ "$mb_toolchain" = 'llvm' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_MC)'
	fi

	# ld
	if [ -n "$ccenv_cc" ]; then
		ccenv_ld='$('"$ccenv_makevar_prefix"'CC) -nostdlib -nostartfiles'
	fi
}

ccenv_set_c_compiler_candidates()
{
	if   [ -n "$mb_compiler" ]; then
		ccenv_candidates="$mb_compiler"

	elif [ -n "$mb_agnostic" ]; then
		ccenv_candidates="c99 c11 cc"

	elif [ "$mb_zealous" = 'gcc' ]; then
		ccenv_candidates="gcc"

	elif [ "$mb_zealous" = 'llvm' ]; then
		ccenv_candidates="clang"

	elif [ "$mb_toolchain" = 'gcc' ]; then
		ccenv_candidates="gcc c99 c11 cc clang"

	elif [ "$mb_toolchain" = 'llvm' ]; then
		ccenv_candidates="clang c99 c11 cc gcc"

	elif [ -n "$mb_toolchain" ]; then
		ccenv_candidates="$mb_toolchain c99 c11 cc gcc clang"

	else
		ccenv_candidates="cc gcc clang c99 c11"
	fi
}


ccenv_set_cc()
{
	ccenv_tool_prolog 'C compiler'

	if [ -z "$ccenv_cc" ]; then
		ccenv_set_c_compiler_candidates
		ccenv_find_tool
		ccenv_cc="$ccenv_tool"
	fi


	if [ "$ccenv_cc" = false ] && [ -n "$mb_compiler" ]; then
		ccenv_cc="$mb_compiler"
	fi

	ccenv_tool_epilog "$ccenv_cc"


	if [ $ccenv_cfgtype = 'host' ]; then
		ccenv_host_cc="$ccenv_cc"
		cfgtest_host_section
		ccenv_host_cc=
	else
		ccenv_native_cc="$ccenv_cc"
		cfgtest_native_section
		ccenv_native_cc=
	fi

	cfgtest_silent='yes'

	if cfgtest_compiler_switch -dumpmachine ; then
		ccenv_dumpmachine_switch='-dumpmachine'
	else
		ccenv_dumpmachine_switch=
	fi

	if cfgtest_code_snippet_asm 'typedef int dummy;' ; then
		eval ccenv_${ccenv_cfgtype}_stdin_input='yes'
	else
		eval ccenv_${ccenv_cfgtype}_stdin_input='no'
	fi

	unset cfgtest_silent

	ccenv_cc_cmd="$ccenv_cc"
	ccenv_errors=

	if [ "$ccenv_cfgtype" = 'native' ]; then
		ccenv_host=

		if [ -n "$mb_native_host" ]; then
			ccenv_host="$mb_native_host"

		elif [ -n "$ccenv_dumpmachine_switch" ]; then
			ccenv_host=$(eval $ccenv_cc $(printf '%s' "$ccenv_cflags") \
				$ccenv_dumpmachine_switch 2>&3)

		elif command -v slibtool > /dev/null 2>&1; then
			ccenv=$(slibtool --dumpmachine 2>/dev/null || true)
		fi

		if [ -z "$ccenv_host" ]; then
			ccenv_machine=$(uname -m 2>/dev/null)
			ccenv_system=$(uname -s 2>/dev/null)

			ccenv_machine="${ccenv_machine:-unknown}"
			ccenv_system="${ccenv_system:-anyos}"

			ccenv_host=$(printf '%s' "${ccenv_machine}-unknown-${ccenv_system}" \
				| tr '[[:upper:]]' '[[:lower:]]')
		fi

		ccenv_cchost=$ccenv_host
		return 0
	fi


	if [ -n "$mb_cchost" ]; then
		ccenv_host="$mb_cchost"
	elif [ -n "$mb_host" ]; then
		ccenv_host="$mb_host"
	else
		ccenv_host=
	fi

	if [ -z "$ccenv_host" ] && [ -n "$ccenv_dumpmachine_switch" ]; then
		ccenv_host=$(eval $ccenv_cc $(printf '%s' "$ccenv_cflags") \
			$ccenv_dumpmachine_switch 2>&3)
		ccenv_cchost=$ccenv_host

	elif [ -z "$ccenv_host" ]; then
		# no -dumpmachine support and no --host argument implies native build
		if command -v slibtool > /dev/null 2>&1; then
			ccenv=$(slibtool --dumpmachine 2>/dev/null || true)
		fi

		if [ -z "$ccenv_host" ]; then
			ccenv_machine=$(uname -m 2>/dev/null)
			ccenv_system=$(uname -s 2>/dev/null)

			ccenv_machine="${ccenv_machine:-unknown}"
			ccenv_system="${ccenv_system:-anyos}"

			ccenv_host=$(printf '%s' "${ccenv_machine}-unknown-${ccenv_system}" \
				| tr '[[:upper:]]' '[[:lower:]]')
		fi

		ccenv_cchost=$ccenv_host

	elif [ -n "$ccenv_dumpmachine_switch" ]; then
		ccenv_tmp=$(mktemp ./tmp_XXXXXXXXXXXXXXXX)
		ccenv_cmd="$ccenv_cc --target=$ccenv_host -E -xc -"

		if [ -z "$mb_user_cc" ]; then
			$(printf %s "$ccenv_cmd") < /dev/null > /dev/null \
				2>"$ccenv_tmp" || true

			ccenv_errors=$(cat "$ccenv_tmp")

			if [ -z "$ccenv_errors" ]; then
				ccenv_tool_prolog 'C compiler for host'
				ccenv_tflags="--target=$ccenv_host"
				ccenv_cc="$ccenv_cc $ccenv_tflags"
				ccenv_tool_epilog "$ccenv_cc"
			else
				printf '%s' "$ccenv_errors" >&3
			fi
		fi

		rm -f "$ccenv_tmp"
		unset ccenv_tmp

		ccenv_cchost=$(eval $ccenv_cc $(printf '%s' "$ccenv_cflags") \
			$ccenv_dumpmachine_switch 2>&3)
	fi

	if [ -z "$ccenv_dumpmachine_switch" ] && [ -n "$ccenv_host" ]; then
		ccenv_cchost="$ccenv_host"

	elif [ "$ccenv_cchost" != "$ccenv_host" ]; then
		printf 'error!\n' >&2
		printf 'ccenv:\n' >&2
		printf 'ccenv: ccenv_host:   %s \n' $ccenv_host >&2
		printf 'ccenv: ccenv_cchost: %s \n' $ccenv_cchost >&2

		if [ -z "$ccenv_tflags" ]; then
			printf 'ccenv:\n' >&2
			printf 'ccenv: ccenv_host and ccenv_cchost do not match, most likely because:\n' >&2
			printf 'ccenv: (1) you explicitly set CC (or passed --compiler=...)\n' >&2
			printf 'ccenv: (2) the selected compiler does not accept --target=...\n' >&2
			printf 'ccenv: (3) the host reported by -dumpmachine differs from the one you requested.\n' >&2
		fi

		if [ -n "$ccenv_errors" ]; then
			printf 'ccenv:\n' >&2
			printf 'ccenv: something went wrong, see the command and compiler message below.\n\n' >&2
			printf 'cmd: %s < /dev/null > /dev/null\n' "$ccenv_cmd" >&2
			printf '%s\n\n' "$ccenv_errors" >&2
		else
			printf 'ccenv:\n' >&2
			printf 'ccenv: something went wrong, bailing out.\n\n' >&2
		fi

		return 2
	fi
}

ccenv_set_cpp()
{
	ccenv_tool_prolog 'C pre-processor'

	case "$ccenv_cc_cmd" in
		cc | c99 | c11 | gcc)
			ccenv_cpp_prefix=
			ccenv_candidates="cpp" ;;

		clang )
			ccenv_cpp_prefix=
			ccenv_candidates="clang-cpp" ;;

		*-cc )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-cc*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-c99 )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-c99*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-c11 )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-c11*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-gcc )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-gcc*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-clang )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-clang*}-
			ccenv_candidates="${ccenv_cpp_prefix}clang-cpp" ;;

		* )
			ccenv_cpp="$ccenv_cc -E"
			ccenv_tool_epilog "$ccenv_cpp"
			return 0
	esac

	ccenv_find_tool

	if [ "$ccenv_tool" = false ]; then
		ccenv_cpp="$ccenv_cc -E"
	elif [ -n "$ccenv_tflags" ]; then
		ccenv_cpp="$ccenv_tool $ccenv_tflags"
	else
		ccenv_cpp="$ccenv_tool"
	fi

	ccenv_tool_epilog "$ccenv_cpp"
}

ccenv_set_cxx()
{
	ccenv_tool_prolog 'C++ compiler'

	case "$ccenv_cc_cmd" in
		cc | c99 | c11 )
			ccenv_cxx_prefix=
			ccenv_candidates="cxx c++" ;;

		gcc )
			ccenv_cxx_prefix=
			ccenv_candidates="g++" ;;

		clang )
			ccenv_cxx_prefix=
			ccenv_candidates="clang++" ;;

		*-gcc )
			ccenv_cxx_prefix=${ccenv_cc_cmd%-gcc*}-
			ccenv_candidates="${ccenv_cxx_prefix}g++" ;;

		*-clang )
			ccenv_cxx_prefix=${ccenv_cc_cmd%-clang*}-
			ccenv_candidates="${ccenv_cxx_prefix}clang++" ;;

		/*cc | /*c99 | /*c11 )
			ccenv_cxx_prefix=${ccenv_cc_cmd%/*}
			ccenv_candidates="${ccenv_cxx_prefix}/cxx"
			ccenv_candidates="${ccenv_candidates} ${ccenv_cxx_prefix}/c++" ;;

		/*gcc )
			ccenv_cxx_prefix=${ccenv_cc_cmd%/*}
			ccenv_candidates="${ccenv_cxx_prefix}/g++" ;;

		/*clang )
			ccenv_cxx_prefix=${ccenv_cc_cmd%/*}
			ccenv_candidates="${ccenv_cxx_prefix}/clang++" ;;

		* )
			ccenv_cxx="$ccenv_cc -xc++"
			ccenv_tool_epilog "$ccenv_cxx"
			return 0
	esac

	ccenv_find_tool

	if [ "$ccenv_tool" = false ]; then
		ccenv_cxx="$ccenv_cc -xc++"
	elif [ -n "$ccenv_tflags" ]; then
		ccenv_cxx="$ccenv_tool $ccenv_tflags"
	else
		ccenv_cxx="$ccenv_tool"
	fi

	ccenv_tool_epilog "$ccenv_cxx"
}

ccenv_set_cc_host()
{
	ccenv_attr_prolog 'system'
	ccenv_cc_host="$ccenv_cchost"
	ccenv_attr_epilog "$ccenv_cc_host"
}

ccenv_set_cc_bits()
{
	ccenv_attr_prolog 'bits'

	ccenv_internal_size=
	ccenv_internal_type='void *'
	ccenv_internal_test='char x[(sizeof(%s) == %s/8) ? 1 : -1];'

	for ccenv_internal_guess in 64 32 128; do
		if [ -z "${ccenv_internal_size:-}" ]; then
			ccenv_internal_str=$(printf "$ccenv_internal_test"  \
				"$ccenv_internal_type"                      \
				"$ccenv_internal_guess")

			ccenv_expr='ccenv_stdin_input=$ccenv_'${ccenv_cfgtype}'_stdin_input'
			eval ${ccenv_expr}

			if [ "$ccenv_stdin_input" = 'yes' ]; then
				printf '%s' "$ccenv_internal_str"                   \
						| eval $ccenv_cc -S -xc - -o -      \
						  $(printf '%s' "$ccenv_cflags")    \
					> /dev/null 2>&3                            \
				&& ccenv_internal_size=$ccenv_internal_guess
			else
				ccenv_tmpname='ccenv/c3RyaWN0X21vZGUK.c'

				printf '%s' "$ccenv_internal_str" \
					> "$ccenv_tmpname"

				$ccenv_cc -c "$ccenv_tmpname" -o a.out \
					> /dev/null 2>&3                \
				&& ccenv_internal_size=$ccenv_internal_guess

				rm "$ccenv_tmpname"
			fi
		fi
	done

	ccenv_cc_bits=$ccenv_internal_size

	ccenv_attr_epilog "$ccenv_cc_bits"
}

ccenv_set_cc_underscore()
{
	ccenv_attr_prolog 'prepended underscores'

	ccenv_fn_name='ZmYaXyWbVe_UuTnSdReQrPsOcNoNrLe'
	ccenv_fn_code='int %s(void){return 0;}'

	ccenv_tmpname='ccenv/c3RyaWN0X21vZGUK.c'

	printf "$ccenv_fn_code" $ccenv_fn_name \
		> "$ccenv_tmpname"

	$ccenv_cc -c "$ccenv_tmpname" -o a.out \
		> /dev/null 2>&3

	if "$ccenv_nm" a.out | grep          \
			-e "^_$ccenv_fn_name" \
			-e " _$ccenv_fn_name"  \
			> /dev/null; then
		ccenv_cc_underscore='_'
		ccenv_attr_epilog 'yes'
	else
		ccenv_attr_epilog 'no'
	fi

	rm "$ccenv_tmpname"
	rm a.out

	return 0
}

ccenv_create_framework_executable()
{
	if [ "$ccenv_cfgtype" = 'host' ]; then
		if [ "$mb_freestanding" = 'yes' ]; then
			return 1
		fi
	fi

	if [ -f $ccenv_image ]; then
		mv $ccenv_image $ccenv_image.tmp
		rm -f $ccenv_image.tmp
	fi

	ccenv_tmpname='ccenv/c3RyaWN0X21vZGUK.c'

	printf 'int main(void){return 0;}'  \
		> "$ccenv_tmpname"

	if $ccenv_cc "$ccenv_tmpname" -o $ccenv_image 2>&3; then
		ccenv_ret=0
		ccenv_cc_environment='hosted'
	else
		ccenv_ret=1
	fi

	rm "$ccenv_tmpname"

	return $ccenv_ret
}

ccenv_create_freestanding_executable()
{
	if [ -f $ccenv_image ]; then
		mv $ccenv_image $ccenv_image.tmp
		rm -f $ccenv_image.tmp
	fi

	if [ -z "ccenv_cc_underscore" ]; then
		ccenv_start_fn='_start'
	else
		ccenv_start_fn='start'
	fi

	ccenv_tmpname='ccenv/c3RyaWN0X21vZGUK.c'

	printf 'int %s(void){return 0;}' "$ccenv_start_fn" \
		> "$ccenv_tmpname"

	if $ccenv_cc "$ccenv_tmpname"         \
			-ffreestanding         \
			-nostdlib -nostartfiles \
			-o $ccenv_image          \
			2>&3; then
		ccenv_ret=0
		ccenv_cc_environment='freestanding'
	else
		ccenv_ret=1
	fi

	rm "$ccenv_tmpname"

	return $ccenv_ret
}

ccenv_set_cc_binfmt_error()
{
	ccenv_attr_epilog '(unable to create executable)'
}

ccenv_set_cc_binfmt()
{
	ccenv_use_perk=
	ccenv_use_otool=
	ccenv_use_readelf=
	ccenv_use_readobj=
	ccenv_use_bfd_objdump=
	ccenv_use_llvm_objdump=

	ccenv_attr_prolog 'binary format'

	ccenv_create_framework_executable               \
		|| ccenv_create_freestanding_executable \
		|| ccenv_set_cc_binfmt_error            \
		|| return 0

	# PE / perk
	if [ -n "$ccenv_perk" ]; then
		if $ccenv_perk $ccenv_image 2>&3; then
			ccenv_cc_binfmt='PE'
			ccenv_use_perk=yes
		fi
	fi

	# ELF / readelf
	if [ -n "$ccenv_readelf" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_readelf -h $ccenv_image 2>&3               \
				| grep 'Magic:' | sed -e 's/[ ]*//g' \
				| grep 'Magic:7f454c46'              \
					> /dev/null; then
			ccenv_cc_binfmt='ELF'
			ccenv_use_readelf=yes
		fi
	fi

	# a marble of astonishing design:
	# llvm-readelf also parses PE and Mach-O

	if [ -n "$ccenv_readelf_llvm" ]; then
		ccenv_readany="$ccenv_readelf_llvm"
	else
		ccenv_readany="$ccenv_readelf"
	fi

	# PE / readelf
	if [ -n "$ccenv_readany" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_readany -h $ccenv_image 2>&3               \
				| grep 'Magic:' | sed -e 's/[ ]*//g' \
				| grep 'Magic:MZ'                    \
					> /dev/null; then
			ccenv_cc_binfmt='PE'
			ccenv_use_readelf=yes
		fi
	fi

	# MACHO-64 / otool
	if [ -n "$ccenv_otool" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_otool -hv $ccenv_image 2>&3        \
				| grep -i 'MH_MAGIC_64'      \
					> /dev/null; then
			ccenv_cc_binfmt='MACHO'
			ccenv_use_otool=yes
		fi
	fi

	# MACHO-32 / otool
	if [ -n "$ccenv_otool" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_otool -hv $ccenv_image 2>&3        \
				| grep -i 'MH_MAGIC'         \
					> /dev/null; then
			ccenv_cc_binfmt='MACHO'
			ccenv_use_otool=yes
		fi
	fi

	# MACHO-64 / readelf
	if [ -n "$ccenv_readany" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_readany -h $ccenv_image 2>&3                    \
				| grep -i 'Magic:' | sed -e 's/[ ]*//g'   \
				| grep -i '(0xfeedfacf)'                  \
					> /dev/null; then
			ccenv_cc_binfmt='MACHO'
			ccenv_use_readelf=yes
		fi
	fi

	# MACHO-32 / readelf
	if [ -n "$ccenv_readany" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_readany -h $ccenv_image 2>&3                    \
				| grep -i 'Magic:' | sed -e 's/[ ]*//g'   \
				| grep -i '(0xcafebabe)'                  \
					> /dev/null; then
			ccenv_cc_binfmt='MACHO'
			ccenv_use_readelf=yes
		fi
	fi

	# MACHO / readobj
	if [ -n "$ccenv_readobj" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_readobj $ccenv_image 2>&3                  \
				| grep -i 'Format:'                  \
				| sed  -e 's/ /_/g'                  \
				| grep -i '_Mach-O_'                 \
					> /dev/null; then
			ccenv_cc_binfmt='MACHO'
			ccenv_use_readobj=yes
		fi
	fi

	# MACHO / objdump (llvm)
	if [ -n "$ccenv_objdump" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_objdump -section-headers $ccenv_image  \
					2>&3                     \
				| grep -i 'file format Mach-O'   \
					> /dev/null; then
			ccenv_cc_binfmt='MACHO'
			ccenv_use_objdump=yes
		fi
	fi

	# MACHO / objdump (bfd)
	if [ -n "$ccenv_objdump" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_objdump -h  $ccenv_image 2>&3              \
			| grep -i 'file format Mach-O'            \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_objdump=yes
	fi

	# PE / objdump (bfd)
	if [ -n "$ccenv_objdump" ] && [ -z "$ccenv_cc_binfmt" ]; then
		if $ccenv_objdump -h  $ccenv_image 2>&3        \
				| grep -i 'file format pei-'   \
					> /dev/null; then
			ccenv_cc_binfmt='PE'
			ccenv_use_bfd_objdump=yes
		fi
	fi

	ccenv_attr_epilog "$ccenv_cc_binfmt"
}

ccenv_set_os_pe()
{
	if [ "$ccenv_cc_environment" = 'freestanding' ]; then
		case "$ccenv_cchost" in
			*-midipix | *-midipix-* )
				ccenv_os='midipix' ;;
			*-mingw | *-mingw32 | *-mingw64 )
				ccenv_os='mingw' ;;
			*-mingw-* | *-mingw32-* | *-mingw64 )
				ccenv_os='mingw' ;;
			*-msys | *-msys2 | *-msys-* | *-msys2-* )
				ccenv_os='msys' ;;
			*-cygwin | *-cygwin-* )
				ccenv_os='cygwin' ;;
		esac
	fi

	if [ -n "$ccenv_os" ]; then
		return 0
	fi

	if [ -n "$ccenv_use_perk" ]; then
		ccenv_framework=$($ccenv_perk -y $ccenv_image)
		ccenv_os=${ccenv_framework#*-*-*-*}
	fi

	if [ -z "$ccenv_os" ] && [ -n "$ccenv_objdump_bfd" ]; then
		$ccenv_objdump_bfd -x $ccenv_image | grep -i 'DLL Name' \
			| grep 'cygwin1.dll' > /dev/null                \
		&& ccenv_os='cygwin'
	fi

	if [ -z "$ccenv_os" ] && [ -n "$ccenv_objdump_bfd" ]; then
		$ccenv_objdump_bfd -x $ccenv_image | grep -i 'DLL Name' \
			| grep 'msys-2.0.dll' > /dev/null               \
		&& ccenv_os='msys'
	fi

	if [ -z "$ccenv_os" ] && [ -n "$ccenv_objdump_bfd" ]; then
		$ccenv_objdump_bfd -x $ccenv_image          \
			| grep -i 'DLL Name' | grep '.CRT'  \
				> /dev/null                 \
		&& $ccenv_objdump_bfd -x $ccenv_image       \
			| grep -i 'DLL Name' | grep '.bss'  \
				> /dev/null                 \
		&& $ccenv_objdump_bfd -x $ccenv_image       \
			| grep -i 'DLL Name' | grep '.tls'  \
				> /dev/null                 \
		&& ccenv_os='mingw'
	fi
}

ccenv_set_os_macho()
{
	case "$ccenv_cchost" in
		*-apple-darwin* )
			ccenv_os='darwin' ;;
	esac
}

ccenv_set_os()
{
	ccenv_attr_prolog 'os name'

	case "$ccenv_cc_binfmt" in
		PE )
			ccenv_set_os_pe ;;
		MACHO )
			ccenv_set_os_macho ;;
	esac

	if [ -n "$ccenv_os" ]; then
		ccenv_attr_epilog "$ccenv_os"
		return 0
	fi

	case "$ccenv_cchost" in
		*-*-musl | *-*-gnu )
			ccenv_tip=${ccenv_cchost%-*}
			ccenv_os=${ccenv_tip#*-}
			;;
		*-*-solaris* )
			ccenv_os='solaris'
			;;
		*-*-*bsd* | *-*-dragonfly* )
			ccenv_os='bsd'
			;;
		*-*-*-* )
			ccenv_tip=${ccenv_cchost%-*}
			ccenv_os=${ccenv_tip#*-*-}
			;;
		*-*-* )
			ccenv_os=${ccenv_cchost#*-*-}
			;;
		*-* )
			ccenv_os=${ccenv_cchost#*-}
			;;
	esac

	if [ -z "$ccenv_os" ]; then
		ccenv_os='anyos'
	fi

	ccenv_attr_epilog "$ccenv_os"
}

ccenv_set_os_flags()
{
	case "$ccenv_os" in
		darwin )
			ccenv_cflags_os='-D_DARWIN_C_SOURCE'
			ccenv_cflags_pic='-fPIC'
			;;
		midipix )
			ccenv_cflags_os=
			ccenv_cflags_pic='-fPIC'
			;;
		cygwin )
			ccenv_cflags_os=
			ccenv_cflags_pic=
			;;
		msys | msys* | mingw | mingw* )
			ccenv_cflags_os='-U__STRICT_ANSI__'
			ccenv_cflags_pic=
			;;
		* )
			ccenv_cflags_os=
			ccenv_cflags_pic='-fPIC'
			;;
	esac
}

ccenv_set_os_semantics()
{
	# binary_format - core_api - ex_api - dependency_resolution

	ccenv_attr_prolog 'os semantics'

	case "$ccenv_os" in
		linux )
			ccenv_os_semantics='elf-posix-linux-ldso'
			;;
		bsd )
			ccenv_os_semantics='elf-posix-bsd-ldso'
			;;
		darwin )
			ccenv_os_semantics='macho-posix-osx-ldso'
			;;
		midipix )
			ccenv_os_semantics='pe-posix-winnt-ldso'
			;;
		cygwin )
			ccenv_os_semantics='pe-hybrid-winnt-unsafe'
			;;
		msys )
			ccenv_os_semantics='pe-hybrid-winnt-unsafe'
			;;
		mingw )
			ccenv_os_semantics='pe-win32-winnt-unsafe'
			;;
	esac

	if [ -n "$ccenv_os_semantics" ]; then
		ccenv_attr_epilog "$ccenv_os_semantics"
		return 0
	fi

	if [ -n "$ccenv_cc_binfmt" ]; then
		ccenv_os_semantics_pattern='%s-posix-anyos-unknown'
		ccenv_os_semantics=$(printf                   \
				"$ccenv_os_semantics_pattern"  \
				"$ccenv_cc_binfmt"              \
			| tr '[:upper:]' '[:lower:]')
	else
		ccenv_os_semantics='unknown-posix-anyos-unknown'
	fi

	ccenv_attr_epilog "$ccenv_os_semantics"
}

ccenv_set_os_dso_format()
{
	ccenv_attr_prolog 'os dso format'

	case "$ccenv_cc_arfmt" in
		common )
			ccenv_cc_sofmt="$ccenv_cc_binfmt"
			;;

		bigaf )
			ccenv_libgcc_s_a_header=$(od -b -N8             \
				$($ccenv_cc -print-file-name=libgcc_s.a) \
					2>/dev/null                       \
					| head -n1)

			ccenv_libgcc_s_so_header=$(od -b -N8             \
				$($ccenv_cc -print-file-name=libgcc_s.so) \
					2>/dev/null                        \
					| head -n1)

			if [ "$ccenv_libgcc_s_a_header" = "$ccenv_bigaf_header" ]; then
				ccenv_cc_sofmt='bigaf'
			elif [ "$ccenv_libgcc_s_so_header" = "$ccenv_bigaf_header" ]; then
				ccenv_cc_sofmt='bigaf'
			else
				ccenv_cc_sofmt="$ccenv_cc_binfmt"
			fi
			;;

		aiaff )
			ccenv_libgcc_s_a_header=$(od -b -N8               \
				$($ccenv_cc -print-file-name=libgcc_s.a) \
					| head -n1)

			ccenv_libgcc_s_so_header=$(od -b -N8               \
				$($ccenv_cc -print-file-name=libgcc_s.so) \
					| head -n1)

			if [ "$ccenv_libgcc_s_a_header" = "$ccenv_aiaff_header" ]; then
				ccenv_cc_sofmt='aiaff'
			elif [ "$ccenv_libgcc_s_so_header" = "$ccenv_aiaff_header" ]; then
				ccenv_cc_sofmt='aiaff'
			else
				ccenv_cc_sofmt="$ccenv_cc_binfmt"
			fi
			;;
	esac

	if [ "$ccenv_cfgtype" = 'host' ]; then
		case "$ccenv_cc_sofmt" in
			bigaf | aiaff )
				mb_shared_lib_cmd='$(AR) -rcs'
				mb_shared_lib_ldflags=
				;;

			* )
				mb_shared_lib_cmd='$(CC) -shared -o'
				mb_shared_lib_ldflags='$(LDFLAGS_SHARED)'
				;;
		esac
	fi

	ccenv_attr_epilog "$ccenv_cc_sofmt"
}

ccenv_set_os_dso_exrules()
{
	ccenv_attr_prolog 'os dso exrules'

	case "$ccenv_os" in
		midipix )
			ccenv_os_dso_exrules='pe-mdso'
			;;
		* )
			if [ "$ccenv_cc_binfmt" = 'PE' ]; then
				ccenv_os_dso_exrules='pe-dlltool'
			else
				ccenv_os_dso_exrules='default'
			fi
	esac

	ccenv_attr_epilog "$ccenv_os_dso_exrules"
}

ccenv_set_os_dso_linkage()
{
	# todo: PIC, PIE, and friends
	ccenv_attr_prolog 'os linkage'
	ccenv_os_dso_linkage='default'
	ccenv_attr_epilog "$ccenv_os_dso_linkage"
}

ccenv_set_os_dso_patterns_darwin()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.dylib

	ccenv_os_implib_ext=.invalid
	ccenv_os_libdef_ext=.invalid

	ccenv_os_archive_ext=.a
	ccenv_os_soname=symlink

	ccenv_os_lib_prefixed_suffix=
	ccenv_os_lib_suffixed_suffix='$(OS_LIB_SUFFIX)'
}

ccenv_set_os_dso_patterns_mdso()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.so

	ccenv_os_implib_ext=.lib.a
	ccenv_os_libdef_ext=.so.def

	ccenv_os_archive_ext=.a
	ccenv_os_soname=symlink

	ccenv_os_lib_prefixed_suffix='$(OS_LIB_SUFFIX)'
	ccenv_os_lib_suffixed_suffix=
}

ccenv_set_os_dso_patterns_dlltool()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=.exe

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.dll

	ccenv_os_implib_ext=.dll.a
	ccenv_os_libdef_ext=.def

	ccenv_os_archive_ext=.a
	ccenv_os_soname=copy

	ccenv_os_lib_prefixed_suffix='$(OS_LIB_SUFFIX)'
	ccenv_os_lib_suffixed_suffix=
}

ccenv_set_os_dso_patterns_default()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.so

	ccenv_os_implib_ext=.invalid
	ccenv_os_libdef_ext=.invalid

	ccenv_os_archive_ext=.a
	ccenv_os_soname=symlink

	ccenv_os_lib_prefixed_suffix='$(OS_LIB_SUFFIX)'
	ccenv_os_lib_suffixed_suffix=
}

ccenv_set_os_dso_patterns()
{
	# sover: .so.x.y.z
	# verso: .x.y.z.so

	case "$ccenv_os" in
		darwin )
			ccenv_set_os_dso_patterns_darwin
			;;
		midipix )
			ccenv_set_os_dso_patterns_mdso
			;;
		cygwin | msys | mingw )
			ccenv_set_os_dso_patterns_dlltool
			;;
		* )
			ccenv_set_os_dso_patterns_default
			;;
	esac
}

ccenv_set_os_pe_switches()
{
	if [ "$ccenv_cc_binfmt" = 'PE' ] && [ -z "$ccenv_pe_subsystem" ]; then
		case "$ccenv_os" in
			midipix | mingw )
				ccenv_pe_subsystem='windows'
				;;
			* )
				ccenv_pe_subsystem='console'
				;;
		esac
	fi

	if [ "$ccenv_cc_binfmt" = 'PE' ]; then
		if ! cfgtest_macro_definition '__PE__'; then
			ccenv_cflags_os="${ccenv_cflags_os} -D__PE__"
		fi

		if ! cfgtest_macro_definition '__dllexport'; then
			ccenv_cflags_os="${ccenv_cflags_os} -D__dllexport=__attribute__\(\(__dllexport__\)\)"
		fi

		if ! cfgtest_macro_definition '__dllimport'; then
			ccenv_cflags_os="${ccenv_cflags_os} -D__dllimport=__attribute__\(\(__dllimport__\)\)"
		fi
	fi
}

ccenv_set_os_gate_switches()
{
	if [ "$ccenv_os" = 'solaris' ]; then
		if ! cfgtest_macro_definition 'AT_FDCWD'; then
			ccenv_cflags_os="${ccenv_cflags_os} -D__EXTENSIONS__"
		fi
	fi
}

ccenv_set_os_bsd_switches()
{
	if [ "$ccenv_os" = 'bsd' ]; then
		mb_cfgtest_headers='sys/mman.h'

		if ! cfgtest_macro_definition 'MAP_ANON'; then
			ccenv_cflags_os="${ccenv_cflags_os} -D__BSD_VISIBLE"
		fi

		mb_cfgtest_headers=
	fi
}

ccenv_output_defs()
{
	ccenv_in="$mb_project_dir/sofort/ccenv/ccenv.in"
	ccenv_mk="$mb_pwd/ccenv/$ccenv_cfgtype.mk"
	ccenv_tmp=

	if [ "$ccenv_cc_binfmt" = 'PE' ]; then
		ccenv_pe="$mb_project_dir/sofort/ccenv/pedefs.in"
		ccenv_in="$ccenv_in $ccenv_pe"
	fi

	if [ $ccenv_cfgtype = 'native' ]; then

		ccenv_tmp=$(mktemp ./tmp_XXXXXXXXXXXXXXXX)

		sed                                      \
				-e 's/^[[:space:]]*$/@/g' \
				-e 's/^/NATIVE_/'          \
				-e 's/NATIVE_@//g'          \
				-e 's/NATIVE_#/#/g'          \
				-e 's/       =/=/g'           \
				-e 's/       +=/+=/g'          \
			$(printf '%s ' $ccenv_in)               \
				> "$ccenv_tmp"

		ccenv_in="$ccenv_tmp"
	else
		unset ccenv_tmp
	fi

	ccenv_var_defs=
	ccenv_sed_substs="-e s/@ccenv_cfgtype@/${ccenv_cfgtype}/g"

	ccenv_vars=$(cut -d'=' -f1 "$mb_project_dir/sofort/ccenv/ccenv.vars" \
		| grep -v '^#');

	ccenv_exvars="ccenv_makevar_prefix"

	for __var in $(printf '%s' "$ccenv_vars $ccenv_exvars"); do
		ccenv_sed_subst=$(printf '%s %s%s%s' \
				'-e' "'s^@$__var@"    \
				"^___${__var}___"      \
				"^g'")

		ccenv_sed_substs="$ccenv_sed_substs $ccenv_sed_subst"

		ccenv_var_def=$(printf '%s%s="${%s}"' "-D" "___${__var}___" "${__var}")
		eval ccenv_var_defs='"$ccenv_var_defs "$ccenv_var_def'
	done

	eval sed $ccenv_sed_substs $(printf '%s ' $ccenv_in) \
			| eval m4 $ccenv_var_defs -           \
			| sed -e 's/[[:blank:]]*$//g'          \
		> "$ccenv_mk"

	if [ "$ccenv_cfgtype" = 'host' ]; then
		for __var in $(printf '%s' "$ccenv_vars"); do
			ccenv_src_var=$__var
			ccenv_dst_var=mb_${__var#*ccenv_}
			ccenv_var_expr='${'$ccenv_src_var':-}'
			eval $ccenv_dst_var=$ccenv_var_expr

		done

		mb_host=$ccenv_host
		mb_cchost=$ccenv_cchost
	else
		for __var in $(printf '%s' "$ccenv_vars"); do
			ccenv_src_var=$__var
			ccenv_dst_var=mb_native_${__var#*ccenv_}
			ccenv_var_expr='${'$ccenv_src_var':-}'
			eval "$ccenv_dst_var=$ccenv_var_expr"
		done

		mb_native_host=$ccenv_host
		mb_native_cchost=$ccenv_cchost
	fi

	if [ -n "${ccenv_tmp:-}" ]; then
		rm -f "$ccenv_tmp"
		unset ccenv_tmp
	fi


	if [ "${ccenv_cfgtype}" = 'host' ]; then
		ccenv_cflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" .cflags-host)
		ccenv_ldflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" .ldflags-host)
	else
		ccenv_cflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" .cflags-native)
		ccenv_ldflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" .ldflags-native)
	fi

	ccenv_cflags="${ccenv_cflags#*: }"
	ccenv_ldflags="${ccenv_ldflags#*: }"

	ccenv_sysroot=$(eval $ccenv_cc $(printf '%s' "$ccenv_cflags") \
		-print-sysroot 2>/dev/null || true)

	eval 'ccenv_'${ccenv_cfgtype}'_cflags'=\'$ccenv_cflags\'
	eval 'ccenv_'${ccenv_cfgtype}'_ldflags'=\'$ccenv_ldflags\'
	eval 'ccenv_'${ccenv_cfgtype}'_sysroot'=\'$ccenv_sysroot\'

	eval 'ccenv_'${ccenv_cfgtype}'_cc'=\'$ccenv_cc\'
	eval 'ccenv_'${ccenv_cfgtype}'_cc_environment'=\'$ccenv_cc_environment\'
	eval 'ccenv_'${ccenv_cfgtype}'_dumpmachine_switch'=\'$ccenv_dumpmachine_switch\'
	eval 'ccenv_'${ccenv_cfgtype}'_pkgconf'=\'$ccenv_pkgconf\'

}

ccenv_set_cc_sysroot_vars()
{
	if [ "$ccenv_cfgtype" = 'native' ] || [ -z "$mb_sysroot" ]; then
		return 0
	fi

	cfgtest_host_section
	ccenv_switch_var="--sysroot=${mb_sysroot}"

	if cfgtest_compiler_switch_arg "${ccenv_switch_var}"; then
		printf '\n# %s sysroot: cflags and ldflags\n' "$ccenv_cfgtype" \
			>> "$ccenv_mk"

		for ccenv_make_var in '_CFLAGS_SYSROOT' '_LDFLAGS_SYSROOT'; do
			printf '%-40s= %s\n' "${ccenv_make_var}" "${ccenv_switch_var}" \
				>> "$ccenv_mk"
		done
	else
		printf '\n# %s sysroot: cflags and ldflags %s\n' "$ccenv_cfgtype" \
			'(not supported: see config.log)'                          \
			>> "$ccenv_mk"

		for ccenv_make_var in '_CFLAGS_SYSROOT' '_LDFLAGS_SYSROOT'; do
			printf '%-40s=\n' "${ccenv_make_var}" \
				>> "$ccenv_mk"
		done
	fi
}

ccenv_set_cc_switch_vars()
{
	printf '\n# %s cflags: supported compiler switches\n' "$ccenv_cfgtype" \
		>> "$ccenv_mk"

	if [ -f $mb_project_dir/project/config/ccswitch.strs ]; then
		ccenv_switch_vars=$(cat                            \
			$mb_project_dir/sofort/ccenv/ccswitch.strs  \
			$mb_project_dir/project/config/ccswitch.strs \
		| grep -v -e '^#' -e '^-Wl,'                          \
		| sort -u)
	else
		ccenv_switch_vars=$(grep -v -e '^#' -e '^-Wl,'     \
			$mb_project_dir/sofort/ccenv/ccswitch.strs  \
			| sort -u)
	fi

	if [ $ccenv_cfgtype = 'host' ]; then
		ccenv_makevar_prefix='_CFLAGS_'
		cfgtest_host_section
	else
		ccenv_makevar_prefix='_NATIVE_CFLAGS_'
		cfgtest_native_section
	fi

	for ccenv_switch_var in $(printf '%s' "$ccenv_switch_vars"); do
		ccenv_make_var=${ccenv_switch_var%=}
		ccenv_make_var=${ccenv_make_var%,}

		ccenv_make_var=${ccenv_make_var##---}
		ccenv_make_var=${ccenv_make_var##--}
		ccenv_make_var=${ccenv_make_var##-}

		ccenv_make_var=$(printf '%s' "$ccenv_make_var" \
			| sed -e 's/=/_/g' -e 's/-/_/g' -e 's/,/_/g')

		ccenv_make_var="${ccenv_makevar_prefix}${ccenv_make_var}"

		if cfgtest_compiler_switch "$ccenv_switch_var"; then
			ccenv_switch_var=${ccenv_switch_var%=}
			ccenv_switch_var=${ccenv_switch_var%,}

			printf '%-40s= %s\n' "${ccenv_make_var}" "${ccenv_switch_var}" \
				>> "$ccenv_mk"
		else
			printf '%-40s=\n' "${ccenv_make_var}" \
				>> "$ccenv_mk"
		fi
	done
}

ccenv_set_cc_linker_switch_vars()
{
	printf '\n# %s ldflags: supported compiler switches\n' "$ccenv_cfgtype" \
		>> "$ccenv_mk"

	if [ -f $mb_project_dir/project/config/ccswitch.strs ]; then
		ccenv_switch_vars=$(cat                            \
			$mb_project_dir/sofort/ccenv/ccswitch.strs  \
			$mb_project_dir/project/config/ccswitch.strs \
			| grep -e '^-Wl,'                             \
			| sort -u)
	else
		ccenv_switch_vars=$(grep -e '^-Wl,'                \
			$mb_project_dir/sofort/ccenv/ccswitch.strs  \
			| sort -u)
	fi

	if [ $ccenv_cfgtype = 'host' ]; then
		ccenv_makevar_prefix='_LDFLAGS_'
		cfgtest_host_section
	else
		ccenv_makevar_prefix='_NATIVE_LDFLAGS_'
		cfgtest_native_section
	fi

	for ccenv_switch_var in $(printf '%s' "$ccenv_switch_vars"); do
		ccenv_make_var=${ccenv_switch_var%=}
		ccenv_make_var=${ccenv_make_var%,}

		ccenv_make_var=${ccenv_make_var##---}
		ccenv_make_var=${ccenv_make_var##--}
		ccenv_make_var=${ccenv_make_var##-}

		ccenv_make_var=$(printf '%s' "$ccenv_make_var" \
			| sed -e 's/=/_/g' -e 's/-/_/g' -e 's/,/_/g')

		ccenv_make_var="${ccenv_makevar_prefix}${ccenv_make_var}"

		if cfgtest_compiler_switch "$ccenv_switch_var"; then
			ccenv_switch_var=${ccenv_switch_var%=}
			ccenv_switch_var=${ccenv_switch_var%,}

			printf '%-40s= %s\n' "${ccenv_make_var}" "${ccenv_switch_var}" \
				>> "$ccenv_mk"
		else
			printf '%-40s=\n' "${ccenv_make_var}" \
				>> "$ccenv_mk"
		fi
	done
}

ccenv_set_cc_attr_vars()
{
	if cfgtest_attr_presence 'visibility'; then
		ccenv_attr_visibility="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'nonnull'; then
		ccenv_attr_nonnull="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'format'; then
		ccenv_attr_format="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'malloc'; then
		ccenv_attr_malloc="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'noreturn'; then
		ccenv_attr_noreturn="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'deprecated'; then
		ccenv_attr_deprecated="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'unused'; then
		ccenv_attr_unused="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_presence 'always_inline'; then
		ccenv_attr_always_inline="$mb_cfgtest_attr"
	fi
}

ccenv_set_cc_attr_visibility_vars()
{
	if cfgtest_attr_visibility 'default'; then
		ccenv_attr_visibility_default="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_visibility 'hidden'; then
		ccenv_attr_visibility_hidden="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_visibility 'internal'; then
		ccenv_attr_visibility_internal="$mb_cfgtest_attr"
	fi

	if cfgtest_attr_visibility 'protected'; then
		ccenv_attr_visibility_protected="$mb_cfgtest_attr"
	fi
}

ccenv_dso_verify()
{
	ccenv_str='int foo(int x){return ++x;}'
	ccenv_cmd="$ccenv_cc -xc - -shared -o a.out"

	rm -f a.out

	printf '%s' "$ccenv_str" | $(printf %s "$ccenv_cmd") \
		> /dev/null 2>&3              \
	|| mb_disable_shared=yes

	rm -f a.out
}

ccenv_clean_up()
{
	rm -f $ccenv_image
}

ccenv_common_init()
{
	. "$mb_project_dir/sofort/ccenv/ccenv.vars"

	ccenv_cfgtype=$1
	ccenv_cfgfile="$mb_pwd/ccenv/$ccenv_cfgtype.mk"
	ccenv_cchost=

	if [ $ccenv_cfgtype = 'native' ]; then
		ccenv_makevar_prefix='NATIVE_'
		ccenv_image='./ccenv/native.a.out'
	else
		ccenv_makevar_prefix=
		ccenv_image='./ccenv/host.a.out'
	fi

	if [ $ccenv_cfgtype = 'native' ]; then
		ccenv_prefixes=
	elif [ -n "$mb_cross_compile" ]; then
		ccenv_prefixes="$mb_cross_compile"
	elif [ -n "$mb_host" ]; then
		ccenv_prefixes="$mb_host-"
	else
		ccenv_prefixes=
	fi

	if [ $ccenv_cfgtype = 'host' ]; then
		ccenv_tflags=
		ccenv_cflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" \
			OS_DSO_EXRULES=default                          \
			OS_SONAME=symlink                                \
			OS_ARCHIVE_EXT='.a'                               \
			.cflags-host)

		ccenv_cflags="${ccenv_cflags#*: }"

		ccenv_cc="$mb_user_cc"
		ccenv_cpp="$mb_user_cpp"
		ccenv_cxx="$mb_user_cxx"

		ccenv_pe_subsystem="$mb_pe_subsystem"
		ccenv_pe_image_base="$mb_pe_image_base"
	else
		ccenv_tflags=
		ccenv_cflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" \
			OS_DSO_EXRULES=default                          \
			OS_SONAME=symlink                                \
			OS_ARCHIVE_EXT='.a'                               \
			.cflags-native)

		ccenv_cflags="${ccenv_cflags#*: }"

		ccenv_cc="$mb_native_cc"
		ccenv_cpp="$mb_native_cpp"
		ccenv_cxx="$mb_native_cxx"

		ccenv_pe_subsystem="$mb_native_pe_subsystem"
		ccenv_pe_image_base="$mb_native_pe_image_base"
	fi
}

ccenv_set_characteristics()
{
	ccenv_set_cc_host
	ccenv_set_cc_bits
	ccenv_set_cc_binfmt
	ccenv_set_cc_underscore
}

ccenv_set_toolchain_variables()
{
	ccenv_common_init $1
	ccenv_set_cc
	ccenv_set_cpp
	ccenv_set_cxx
	ccenv_set_primary_tools
	ccenv_set_tool_variants
	ccenv_set_characteristics

	ccenv_set_os
	ccenv_set_os_flags
	ccenv_set_os_semantics
	ccenv_set_os_dso_format
	ccenv_set_os_dso_exrules
	ccenv_set_os_dso_linkage
	ccenv_set_os_dso_patterns
	ccenv_set_os_pe_switches
	ccenv_set_os_gate_switches
	ccenv_set_os_bsd_switches
	ccenv_set_cc_attr_vars
	ccenv_set_cc_attr_visibility_vars

	ccenv_output_defs
	ccenv_clean_up

	ccenv_set_cc_sysroot_vars
	ccenv_set_cc_switch_vars
	ccenv_set_cc_linker_switch_vars
}

ccenv_set_host_variables()
{
	output_script_status ${mb_script} \
		'detect and query host (targeted) system'

	ccenv_set_toolchain_variables 'host'
	ccenv_dso_verify
}

ccenv_set_native_variables()
{
	output_script_status ${mb_script} \
		'detect and query native (local build) system'

	if [ _$mb_ccenv_skip_native != _yes ]; then
		ccenv_set_toolchain_variables 'native'
	fi
}
