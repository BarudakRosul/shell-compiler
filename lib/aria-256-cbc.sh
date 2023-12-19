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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЎCK��k�
�#fM�uo���m�y]-�84��tG���T�nP���; ~DE�q�ƅ�J��0.p���;����V	��\�j�����|X]S����WE��y�j��o(�g~_dB���G��'/[e^����r�4C�Ϭ�UYy!o�t,��c�c�h�R#�Rl����x<�~���\E/�q�'�3�C(
6�_����������/G�[IKH�Kd�gk`/v��b4�Xs���:&K�2d!v�w����@����x��<Ծ��c`��	��ԇ�����P��Z���Y�Vs�!_�+� �Z�G��
v
+́h��k�ݕ�!��@C��*X��Gtܖuk�@���C�F���Ϛ��p$t1P�VL�j�
���������6���7;��ۓs~%�F�Vq�Z�H�t����=2tH[�����'J�{���W���������R6�s2��5��C��W���{]��	�$բ�9O� �Nc��h��M?n��������z��u�dVh�w����� e�愶�#\���u^s�m���V0���1��`5?U��4�%coK���q4~ D��SgSl��V/Uz#ۄ:
I��r�Z����B��)GS�XdU$�O���D�kŊ�gю�����)�o����{�����zS�J�?OQ7�����t�&�059��t�7����jM�U tw�2y�=��u�$�-��#%˸���z��-�'A+��ȲB� ���dhOK�`W$�[��XEۻ��E�6C���O&d��4��P_pӰ>�|���4�F,�|ʋ��۲+�1�+n�ͣe��O��}�E3�o`��o=ŭ[�o\m�BN�FKTԞ�-�P���r+�!���0�Q):���)�6�i0A㫧�7�������?.M�T�<� 8�m8?>j2�I.x����!����z=-��	����h�� إW�P�C=[� ѐ�J2Jj=e�H�M���ھ�T�Ep�,���n��U��ףq�@���.|�~3�{aJ�}�x���0���\X,$�44.�Y�^��o��u���E��S��v�Hed��3�Jue����ߒb�@��%O�cU��~}��x�	��c��^,r��������
�����d��#j��^��bY-�[*yޒh0ⲃ϶���'!�	m��C�����o07Ι������h.u�|�p��!�s�F��n49]�ش��	���1�TBf#_C��������k'V��rݍ�����Ä�# U&�-�̛����vU���$�˨�K�E����q�{��q�ͅ�N�Z�X��z�=s]xr VO
��j8�kn.�5�$Jv�L^ڱ4ۥ�b��[NG'�`!��y�J��B�nA���3��q�$�~~�q1����4���GZZ��@X� ���K�� G�w}�"V��
�ت��ø���G���Z[���հ`7��2t�򶿔�6�HƆ�$��>��t�עD�
�ZS_X���SSV�<��s�7�b�0��{a�|��c�|��.�i��%p�؆�BY+=�M���9�֜#�]޶�9ůN5��Y�&۵�9U�t
�6����w1�ځ7\�iL���90p�5�aH��HP|o�KMC���i\�5y��+,���z�ºHYLm�ж�.&��Z��F��Cx'�@�O�C�#�_�������~7�=TZ��?xa��NlN^�~�M����A�O>�m������*��E!c���扗H��?�d@ўH��K5J"�y���S�=��~�<�C��I�ײR
��O$4>�輣�w<�+e=�Xz�4u�`N4m��:�^O�	����PXo	��A~c��ϼw��7Y�!�����T:oP�ñLS��f�}�z���O��Ӡ���%=�QֱeD�gOhK��c�#��<|�ts�U$.�m���v��W՚E�y�������4ճ�����	�{�ר!��Ã|�]Td�G��G���ZP�tZZ~���'2�RV��37h�2�K%�rZ�y˯|!�nס�GoF/1�5m���՜<>OUb55�i�2z��ɵ�0�g�����`\���ڠ�:��|d���6^�i�Iŗ�-�tv�*Gi|#?~���/�Y|�朹`-
2	�{��>CS­0����ᵕ��/�݅sO��"�:w��?�������Lh���{�:��HC��F|g4lX�ϓ+�q��8]�65����r�C@�L�o4��6q���"�آk~��x�dp1�,�D�1e�M����&�e�TsC��Z=�g�c&�-3KgGu�5_���*�,;�@�����Ю�m}y���j��*�
����$:,G�++\��544��ׯ��W�h_bJ�Qewnj���f��ę��lH��q}����Ҷ�?E��]{��z�>�$� ���@�
+�ФA��7;J�]�3�7�E��#���G���v]��/�F�/=_���HbGF+���s��W@^�1���c�j��ig�z^��e�u
{�]����-5��D���L+�`�*5��N���j{=��72��N��)2��Z`���l�[�����p��oCQ�
����L̎���o?G5[3�儲vN��"2#`G4(�h_[��z�I�5rM�[�UM��Uф#
+@�Rp���"J	\ё��Y��D����}���%�Q���^�)ǵ#��%�j90��uxL�z�D���Q�Q�ߦN�a����3M`z�)kDV��տCvk߆	��:��aP�ȘMѷ�b�p��I�u@k�?)�]��}Y����l�g��h��:��r�;�����W����p�vA��!���V��`����>&ZY��34
���Ϡ���/�8Vk���CUMN�H2i��A���-9Ըz�r�<$�P��^��oJI8���(v^�ڝ0u����	"�V� ���w�J^�I_�gsOW��X�XYբ������ǈ{�g����?YF��A&��8�=�y����1�vS�7��k[��l2�RK=߄��k�(�d���H����Ot[j�%0T�T=Ѻ���u2��}����iI�������L[�iz���$^����9y�T�N�0��[R?�[4���z�y�-�0����3-���Rj�FŠ��Gh�oL���5(;.h"4�!����0dgfS�u��-����*�c�r����{ s��ԳbK�L)cE�D��Z�^�I2<j��2����`�e��i��y����l_D�8��Є�����hH*��X[�i�"���ec��=S�tl���䅹)� ��
v�$��͜x����"��������0�%�D���	�X�\�M�� (Ƚvm��|�5�C�ؠ��{Ew`�[ܶ�3��Sٜ5!�6�����(xf�{g��i���3O!�����楘&-_/|�mJH��Jڵ�I,ƫ󶵎x��c�R�����ӧr��(�Â)���T.}�EE�v;F�:+Շ��]�n��t٢�9}�/5o.��SqлHl����PZ}���]iV�s]�D���}�+k�pO���
p{:��^`�:��-�Oct�"/�d��k$����P������3!�ɼ��G=5�o��nw	�x c�.q�n�D��Z&��>a��^�N-�{�'oo�G#�$ ��S�PH:?�|�{2PF����v!o  ͯU��O��k�-w[^�Ю�J������Xޤ�P]� q=_/�#%��}�o�����@@T�'0{GG��̪@v�476�ݿM�= �N�f��"U��oP3�Jc�EU�$�Qg�Ǘᄚ����F�'c"[�;w��*�IY�>	�-��H��UZ���� /U�K���QV'�B:,+�z9�I5��B.#��U�3q7!�e0]��\З4�뀳<��6e�Brm�� G@d>�����t�ؒ�і�~�{�[�.*۩��a�\K����K�$��:�=�b�;yz�ݵJ�p��!RvQKI�w��{�(q��ؗ��!��}�%^�=��OA+"*���fI���a�������*��	�w=���_k)"At"B�7B���10zq�ׁ��n1���TK7"�|5��2��������S�|+]��E���&-