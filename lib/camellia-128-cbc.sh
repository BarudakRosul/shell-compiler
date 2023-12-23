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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЉWg�k�}�?��1Z~@�<�r�}�L�2,*��s�Д�0(��8��-�r�UPW���ˑ�`v���T�}P�h+@'�ű����|�
��'�h���>��^����(�����F�1t��ٮ���$��>g?a�A�pp��%<�ig�`�a&����
�8Y����"4���1�ک�MT�76��0\�����҃X}�c+��;aS3C�k�n7�;T��7�|4����:���b,'S��s���*J�V"��sD�5f%��}�fӀ�0N�s��� �_ /���R-A�f{�<�ك��xW#Ppp�|Waݵ�Kao���[4>:�>�u�3��ww~#z��[���{��oԀa��*�H>���9Voj�~_���!-�'z���g�K6�Q���DY�U�G8�z|�
&�Fi�E�X:
U��?�nI_��N�Bh*Iɰ t
�6iB��f���7�I�[���D�9kO���Ӥ��.ay�8��AZG�-�%\�ҍ��`l\�$�d��T�%̕jA���#ճѾꖕ��P绬SC�g����FRW�C���L�/H��MU�AK���{4�J�+��F���됶�NA��r�6��ӂ\& ���RU��.�<W��t���:��X��bK�J�j(���-��[��������i�RusZ�^MOo��?;>#\���
*:A��Y�hk�v�ÕJ:q��dt�Q�M�(a8�p.mZ5M��i�D�5�J�R�֞�C4��L%o�y���U�H,>���H�O==��[K�F��������h������C}N�l0<A�x����&��Y�|��UW�$.Yd#�i�y��}���8��#L<�n�w�җ ����Xş����)d��n4��C���o
9��pc-#�ջd7��w�h�<@ORQ>=��1#H�ڏ<���'򸔑�!�\�DT�<v�|��j[wT`�;Q�V����hu�֭<�cB��o��A$�N?�9��}u��1��@ޭ��GU�V"k��|�Vny9�4#$�FԱ��e��aG�N#F�&{</1u)��S}Ĩt�NV[6������6��{%/#�fDuL۝[*����*�©���$��J���ۃLAf����/�:I��IE`&�.)@s	pOoW{����_�d��'9�Dɩ�.|nX X���\9o��H�W�x�9���y����t�lov� ;6��N�Cl�բ�mDs���/	�=`S��w��
�g÷|E|hP�\�%��*�^:���:��m$����?��ya$[hr����r,*�@:���a���B
ɴ���Y����� ��I�b���n��#qS/�_���O<����WYJ�i 2y� ���☈'��3�l����~��sF��r�AαE��J>8���we����;A�;(�̤}��ͣí�3~���ԑ{#ŭ�Q�����]MP7&��;K��n)�	�2p�t�&V�^���$ ��a���3,7I��;�D��ɧs�|�[@<�Ý�(��1)tڪn9��K>��/�Պ���电��b��03�Ԅ�
���~�����ݠ�<R
1��'����gh�>Q��
�����D!VI�� ��Ru-D_����y�{��6Ĭ(����p(�70

�X�@�)"x[���"��	�e�̻�w��<�C�@�bzu�DK���H�������8��9��s4�Zx��i�q�\I�N)��4*"�]N|�GZ�{���j\(���$N���6��`�|d/v��BQW2=K3�ԭ�=X{�q����V�}�E�Ӳ���gEf[Cp���
�a7����d*$� ��g�r��t��@T)���1����1٪1y�%K��TLf��x9�,ۈ���蕛E��`=��	}>d`]E�
�4+H�^Yxb;KT������΀��������I�!�Sm ��T�c�T��=�EC��-����B�����爱ךI��Wј���y�Sz��P{��7��l�LqA��{`����A;�7�u�z� `��G���4��Wඕ�kz.Aa�k�i�b�Ș-�i��5���t�<��<���+/��pY��X>��qBw䃉��&�������t�m��d
��	c%Z���=��R��1�f\�U�<'�e�\�lW��r��3&��~k=[Ҋj���Q�^��1&"�������pB��c�f-F@!l�o7�#��x,���;��旻��$\E����|���:�R���>1y5��H������-3��4uS��xvϹ*�jo:D������p��Z����ZtW̹|0�ۄ�����Ն}+`�p��H�b��{Z�p���DG��6��G0�0��<� ��<�P�����)R���<� �[�A��{��/`��+�l�Ƌ��uC�;K�DU��'��`H��|���PX�I��w�y����gР�Y	T�n� [@�sı^��"���ӑ���]o�&{c��3|�/�tn~/W�/�����;+
���@�ˉ�F`8�˥G��i�n�DJ�G�Չ�|�ǥ��a
�W ����H����%���+�T�p��GK��} Ar�w��䋺z;��j��κ-
I!�N�WSO��NՅ�&Z���5�4���T���( ��:߭[
�ܟ}:�r�Y��'a첥�֋"�09��p�`�1Z�"��Mc�uE�4<,3����� �C0�޺��7Q��8��8T_I���E�1y]���=`�=l&���)�����=�hZU
b(&/�@6�^��z 3�$�	E�f��,礵&�V�j���ʏ��JB�X���

��סFǞ-�=�E@W��x�6��#�$50��z���
O�r���ik^��=	��H�'�� -5�T��{���n��t�j�CcK0ζ�#�j�(����UzfY �%x��;��J���&9�ȀN�.ܯ�@�䩳!��,�S����6�I ��}C�Q�͗Uy�H���ְ)B�B�� ����E[����tXo� �#��2��v���1��)�Ԯ&��~��E���:���Br���Ɵ�6[������?"rmS�~���W\ܹ�6_ˎ~���v��yZ_n�2��{�����c�]d����v����b�>���1��4�4��b��V$�U���[v�H��},	�m�Qȿ1� w̉AԘ��s���rP�2��M�r�r�bV*�zǍH(���*�@�D�x+��Ha���ܺ�c�e���`�fe��46���L�@ѠKje��ͺ<d&�mܜ��o���݃��U�$��1�q���,~�l�A�e�'�e����/N��%P�!9VaU�x��@N�S^ߒ�Bori;N^��=�-Ǩ�_�8����&�I��m<?���->G�DM~��:8�?c �m���E�����Z<�!QlI8l�L����$��J��
�Bh/�=c�j��`��j<�k .O·��L���^R�/� ���F!.p�x���Yߛ[�=r��K��j��SLΐ������+�x�%Z����:��ȋ�	���j�c��-zIڑ��F-hM����}��ʡ�%������nD(���3ّ�j��Sr����v��>Q֨����� R����	̴���D}7 �v�Ӎ�
:nB�v��ôV��v���Bh%��?"ՙʲ�qOL��S���~�<�y^0 2�#Ǹ�cD� ���b�̂Ʉ|��[���W����DC����>8�FPq�7�&��_��Y�)����+�pOm5����mD"��h���Ӗ�8*��۔`C��}Y����}#��0w5_��cE����ݏ���JH�7����T�!e��ִ�h�D�UyLɸN�6��~q�ΔɃ/
�Ǩh皭Q���L�-������R����8s��L5���yk[=�= ���/x���'0U�[��+�'�K����W�LU��p*�'��	Cn@!�9%�x�6�[�j� -gj$�d#)ޱ�Z���0 ����F1?��FNSQ�`��e��C����-�