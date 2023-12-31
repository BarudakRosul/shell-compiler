#!/bin/bash
#
# Author: FajarKim (Rangga Fajar Oktariansyah)
# GitHub: https://github.com/FajarKim
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
]   �������� �BF=�j�g�z��"�gV�>�5I��D����k̅�LH}v�OP.�� �p1M�,�3T�S��`>� �^����RKuy0��!?�c}�6��[�|�,%�F�m�r�[ߠ��'�VG#�ϸ��H��x������O�
�&�F(+�R�f&8� F~�<�>��q݂.�x���'���B�f-'��پ֮�f�\d'�`ނ$��ߴ�j��H!�ҽx,�/m�˱e��M��/��A���Z��`�4H�3����/6H����eo=�7Ԝ,���jm�_��XB��HT�m��a�@F�@_@	Zo� z����dm��K`�g��5�ב���Y=�!�k�7k��X�W�$����B�h�BH�98�����f�,����u(��<�f�H��`LpЦ�yl�U�Ӹ��G��ޥ%�����)�"�[����0A�W��]���$�e哊��R{ai���ŉy,���}�B��נ�q������Y��3b�'W�� ��(s���S�خ�q~�n�O:�a��it^����Jn3�����2ؘNc��^,ܲ�-�'`,��z�����Z�����t9Z[7Pt?��Gf�{�J�47��Z��ws~R��YP�Y	�O Z��>�Z�zi��&�VM��ޯ� ��\�������8��)z�e�&�4���Hx���sw��x[�Z���<
��/�k�B�J�:;�y�g���a���Q�o�{"ăg�E��h��B�^�=uu�P�:Iy����fHUq��E���Ff	�ܶ!�����7f�lY�y�J\t.;��E|pסc㝝򎋻@�c����N���9J���X����9�|W�옪���f��*\\�f�b9�P_�#^m"��:`|G}0<�B���;�ztA�Kt�g.���9K��$e���F�R�T�C�+�^V�5��>����;/<DeQ
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D ��yA8�-��+�87�z�7�!�N-��h�����ҭ�0Z�U1p.�E�(��/]_�� �><@Ө9�k�w��l��z����#���n{������������'s��
���SF�(���z���؊8DbI����������|4K�Q1��"t��rNS3��55������(��U%g�EcD;ʜ���w9E~׊����F��0�B0����A~���?�����>�(B�Q�hӯm�X:�
S+�k��Ԡl�l���Zhe�R��T^�>�l�����T���$A��~$�mi�����u@dzm��Hc�����$,��XcwC J'�ND'�N�)*V�2A��P��^�VY����]�d���ݻ���V�� �恼(i �4S�-!���bb���HV@,�qF#���jV���|՟A��V��I<�R���ޮ>��o��"��x��
��L?��w��L����L<�4e+�Yۈ�%|.jVש&r� }g�
�`�9i� ����«��5��	2��6�8���	V�0S�����*io�뿛�_��5a�f}Op$�g{YV�9�O���+�qSUq*$��3�A�u��ҘeO�<���o�SoU!�nJ5t��q\���clM!�St!���+B�<i���Bc��Ϯ��QiK�k�vL����߂�RI\�ڈ�JM8`o
�V;/��KjB3�{��y�b�K�
���+��?�oB��ߠ�q�0��l����۬�أ\�ha�c�n�2=!�%��?հ��gxl9�H._���G+=%'��g9��2�Zxikjv�>Z}�C����J�]��O 1�q��6��;(��j�I)|]/����E���9��wk�>� ��c�"��C�tu��"�����4����$���cV��=%+:�<o���u��({��פ�i���伄Q*�'�.*XX����167�>pW}������6eL�G��QQ�Ao:,L��ɺ���7uz�D�� �В/�;��T{���$ƫ��Pj�n��i����C�b��@��\�k��%O�B&�^�h֮%�����5�'��KLuy��o�Fߔ��u�j�Oگ3Pܣ���j��^�X1:�Rϯ�m� �ƽ�-ӝ�E�s�:κD0�Y	qB��ׯ����b�0�`E�=�\��`����E�kkX�YJ�I�|�Kcu�����~�]d��)d�6$�)��x;G�Z�:v8Y��@�,v������M8�4�\�gi����$�ia=Z9�1j5L0��7WA���?3
����>Y~+��d�W_s��8j"O0��[�_d{k�w�br��ͶBO�g9���vo�>I���^|�]��hK'���	��?�S��bM$��Za5SKB���P1���\�pM�
U��h?��ƴ3���庖��Js,B{#�&�6P��ڛ1��������ҏ�7g��w�p���Fx���-�~��!���� B��}m1�P�>*�M8�6!yt���~���ϓy���wiK��js;��j�=#t�`l�DM>9������ǥ���E�M���(����#�a��<+%Q��+�Sʴ=�h���z8o%����>�L�W�h>�X-$�bU�w��� �'��?���ȅ~��wU,��(��ݖpBڟM�k��fD͝���J�y>�Q���}V��@�� ���.$���\E,Y�:lKP�&�8���
'���jF%Kk����]n|9�0QP��MK��͵�'R	�1��Q��S��tG/MD$.��f��O��P�1?�y��3w�$�����!�8�<7������ p�t1����̿��Z���S��������=e��}�4�SIJ���Y���Shb�]��+
���C�Jf�ґ�Ņ�gR��Fŭ���:U$��妃��<�օ�4d�	�x�v��ܦ �d[�-�+�"�j׮��I�E��W�̱���Hy�YS�?�_���e4��@�)A�?�L�2���{{PSA�Ɋv��eGO��P<����B#ۡ�z�i��ײu7�,�I-���
u��ek�Xs�X�9SL��T��<U��!ץ�`�Ye��u��/�eJ5N��Q���a���H:P�1m���*C�0Ң�ϳ�^m~�$����Rp���6�6{?�?�?�y�`�	�Qz����C)���"ndS�1�N�=�f����&�SO����m����B?Ax^\?��ɱ�.�z�Ěj�no)�5i��O\�Sbl���_��_��O�$��Wuݐf�����؁��Ӈ@^��d�����.�>�3�X�@��h�t���!��`'.#���}�^��~�qDM���b��X�6����[i�ٹ��|��|ذ�m\E�7e<Ǡor�Џ"�#$K�4 �P��d-�(�-��w4Suy|��$172���
!�0>�9,Y�Y�&�S�3�v��)]pC!�l�ē��4�JK:��KCڐ��a\�����z�3��$r��C���y�����<���R��J��e�4Ru�[Hh�l���l�A-[�{3��ec��e���_o��xN��^��F�ftA�`�h��W�������t�̞[��^��.����q�)Cm�!�5�p����K>�=��iU'W��^�e�ɞF�s����a��r�U�,�@�g�`󝡕�]�4]��N��jD����'�Y���)Qr�O����#�.ޏ!T���;����F���Js�G��A���v���vF��|e?��U֘�X $1�xpξJx�AV��B����/�c��8�qf���}	7�E���`���5��l(YW	���8(�7�a4��O��J���P}"0n��<�+Mo�{	�,>����Թ�[�{�t�f�]�3Q��e�G
�ɛ>Bě��,���z{�c�����O��d`4�O,o�13�0�zΉj�i̊)n�K�Dl��L�	w틃^ (
��p�-fhY�I\�F��CD��K�p��U�"�5��u��N%�fp��1�ǩ���)��-���0m�a@�X(5#א��>�kY��-*��6��o���=r4H�p|0�	Z5�2!*e��I�Eѱ��:D�3NT�}L�j�L�X:Ʃ�[����%����B���ڕ�Nڲ
���w$
��Nr�"W(��gq<�_��HL	B��.V�@U�U�������Z���Ƅ��ד3�p��jZcӬ�&8��AUT�Ọ&z��ϰ��)΅{bx��/�C��A��`�U�7K7c����K���F9#��>v/�ݣ���F3��*
�/^ $�
����8i�!�oB:?�Y{���<A���������lh��xx�oO�D�ܦ�Vi�"-�ܯ(�M�Y�|�)=9�6���nx�LÄ�g�5�wc�	k���8�]�} �+�/%�����V�:������<j�ua�ݜ�V �~�T	y�����.��&T��\�k�ԺלiQgXvt>�=�H,߶k�b&�F��^J�&�7����k�fTbW4\�q�H z����yl�h��#��Ɣ��IW�)��y0���c��.2Wd��L-�� ��9����ĬB��y�+��K:(�pq��[o0�����R���Rπ<��Ȓ%H�p'���1qr݈*t��!��s�x]B���O�s�¾��6v��<~�\��F�>����-�%@H��$uO�>�םaVy�]�������O"ى5/T������~�=~ �:��_j�u�W��n�D+Yaw�]�#��2$?HsHm*�'`��Ks]̧�>ax��1��s�Z�\���sP ��vXp���G��Ɔqr
n�Z�pIF5��>��q#0ۼM;x"k��o��zh`68\�n�Bp����7��u&!`�cY�h�=s�h��w��r���u���N�$�ѓ���F��S�L���@D�Ǒ��%j��qg�7cRsGT�k'jy ^����e���(z�G��3��](b��>�����O�a��F������Lp�-�n�e-Y]������r����V��_M���r�����!�� �i�SA�����m���tj�5l|g�\��b�<��;�Yjh�	�C�3ێ���-�^