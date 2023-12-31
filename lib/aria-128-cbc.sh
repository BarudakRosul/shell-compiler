#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ\��K��2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	�ӢJ�^���j݇׾X� �}���9������!'����N"^1�@�4�'��>�I���g��(4W��9��������_��Ӫ��L�\Je)�nBf�Yb���r���9F����!��9݅������]�u������J���8��,+��N���mE����Qe�]	��/���t�Oi�a����B��ϼ&׫�]�l�7#y�,-ݩ�nj���ׅ�x�Bঘ��G-�OTF�z�q�/@���@"�kv�\m������I�Q�U�e_PV�	Q6��йM�/Ϫぷ���9O�{��a���@����Z�M����3x�Շ�Pzf!���o�lB����|�s��w�|�Mę�[��K�[εB*lIDg����`y��G,\��7ι\����b���Q���4$����p�����ءG�u�=�Q�'�𖌄^t��1kMhnx���p�ڐ���ODI`vx��>G���	e�����kU�!i :P{��4�*^���)������|�h+��HUu���N{գriߒ�O!�3K>�� �����Њ^�O�*>��d�C���׀��`q�ۢ��t�����te ���i�o#���Q:�tc4�{�����eÆmU���x/�R�����NYB���A6�p���s��@�u*�wF�!�a����U������3�
	�1 }2�>�����8~��N�;
�U��P�ȅaO�z��[�����O�5۟��*#X��[�h�(����d����=2H��a��z�x�����RZ�� ��q�@J����jmn�S
����ƭ]T��m�G]�`����6N��� ������IE�3(a���s���q:�}%��ϗ0,��W�o�	 ����}�^h�mGU���(ڔUЂ\��?��ʜ+}A��ƄH6�W�?Ā��{���Қ��)�X��=LCFp��W��"�܂��5	��"�!b���� �%á	K����p��|����C:]����+�ja�D�4ګ�N�gr흒��쎂���	���]%X�s�"dkph9��_�Χ���
��T~���02ɀ�||���?N/	>��6=A�<���6HIu`�	�5�b�2�ϧ��uk��AO�TRLr�E(^�+���`8]r��}�l���������{,�t�o��+)��F\���yꚺ7 @`��waT�(KilS��,0�	�UѲc�i*�D��z,��͎��_�
�/��v��ft4�ٹn/ ��n��V��h�ݲ��mB.�,]OɢcÌZ��� ޼���m��o����Ot���lo�� ��Dr7$�؝�vѿ)\�b��ߣ�T�=H~H:摣=hj2s���]�1δ���g� �-\�p7~2wq����3��3`P�IAm���L�.�จ�HKO��̐�<�˿Mt�K>"v�&�!��=RVr^���G8Lo3iL�zmf�E[=�c`��c1{����͔>�h�ޭ�����I	០�lnد����%ʐ)��YR6�6�׬)�8l��[q��3[x8ns�Q���f��D������M��!��/��7ܞ�`T�P��Imw!�E��	�P?�%�C����>oXe ��6f	e�{\��{���s����<3(n��#�wM�/: ��M�r����
���<�X���f�/۾Ev��Y���G�ut�U:y��D��v{���O�8�hvY�;�)�vb\.R�N�V,�:�Sߒ��#�6-J���C��6��������i�&����D�v,f����,=�!5�4V*����'�x�Mb�9�����Ug8ZAm�.��	P�[u0�f���hq�C��N>A��D@�ѳ�e
��i�臟��MI	Ȱ�.4!>�C��|Tpg�:��P��q�	�n�;����}�J�?EN(��m7��n���w,o��",���mG�}J�oi�<��$���:	%ӹ���4gq8ݬ%����B��_v�e��S�2��F�����!(��^��yVs�t��}̎qs/:4��?�&�����PD���xz�cW��E]qԓe4�K}TH_7V)�mk����3���zslT���	�f��E����K���m�PP?���Ӧ��Rd���<4A8PP!����ٝ��G��,�3-鰎�K�)>�����W�U��R�s��7�i���K�X��A� 3Х�v�%!ۀ��+�ёD X��	�6�˩��K4�	�gY��*6m0v�d&����d"�l����	�O��/t��տQ_���Bq}u����PZ��Eq����
U��hI�쓑dɋ8�E���ǡ���qг�Z�[?���.c�l�$�hbB��}���M����;�H0���Z��f,�G1��@�S��mh�`��KlA<�J���=<,�L�9.��/�ͼ'[���0��k�ｮb�����"<�5����!�d\��k���g�ו�cgY#�:Yu�钐=������r�r��CxD�Y�P{�Mڭ�����>x�6��
ȿ�c��� nN��N�����&�-:�Y���F�?�ե��)���@�}���t�Ex��^U��s�ʿ�����`�mM��c�w�O�T�����Vs �Re�G�s?�NM��Q}��{	�lq�������7�	�� �l$~DD#MZ֜��f�1_�
Ya
�߸e�QC�� �N�.��j~�Q��I���&��V��G00#
 V��'�[Ι�$0j?F�
�?*7˃GcC����
���EF��a��ڰ3�-k�����Ҽ�����퐭��/�3�e�����-d�4����D;`8�����m��Nq�{���I'�r4ыߣ�${S}(��RxF���+$�h��2U�h�scD!V�*���d&)���绘��d�O�!���ZJ�f4���	LMu=�@^}ѿ�^9ˡ�J{�K����L���2�]{\Vv,E���:	��Wλ�D
��Y�$RoN4l��(��
"Z\���ߨR^� ��]eA|�Ai��ugW)�@��?�����tII+��Ч0`�2�Qk����Ѭ�x���V���A�e��>�����T~2*OA�U�e�*XYĺ��=�a�K���(�j G:cNý��������܁��Y���g�l�9Y�gPlhBf'�섷)N�d��a�H��V���U��	�ސ��6f&�+r���� ͋F0rLH&A��^�;��MV����ZD!_�qOR*a��Rw��b�Ev�]0���v0�ф%$�Җ��>nzֳ�&f���sYj6���,�d[��f!�^M(#,T���B��[�;�hV���R������0���:T	l|����1�'h���M�Oo��P��;1�#y�7�9�27�L~b�[�E�݆|��z��D�]�Ǥ�ı��F[������i>H�mR�M��
 w���4��ͣ1���,��+_9����
- U䦌��[��=�Z��۠��_BTf�\y-������z�2���-fTo��E��7�l�f�(�5L��~�D�`�!�@�e�3%p�����ɶO�zۺͧ$��U�ʃ�����w'IƘ��w�Aܯ��`=�r  0-s��R@c��xU�a���H;'RzCV>5��Ó�96d�Tz?��3[�����3q^DQ抳��/*W�ݾ/�U��!����̴?%��N��{�^�\T�۬��"f?UJi\߿<0�<J�xz�o�Ҫי�v��0�?�&�	]�W�1��ߖvA���v���������,]��n�,փ��u�A}G�ٱrj9i?�^��'먡�aA�wh���q6��k�C��-���b�>S���`��%
�P�X-.+�e��������w�����3��_���rMl�tW&�]���1��t�2[��H$Cږ4D�WJ��e�_��n�Ŏo�'�$���a@W��ͫ]���4��@�i6e�N�_�Z�\>�:VE|9]�z ӷ�M葤��D%�7b#����^x�