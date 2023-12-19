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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�/b7�9�]p�Ǐ�!�I&O�f�&6����w��O�A�wů��)�����Fz	�(F�p0��i�f�x��B�V90	6by��B�=SGc�pl��!�xg�P�9�}pJ��W_\�yi*��K �D���\�OtH��iZ.W����,<`\�x��D��Yr��e�~x��pz5�R#	obl1T���
6�_����������/G�[KC@�s�M���UQ}@ `1��ۙ5�ijN�-�<N�N�����#�h]��&XyM�O�{ w�j���[R�o"�̺�k8���HB�;XH�f��������+J�	X���<a�v����jް ���X���s���a(J�|~���x)���3������n��D�8%�C��MS=վ�-�`�c0R>bڱ�����&U'� 9���y	�v"�N����B���8���ߍeKLx9�=��#x������� �C֞!ſq2C�Z���31��XW�h�z�7��{Z7��]#cOo�.}�O�j��_�r��x�\)p�H����|�V���4e[?��T;z�?`�}A������ �jοA�c�؀���Z*� �*O5FGVF��X�Q%c��X�f�՝��~Z�h��NMu�'�%����ܶ��]7˅��m؃�U�D��rp�T7�<�gS}>G���,v�(�>�֦l ���B���M��f/%+�)��H��4ך0bЦ (�����r��}���I�̻��"�[�R~�[E��r$ 	���S����L�bd��G�5C������@Pp v�ʖ�-�Z�kg�D�C�����������%T��7�'�k�^�y7XO;�	x_���5pݳ�ULCPM�3�c�_o�����Z]r��1.c^_%(pa@e�x�͍Ί�������v��-r���_G>W�eQ�ʙ�a㦬�9���)k��IYK�&�6�cf
�hE��������)��E���`^8`� ����Z��I�.���`Ol��՜"��!��((	�Z�j�
0i 4�z�{*S��ֺ�)�ǽ]�؝~��?�]^z	Q�<eH�O�l�֧{�K������:��U(L��b�e�IR$-t���r��c�8z�K��@�ǋo�I$�s��q�/�h�2V��]���C�'�v_���֬Y�9��컭�k"Bo=�f���_3����T����=p�ǋ�Ny��_�WizW�4�z������+I�m�~�)����,���Ok���t�M?ϥn2���7Ej�dY�,V��~��	������
_Գ@���9�� �­�Ƌ��ID_A��&��&3�wfY,�S�r���X%lF����@R��!�ge��=[��]f��Ƌ=��k쭓�;*�B杴_�R�R+Y�a�<Ty/.j`�����Cr�3���_���E=j�:��'7g�!��>�~Z��QZ�>���F����v��{!l�1�:~��7��- M/�n��
����WJ��t� �s<ڏ�d:O83Gc0'�B���c���o�֘W�+��[}�ٮ�q��?A��^�Pu\=B�|̡�M3\A��ZAju�5]%ъ�����Φ[��������ԋ����lE�ٓ�Ѱk1c��T���XQ�Q�(SQ[�!�6�8$ķ�e{��J6�T����5�Ց�Xhs�l�tb5��m��J�!3��n O�
�� ��D�/�Фa�R)���@�N�v-Cp��b�����o�?Dخ�X޹���F�3�}5��}?$fA�:����(1N���yC&:s���������^9:���9V]�c��Om�Z�`p��"z�1�6��UF_� '��	�M��3݈f��u�ܥ��kI;�lIW{_|�ޞU$D(oܝ��4�qm�/B,4��XE��f{� �)F,2$?�t�X?;�S��8�!q8�Ư�m^M�m�;��w��*A�'b�v�Tgvg���0&���^W+��A���(lo�崫R�u��kf���q�q�ͺ?=B�'4��cS�_;%��Fĸ6�N�Ȣ����� ��:� �8��ylW#wX/戅}�t+ewJC���P�QQ'@� 63u^YF�ŖO����I����[m�r��[BH�Qw$��\�lH�@QYc?pt���&��DM���W��Ȍ�Cc�+٨��-ȖPmE`��/'}+9���&VS�_C�2X͊�u���l�Ƅ�T��_���
4#�'��jg	�+�v���@�@l��)�ǝ��l�,�x���&UIST�!{>��#�#�~�>U�����g����P�K�L�ؿR�@ MG�B�.��('�:�:ʅ��\#@?���|�	��9c�i��(�1�r�#r���z�3�����2^��⛤�.y�*��K5P���P[Ș�B%v�����P��Vj���v������Q�$�)N>�����t$F<V�9����ܪ��{5N�C�il �E'U��&U;|�F(L�_qJQ��r	��L�[��2�`��\� �0eKG<rH�hչpğ��Ǌ[�7��}c��zJ�� |����f�
�ǩ�7��������U��l��9!�T���mHx�%e�3���/=���[k@2�X��zƞoKʲ��i��6fkw>z*�!���n%6��x�h��Y7 Q�,7��}E��o��`d�D�s���{S~�� �sZI�t����N���ؼ��S�4��ou�dK�0w�~;���$g��ȿam��,�Ȇ�Ue���^l���J��mˠr��_�i�C'��lK�n��]�*!>o�b"��f*>�)����S�G��.q�t�-�T_�ʍ+�����>�
�X�"���\��T��iM�Kw[j����� [����##��hctu�cG�]"�.�u�p�R2b#L������B|�eȞSO�@5�Jq�aVSքB��}W	ۧ��YX2z��	�*b�;�v;�;R�b�=]bbGT��t���DW�s*�4�J�����E#hL$�=��egR������+%:W'��&�J��Q?X]C�cĀ@Ih��S\��y͂�-���a$���v����(�$޽K��(��iWa^���ΐ��K'�u'pE��Np��wc�c�`�X�� ��x{�2�F���"*�������G�����_��𢣁6�5�c���|'��ڸ��D��>��b��	Š��љ?���O�z<�H��8����tN?3U��[���X��yƃ����N� �w�����6}~{k8,���`|�w�@D�x��Y+�:X����~j@��} o`��������57����/�=��۳������.1�0�����˛������]g�!�_Ke"U8�pX���M�}�9�Ap�O�)3sk�N��ً茯ܪ�{���KZ�bⳓ�-�í	Y��&-ޝU�\ȕ쪚�f>dDtf5������A���wc�Ȅ���ĭCB�֔,���t<�M�wJ��]ވ�7a�ΐ�$�V�X�,�ԁ=Tu�G6Ff�D�l�����Y�)��e�s����������ӫ��/(��t��kl��mh��d�]+�\���
aF��p۾�]hB�D O�P��W*#k61�Q�������7I�a���=���{=�13j�_�TH�
�$cc		�<%���Zn�8�A3�H��$�<����R���\�l�8��EvKF��1����f<d�S)�0�����ҵįX�6��,���RJ��lL�s�H4Q[�a!�@^���MA��%������֝H���5%��u{���Н��z����2¶aZ\�S�*S��t�-�ѩЀ�~ۅF}���' n���/�Pų�ˉ���'U�Q���R	T�a����մR�׫3⃞�1�� (2��.�`�Bݙs�>e/����84f��}>4���v��c}��2�r�%v�`Z���&�Ǚ�v��\YZ)/�<&{m�PCC�3~r5�����v�Nҧ$����u�2�i0�`�
+�e�2��&��qm�7�~�L��m7	���`���9�<u?��4���䗉ZI�^S�#�>�륋��-��4������TK.�;����l@-_%%VnR�h0���������{ 