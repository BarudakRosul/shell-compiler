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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Є/zN�=LgI���
��r�����<�G�	'_�4d����2G~C�." R�#�� *}Z5=���;�s����8��~���q5%�y���� kZϰ�Jٗ�A�\����+7����b�)�m��u����
�D_�S���#R�iy���|�|��\}0�!xn��C��=[cچ���O-����DU��,�?>!^��p�:\��V�䶴T���#�ת���iW5��"\���]�|l �
;�20�w	�@#��� �6y#"��^�������Oo�T��PJ
����?�>�g8 �b�����ms�APmu����.��4��c�֋�V��41�Kvs��K�Gj�K�~����p0��/E��W����'�R��^�}M�h�����?�f�*#�ޛ�x�k@�2��z�[( ����ך�B�(qD��	£_�B(G��~�k����%���G��
z.H{o���a#Kn|�^��v,��[�e@����ʾ08�)�6H7`��f���=&t]UJ�Ŝ��%�t���n��&5;��9��\#�J�|\�4�q�M�-�;��
��Ȣl��!�	�S׾�+�|�ؚ�1q&�	�������9���yWJ�L�slmfї�T��kV���Ok溣�7����R�����*�l���WN7��
ó|?�-��ｂ��:$�E$�d�	W�]~OyQ��̶r@x�S�j��ǣOM�OP�F��>�oU�����M���CZ�'KK�$�-i�������Xw-��QK;ȭ�L,U�m*j�z_hwQ��һ���-QI��0���ڞRj�Q�\�X5S�.��1�٠�'/�l|�&�:e0[Y��5 ����E��l4�9�����]����_�w*oʇ.�g͜ћ� ��D*��=�Vd��(��d�lXO=���[�rd�j��y�AmS=Ȳ���0���Ǖv'-/1��Bb���$����7e�D,�^�?*i��6j�i@���8̘F�#T�1�L���C���~@���_�*�%"�(e�z���� �1GEV1�21���zd��F%kgsR����Y`e�s���&B�)�A���vdW�:�Z�B��Y��n��S��f����9%��h���D�����������Z�+��{�$��5�IUwj�<Y�X�c"��Z��"���\�.�r�R:��K��QJ󖒝��H�������Jwwʇ5<S��8�6���zC����b�jQ6�17�����i�v�f�G>h�]�f�!��%�+7È;Jt����_?C����T4���h�;�����%uM��B������й+WJK�%��A9a@I�e�9m�W-�"ϕ�=����%��!-ϊ"mV�U9%jx���#`�+�^����`�@A��S~����U��[T%(��Q*�hW^\lo� ��?֫�%O�W�gT�]��)q'^*.冮5�.�֪��G��eM��j�F�=4��*eѩ�4�gpب8B]������|�ݹtP4�ߕ�7���HaB�.DܓCY�$Jb���^qUy �H��$ɓڷ��,)2�� �ɕ�%<�x'���eqUx@�FF0�O�(,䉜T&�8V�����ց�z��g��y��1&��1�'�*���&�tf���vn��o�}p�/�l��#$�!!�d�R�9Rv*�_�`��:���#l����/w�����%'���3��~�;/�lq��x�lPE4^7�"��j��O�ܸ]�\B�{�>�\�(�LG�0e�(��VP��xf�1�@MavΣP�Qj$d۩���q&� ����!B,��M�F��}��i<gԬ�U�CV+�u��:��H#��{[��Kx�a�vwO�E�e��:{�o��D��kubQ#\��cY�wV�����@�n�G�V���b�^@�q�B�x�����+y�q�J�7��ܰ�Y�����9�`(�(֛��Ϗ
����sǔRnT���h0I)���T�O�.��eveJ�;��r��<��Y����1�C��(��O�N�Gg�a�
i)���~�)�g��fn1�{�F}�=̽�`!��Y��J7�����A��N��*���X�ksX潁�x�}���M�:���t.�}&)��B�ˌ =e����J@`%���a_��*9A�\kO�|@ h��;�-7�l�k��41Yo�����"��BC�8u(ڌZ,�%01�l�?��컦\"IC$��jK�d��Җk"��+�4�%��̻�".A8�)�z`��	>��EPb��q;���&Q�=ٍ9��82t�D�d;n|��U%���~�=��b���'�&��ǘ��z��1�t,��Y��]�#�{ST�HܧF�Z�ɮ��óo��tgg#��)~�8eO���ho�1��-v���K�h�ԯ�$���޷����/��#$Ě���AI�)�ШIl�_|N4��GXDi������՛d�ɸ���Pn�l�`,��򵚮���sx_�z��y��2p$-�~ǀ@ŪZhz~�oQ��V2������[�M��1+�Z��v�*��h�i��]c*Y���Q����Z�C�m��8h�tv.Dd- ����%h�0-x�ˎd0�Kao�L�WJ*֝eDȜ�5T�D�n1[Jm�Dp
~���/r��Q�됰ў���u9T�qDYL�"��i����y��	lF����S������+��.�8��|�J��0�up��8��N�r�A��X�xh�{�h(���#m�w$)W��	5�C2��% н���4ep��:"�M��+%<����x;��<&zuǷ�>kԫ��{����?0SGRȉ�Н\5�X�A�Ҭ���Le�6�E�:�Z��O�tψϲ.ً~����ǵ�����]�c��Y�[+����Q�?
�>�0����m����Ej�Q
t!M�`��D�?#�2��s����;��g���Lp��Ql�[���gl�$��
�R��.9pͦ��GdQVYQ��iA ���Y�%��w��O�&��#,��"�M�{�Md:ұ�i�2?ϲ�l�P�Q��y)�GAp�k"m�Ҵ�6��rY��3-\lFF�p/wT����=��-��NS'Jk���2��j�*ƥB�ޢ�5*�pI�k9H!�~��L��hBb],ѫ	Í�*N�q���9{����L4ca�|�9�H���/2�+wќτ�� ��V��;�����Dd�('[eL1�G��.����?��f*��Q���Bb/��ڽ0��k����sP!H��n�6���p�r����_���uw��N�H�4�!�W��z��u��cH.� {�4TQ+r��E��d�M!%����Ul��Ĉ9������{:�4_?�� "
"�{OF���DI�3}Ɠ!�.���s�A�*T�0epl	62jo=�t���j��ѯڔ����j�5�� -#�h���]�3 O�a.��PH�ߘ�9�1 ��}�9e�r#&ֲ+lz`$ą_�Ov���:>�Ǎ���b�胋�?g�� �wV���N�N��hNr[��]�N�W�� ���w�V�:-��bq�o!s�(�
�����D3ͯ�3��f�7���bF\/����nfr#'TЦ%]A���ݬ�YH���ö.�A,9��t�z�J=4BxU��X�|2�v�!+�m��y�!ƀ�������n�9��|ja�]���!P��c�;����f�����8NU����h��������> ��GK�TF��wW�TzAx��� �۰�·�zW�~��f�>������P��t_�ʾ�Ɋ�*
�2��s���~�zN2�58Z�7��c½?c5��_�S����W�`��v�J������r^��o��$!��1Y6�J�0)g�qpy1[�̰�<�Vq�9aF�o�)m�7a6��ӿ�a�qft�{���3����k�0=�z]�Cr��[�c�6$Ub�j���E[Ѱfe�B����