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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Љ#2ojk�}�?��1Z~@�<�r�}�L�2,5w�̎Ίǆ^�3}����1m�~�?�:�z�)8�����}|�4�w�}E�ZC����7ɚ�������W�X
o#~�҂5�W�C�:���ޛ��ANeM��U�G��D�HM�.<��Y�B���S�F�I�jY���δ�A-C+9��?؟L����6͗f��y�3��@�ͩ�l17�?4D�f��R��ӄ7�(K�B<��8���&�Ɣ�˓�����g�={!垐�����5k� 2�m�ȁ�-�#tf�?pCT\�����u2�4��`@���S�4�:����)ԋ�*�ry���.�	�ݫC��\!,ZS�^����n�(-	B��M� ���/Д�gd8�.w�A�x::D��X*�-&���F�<�K�뀕�/�ff3�LtK�Ȝp�X�`@��8�4��P� ��������W��!�^ϖ���}`��cu���i�U(+<Pp�
[�)��ǙAE�'JBwo��_�A<�}! ��FAJ&�R��i�{_&5���I=/���IPzҲw~`~@�3l0#������Ģ�%�A	s������j��J$��T�C9��c.e���EF2x?�6d�+b�����c�t٦nݍ��z��2[�NO�?�Y��A���ك�@:�ϴ
 �b���c+�^͓�(���V�`>�W]0�弑|;�D%%�BhH������8�8�av^ې��\��ma�-dHE���^�f�?k���P�&X��ٽ���!�Ȳ�9R1`r��Kw�$���R@L	6����1-���Eʖm��}��١���9E�tae�\�� R�v��p�;zB|�7s�&�ʵpަ��0����wk�JG��T��������3��ba#.��׮a�)cS����^��A�rߍ!�F���0�^8=�v��Y��,�Y���>l����r�Yd���3CĕH����!/�٢j�<4ٲ�H�I9��?#f�׈��0���yi������Ib�5�ڟ��7�I	�Bl"�)�05C��|l�{oa���{�DFg!�L�A�g�Ny��c��`��+O��<鯱N�s[QU��ߟ���G�?Uv�O�E��ӡ�xE��?������2������J~ji?����MX83���C2Y/l�2������t7nD��*��2�&�6��BcQ���	���ZKc�tԾ~ד(c*��ZJS?��� �&��a��F�.T��s�8�V�$�.�Ⱦ�����K��# 9��p��ie��)l7/�.#{촋���bG�*�g�d� �zρ��q݂�l�X�kE�e^q�y��+��%S]^ډE��Ѧ�S[>�sG���N%�w�۠�-<�VW�M��L�NET��+X,$�&�=6p���lάN0�Ǉ�x�PR��ICY�^(��>��Q�_z��`��	g�e�b�p����8 ��k\
����(�e�Ͼ-���n�Vɨ���]`d�Zv��կ�����5e�T�!����A���[����I�&:��ΐ����k��Qm��ٳa�Cї@W���6M�ѭ���"�]�	f����Dw�����}7`�RB��T�L�x��;�w��"�jz;�GhNl+=����jh�a��/�|���P����Z8������B�f��]�aS���)��f/I���8ųkZ���zg�W &/��|#����0�s��s����s%"��s9������\n��������� ��"��j����E��,TYt;X��[x��h��U���V��,+z���}�� �d�'�y� �.��z,��kj0qZ;� [w��n׺x��6)��(74����9�Z,��:zW�G�NF���1��w ���U�)a ����xt-�'=uHA�k$W��xU��0c�^V��VvtJw.���)��@j���&��'R��&ZiY>M�f ֑_--H����?�jʇ�a�n���V��{��X���=���.�e�<������x��e��e��q*�@������ҏ(�J3��O��q���:V�S��h����sE�-;8r��Bud��X�҈�H��D�n�9ooy� ����k��ga��r�����F@P�;��:��Y�HS�9Q[�S����O��Ɨ��em~#��/o�8G��[��;�o���E��$mC�uI�~���KO����V��#�CYb��{{Xh�X���{�F��#�&�.JS�����W����sW�g̠���1W'�/����^T˪wܮ�B��m�]K��=�����m���0h���Fk-�߸�]��8�H�y���C��7��M� �G0%���zk�Oz�>�R�S��]����x��I0���T£p�P΁��9����X�F�7z������](5�C��vX����`���ӫ��8��/7dy�e�˹�����gк�OWJ�v$�j!@ܙc۠	����%�MN�6���/��l#����"� ��5mֆ���=,���o�xE��b��϶��6���e�IBU���F��ܾ��$秒R$�zL�m�����2�G�y�"��]Yy�h��]��.�����$G�L?Q-��O�JX��R�S6�L�#�3K��q�,El(�os̾P�����[lHs0$)��(`\�[�1t7��Ə���U��m}u�����dB�P����i+��	x-QzbB���.��4���{N�x�����DuUPg1�����~�X��پ��uDggE��c��$v�?B�ݽ82�T�����<��t��ᤂo��
eX=�C���0�Ċ|�6^�A-.���cW5�-��Fw�w�*�@Tcº�\ر��!���b�D�
Ɨt<K�:��u\�elkf�I>�F�3;׿��6�nc�B𨯽���{����l�gM�ӼɒiG�R�A�B�5��>�k���&(��fv���N��˲W|���f��j���"�y<u铦_i�C?Y5�����@���4K�nMߣ�s�Ҁ ���"�B���<�1�d5����y��ENm���X���5�.�d{w�=T/�kZ$��3��=�����ܔ�a����r�����m�y�� n;k�G��N�6�u4�D.���u2I4p�4>B��������c�������7��%���H�k�p�1�ٝ
?��'t��OP8��^2e%����Y/-$�DY4�(��{�5�oQ��p�׊E|�F�n0:��O̜��b�����J��Z��� 5�1�46�����$�x�ݷjq>o0ں�{��x�R���n�)�
��M20��m����b�}0���{]�l�n�IPZ[�*א�Ӵ���%פ�W>��"���xH�5����1ґu���F!��һ�#lߙ�g�)���,g����'DL���>�t�T�H��|+쵢us����<T0�	��Yx@|i���KZ7�a�4t6�)Ė�v���ɩ4��Xk%��t1mce�y���� B��8E���O؜�HF�/�BUBͯ}S�GdW#�H��m�%�F�Y��꒖�Ew�'v�)�d�sG}��-��ƾ��\���8e)i�%>�Z����~�� q���di�w�c7�m�7xfJ��jW��$
��jZJ�W��^�����/�A[7KH�ʷ�����0��r���!l�(�^��N�m�r,��{�Hφ�kw���נ�����R��D�*��4I�z���WB�t�;�	�/�&�x=7�4W��x�#]�ղ�T���n	�@{[�χ=�)h����|5����Me�k'�0ᲹQ�?(;Y��v/�Q�5'���y����Y!��8
�,�a���g��@�০#*�,��%���l��b�����X�%ޚ��N3��d���	Ui�T�{�}?|IV�� +T _е��3�젺��`���uS�@�� ��4e3@���]���u���L�o�[U
� �m�B����������t$Fؠ>�ex��OZ����Yͫ�d�Ʀz�o�������`տ