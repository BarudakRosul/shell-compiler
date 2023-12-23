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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Є:��������#�9E\S�)
�}0t�x�7?U�)b#��Ya��D��ճ������_��|��q1�SVb��nG�:%�S��L��Hճ�8�hDF��_��vvg����mT���-���V�|���^���Ғ'ᖨ��[�m��ߢz[�|O�b8_�$��JfT4����;z�{&�X���@�!�;�y9va��c�ſ���h1���dQ	�ʼcL)����	*/2�ذ}bs/PU��׵;�D��(DrJ������ؿ��:�FV�Ȱ��}Ҧ;�����M��4�K+�%�i�+�0w�'��U>������������s�����T����~?_������*����3����I^�f��7VE���λ����	��E�Wp8�Y�Lye,�\ʲ�Vt� �����/.�������u���-[�&nnһ��g7M=E$�X���_�L%�X��Nr
CvWe���Ზ��V��h�zt�F�D|���SR����y|6��
0��3��J�Og^UF�N�%�D%��y��vzţ�SQE��!�=������p�z�h^ XbW`?�,�h�H"T壯>��֙e4t|��zGT̟�&��k��a#$Έ���VU0�p��P4L��tES���m�?Kq��nrr՝E�U����!��x�P"�r���vrQ�p7�r<��.:zJ?i)�T5e`���bd�"�52�R1~	�=�8�@���)����mu����N�K���wJZ�O��xsլ�[�󷛜�Q�H��N���J١9��̋�Qg$1u��6��cY�mxb� .5��
�crߓ�>��z�������-����M�|���$����Պ�ݵ</c����{kc;7�-��~��?�bb���.�Yd-)&PPg�QOR���fܬ�j�G�^i�'�|�Ƒ�~:�O�HBq��p/��k��|�fs��c�]7O�V }_��ts�uY���M���F����s���`�/���¨I[<�����D��'�8�gl����Z�?����S�n<�^=����C�l�$98A��\�g7O�^d�Ƴp�I�,�����������}��Ӷg���F�00���}��ł\U�߳j����/���D�<�QIL����D9�¦0F� ������&6�h/#��+�7�k��E���1O�!s�^��?/�B�d�I�i4{�ٖ�v�(������Z~#;�|�*fU7,d𪄎$���wk�DL�/d���V*�$4�t�����3W��I�P�s�xyT���)�}u��e��ᤧj������f��~�mj�f�>��~��c�]}�P�}��?|>:x0o�sQ��X�S��4��?��GXRZ;���J%�+�O �9i�����-r��=�j<w����E�Y�\@�����05���J��ɳ�W}�|2����)��?��Ԫ�����A\�2K��:_NP��P�n�}������4�Ri�X�5J�]��4���w�24�v�:+pxx�3�V�.j�\���˩�7�6��f�B�Z ���@U�G�-�z8���0M�) ������[>��!�Vp:�.;�9��-�������M�
�������n:pI"�Oh`\�NTz_���r��s���"�5�\� �W
Dp���~Ty�z"s�,V�f�_!-�0c�~�\IH�N���uàA��&��
ǚ�ǯ�������n{����X�Vå�0݊���n�)$�p�`/3�]����������CuD��B*��d?"}<��e
#�v�:p����ԃE+���d�/l��fY �G�����1nN���6���P+�e�}��^Ʀ�W��3I��A�"����V\�%��
�*�r�� �ǅz=��YZ� 	ҡ~��'3��Ye�_��@��A]�Uh��v%�cv��$8���BJ�ٮV�),�߾���+�̘DX⓾9��|�xRn�Ѵ���ƍYO�R��R� ӓL����y����p��>Aty^���<f���P'�����	���Q�y��b�[6�s��mS\���ͮ���I;��-�sN5A����-������1Ʒ��H �lm'�y���݅�x�lɆ"��CT�G!�uUۦc�G���/߳FR�v �[�o��	y�#_�s�I[��=�sa��KҶ�FT!8��+F��/�cx�_����M!�~f�U����-h�ƫE��k٧�6t��9���OiF�x{/�Ih��������oj���`��]��Y؃��O�S����8	4x���Ύ���vQ.k�YN�����c�r?�b��������ƺRL�L�����6�Z�k ��Sv�
��j�%7�+��5�Ï�?^�i��0B���cX=�������;��r��8X��2\l�t���뇴�ڞ�2ͪ�!@��k��l���������awQ�|Ĺ�gt$P����t~�}&rw�Ʊ��TT��)P��b��i/g��E/y����"_��|�"���Z����-Y����e��Q�����IZE�1�/���󕚌8ۆv'\]�{U+�4�l��/"3R�2Ր
M��R�O��lZB�<� P �����,�l��[��O���w-v���oba����R�̙:c�tt�i5j}ܳx���]s{-�>m�`�U�Z�R{�Lj��L�G2〠a����-����&�:�Il�7��8]+t-�\��iz�@��{td@�* �������b��	���(�=x��M2��M���55/���� Ȟ��1�����g�TA�
��?
���,I7����m�d՟y�R=��.#����#gln�,f�!����˥_���
P��_ް	0�u�~#д\�LM��j��S?�&.�=G����	��̑Y��x�z���~�^�l3돫װG�,�c����,�:|(����y��6&4� !����Π�h��A���k�����|Xp�n3n$)�ץ�k����RO�i�4���M��hЁ��OQ�%�ۿ�m;ت�w�I�`�)!�1����ۈ�wl�?���S�z�>�;������fS��S�'�8�@>�0!ͪ��� <x�ŋ�N���x�]&~,�Q��Px^%���+7�0�e��6��DYͧ��>�*�(�$Y�g	K��;�.z�
A�i���[��Ze�a1��N[��G��5���}l�8*<���2��wK2M���@����;"%�K�6&n�=#)�	:���s�tp�Of����V�ySp�ԗ5�� ��|�}�'�C����#���)�� PA[=�F�n�%^���R�M2��~w�a�.����*�|����e��x���a� '���gb��|Ή1����g>Xb�BmuP �i��K`�L�XTE������xY|~��T�K��)��$n^�<�V�����飤�㗇�}S���'� {Jxz��"���JU��L�X ��775�������4���uB0؛�f��Ŕ�l�J"KI�)p8�-�Z�1ֆ_h�T(# 7��6yŉ.7��'=fj��Цv}��Ot����������̖wQP��|p���Ne���F��1������A@t����Y�0սh���s��P1y�W k灊�0��2Y���F@���V#y*����Qk�
3�,݅*�Zir�F��V�>k�.z�K�����5��AW��l�J<�n:t�5�?�(*��h�/f������y�q)�iN��@�,����#�G)ƛ�g�[3��0���N�tZ	X���J���9�r�]��C-��c�@�/}xs%�M]����B����G�/m��1M#���f�.�P_7��Ƚ ��n.y~N6U�t1a� 4��\�L�N2���#�&�iC����I-�4kO��D{�=<�N��V/bk� {��Ā�Dg�Gε��pH��:�N�kYhs���