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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЎL+�kC�
�#fM�uo���m�y]-�84��tG���T�nP���; ~DE�q�ƅ�J��0.p���;����V	��\�j�����|X]S����WE��y�j��o(�g~_dB���G��'/[e^����r�4C�Ϭ�UYy!o�t,��c�c�h�R#�Rl����x<�~���\E/�q�'�3�C(
6�_����������/G�[IKH�Kd�gk`/v��b4�Xs���:&K�2d�?�{l�l%Ӽl=�d;P�OJ�����i��$��$�p�Z�^8����+6nM���-��@�&��-U��m�)c�;D��=F�G�`4n@��_E2c�Л�T�Kj9_��Ť �@#Os4�4>aҙ����{�����7�,�M��2�T=e=PB2�`����e�����a͔��S������GF��b%��s:��U�(���
��o6��A��1�Ne^�(XQ����V(��v_�ӺݵL�7(�G���:�(�����svyb ��Ї<�kd�P�̋����F'|�e�684��>{��F�E}�>)�����<sYbi��.�d{���]��'4g(m�JXpD��w�G�@���: �Z�@���fy��������~�6���k���U�v�^��6�l���U�*���$u��+D������)�ν50�lC�ɥ��4+��
m����J�1^`���{�*wO��� �N�-�#�.��Bq��yi�����$�@��� (Fgjh���o�����I�|�~W�i�i��X�~��3e�%�Ӂ�B1��i~��>���m#���nS��j~r���?F�l���D�2���m>�	�[Ëm��M�@�7Ǯ�����j�L�N���k~��b�w�P@'��ej���\Xs3��Wۂ�!���<��x���H&r�a$��P���ʳQ��R�0�<k����X��=��f�t��5yh�7#|9���Ә9/ �\��Y�fWךS���VFI�+��5�n���L��W��2N���	A�w��Ȁ��InQGV���D�p���g!�.w�Iun�U��k�1�L����M��?���Yþ���Tʡ.�x'L�QȂ�_�c��Z����O�͡|����:+`��1g�Z�ݹ%���ු���D�6�L!���v�5�die���%��֞%�@�
� t������X�����ߛ!���\VD��ԕ�
G��2d�e����0��SkC~�g�:j3vW��46v8�ܾ7ۮ"�Q��8h�r�I�G�K����D�2�7�-H\�� �	$�����y�f���F*ׅ*a"Q�/u���<������
��o���3/2J�hq�
��F��ry��w�Q��v��U����m���`�FM9��ͥY֣��L\38���_p=���1U�i�bx��Ȃ#�<D�-�!W��]�O �j���mL,��Ҵ3��v�a˚,���G?t��j3P����=���Sn� K,Zj��`�JEc�� �!�'Cm3�@)���,�:��g�w��0t���̮��ɂ�'�C�y����J��v�|�6,�����b�BaZ+�މ$����� ѺZ6`y]0ֵO�'#���g޾̝  [?����	���?��ؕ�
���xr?���x�>uB=�נ?������ߧS%$�����d��ު���q�P��6��'���r��X���4�Ln�(�K�xIFX3k��I3 � ��M^�ƿ*X"/����o��Ps��έ�3!Q���W���6��I���D	-��'c�F���(�&��Xl]�U�Av<�Y_�d�.����l��j�EJ���f,���z^�H���ϲ�2.K8���p@�)U� nP�p�h�������ú>WZP9>$�x:hAՋ��G�H��颭@7W�ݓ��=1�`��fݠ��{|�7�1*�JU��A·���� ��0M�S6�h�q���3{i��ҎmJ�hwj.�j��U�=�O�����@$�r�8�Ë��=�����mj���ԩ�K<F�k����9�����D�����=8_���7���������VY�[����j�H�W���(>/�1����ftb�0�ꥠ�3��?�z��ЧD��N����w0%)�w)'�y�֙P�b��,�d�DR���~6(:5HA?�Aw�xmS�l�Gw��!�{�
�8͕��D�-[X�n|���S����EyumQ�7��"�����.b�j�v��j���j�菅:�;�͆I��ɍ(��Q��oq�u]����J��:�9B��B׹D��n~��>FZ�>#�����v(�� �j��l�^�����yR?�����b>����^K�3I���WK^(��ńC���4`}�h�<��1��KE��U��췾������zVR��@��s�{��YIbl�4��X�{sP�x(m�ˉ��K9�)	D �m�\�[E���@Ӡ�W)�D�95�H�6��hQkx/X�g�����Sү������KU(��*�NT�Īh9��	�T���:�]�/Px���uR�����(!ڠ��#Ϋp�h�?���
7B	��n#l����v3#Y|���zڝ&0	̑�k��nR�&0���A�'��f@aE*'�֭a�-��j�Z5� ���v���B�X���zK��K�b�`� �A��kb9��qWA���9�O@��楒R��q����3��f)����=@���U�������-���lܴ6"��)�>=Q�3���K!.r&c�^{���3��XY��Hֆs��!\\��ڦ��/s�G\w�����R��3c�4�:������>g���MO�v�|1SB�#w�6c��6��v���Z�1�u5?�"������*����mٍ��۪ROP��)*xC:�n�J�oĞ�N0Q�by��/U��@c4����)��;p����{�ZԾ�N1��t�f��A�04���I, �L/9�R����ٝA%�!HK���2�Z��Ck
��km տ��A?W��ēg��j�}����p���`�`{*<3.��%����ē�AG�n>�߂n~��ш��ya>�(o-��R���v*-�^w�+o�"�	��{�eC|�cI�^�5�XX)�>�b�lZk\�=�I��)@���ds�V�ڮpF�\}���I�K��4o���|���y~�~B�FZ��G0���R�$�TrX�|Cr�l���(-��}�R㳎9Y�{�4�c�J@}!KZb�¢��:4,�#��Z�n�y/Կ���r������~��]$�"��I�]����P�"����N�i���C���Es���ґ{Ƚ	Ȏ��jS���^���'����Y.2N:��6|mRգ� �'��������c8gd܆=(y$��@cF�š�Zȑ��d�Fz�r�(0��I�;ү��ˋ��D���1�E�n�8�]ӳ�N�o� �l���$~;��=��qu��㠘h�4`�u�p"
9�S�\�}8e��U�����%b_r����q0Z�B]ѭ4�< �0�8������ԫС�=:�b[!�FK�$�Y�.�Z>�֟R�'b3�@�A%���L����N;�^�ˮX��]��ɳEu_E�Ua6�w�w:��2z��5�/�cm4��u<#�;�����v��$�E<j�Ηq鮎_"�wd�T�Q�y	�������\d�m}�z֣��Cͭ>A6�]d=����͞�1��z��ʏ�mCo��3/����#��]�0��X����8ڇ�+�L,7x�f��NA/i+'j(����(I�u��큤d�3�,��x�sQo���n�ً#*>%���*�J�F|l�n�}��9�RW`�{�׵ѝ���m%u�S���yO�Ъp��i@�]�DWw�9jc�z}��M�_�� o���ă���h���*�䰁�� 5^d嫋Ld�g�H�n!Y�#�ʯ�Y�d�+(|�*BD��
�Cd؊F#���k��8����z�-+�Ksj �N�g�g�+�ڠB/z�̥�KZ2	]��#J��L:���Y�3��K�avJ���Wn?5��>^�1_kuF���SNo�]�
y�X���=����a